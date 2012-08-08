
// Copyright (C) 2012 Nathaniel Meyer
// Nutty Software, http://www.nutty.ca
// All Rights Reserved.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//     1. The above copyright notice and this permission notice shall be included in all
//        copies or substantial portions of the Software.
//     2. Redistributions in binary or minimized form must reproduce the above copyright
//        notice and this list of conditions in the documentation and/or other materials
//        provided with the distribution.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.




// This fragment shader performs a DOF separable blur algorithm on the specified
// texture.



#ifdef GL_ES
	precision highp float;
#endif



// Uniform variables.

uniform vec2 TexelSize;		// Size of one texel (1 / width, 1 / height)
uniform sampler2D Sample0;	// Colour texture
uniform sampler2D Sample1;	// Depth texture

uniform int Orientation;		// 0 = horizontal, 1 = vertical
uniform float BlurCoefficient;	// Calculated from the blur equation, b = ( f * ms / N )
uniform float FocusDistance;	// The distance to the subject in perfect focus (= Ds)
uniform float Near;				// Near clipping plane
uniform float Far;				// Far clipping plane
uniform float PPM;				// Pixels per millimetre



// Varying variables.

varying vec2 vUv;



// Unpack an RGBA pixel to floating point value.

float unpack (vec4 colour)
{
	const vec4 bitShifts = vec4(1.0,
								1.0 / 255.0,
								1.0 / (255.0 * 255.0),
								1.0 / (255.0 * 255.0 * 255.0));
	return dot(colour, bitShifts);
}



// Calculate the blur diameter to apply on the image.
// b = (f * ms / N) * (xd / (Ds +- xd))
// Where:
// (Ds + xd) for background objects
// (Ds - xd) for foreground objects

// <param name="d">Depth of the fragment.</param>
float GetBlurDiameter (float d)
{
	// Convert from linear depth to metres
	float Dd = d * (Far - Near);
	
	float xd = abs(Dd - FocusDistance);
	float xdd = (Dd < FocusDistance) ? (FocusDistance - xd) : (FocusDistance + xd);
	float b = BlurCoefficient * (xd / xdd);
	
	return b * PPM;
}



// Fragment shader entry.

void main ()
{
	// Maximum blur radius to limit hardware requirements.
	// Cannot #define this due to a driver issue with some setups
	const float MAX_BLUR_RADIUS = 10.0;

	// Pass the linear depth values recorded in the depth map to the blur
	// equation to find out how much each pixel should be blurred with the
	// given camera settings.
	float depth = unpack(texture2D(Sample1, vUv));
	float blurAmount = GetBlurDiameter(depth);
	blurAmount = min(floor(blurAmount), MAX_BLUR_RADIUS);

	// Apply the blur
	float count = 0.0;
	vec4 colour = vec4(0.0);
	vec2 texelOffset;
	if ( Orientation == 0 )
		texelOffset = vec2(TexelSize.x, 0.0);
	else
		texelOffset = vec2(0.0, TexelSize.y);
	
	if ( blurAmount >= 1.0 )
	{
		float halfBlur = blurAmount * 0.5;
		for (float i = 0.0; i < MAX_BLUR_RADIUS; ++i)
		{
			if ( i >= blurAmount )
				break;
			
			float offset = i - halfBlur;
			vec2 vOffset = vUv + (texelOffset * offset);

			colour += texture2D(Sample0, vOffset);
			++count;
		}
	}
	
	// Apply colour
	if ( count > 0.0 )
		gl_FragColor = colour / count;
	else
		gl_FragColor = texture2D(Sample0, vUv);
}