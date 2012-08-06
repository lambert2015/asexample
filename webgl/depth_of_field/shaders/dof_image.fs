/// <summary>
/// Copyright (C) 2012 Nathaniel Meyer
/// Nutty Software, http://www.nutty.ca
/// All Rights Reserved.
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy of
/// this software and associated documentation files (the "Software"), to deal in
/// the Software without restriction, including without limitation the rights to
/// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
/// of the Software, and to permit persons to whom the Software is furnished to do
/// so, subject to the following conditions:
///     1. The above copyright notice and this permission notice shall be included in all
///        copies or substantial portions of the Software.
///     2. Redistributions in binary or minimized form must reproduce the above copyright
///        notice and this list of conditions in the documentation and/or other materials
///        provided with the distribution.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
/// </summary>


/// <summary>
/// This fragment shader produces the final image with the DOF effect. The blurred image is
/// blended with the higher resolution texture based on how much each pixel is blurred.
/// </summary>


#ifdef GL_ES
	precision highp float;
#endif


/// <summary>
/// Uniform variables.
/// <summary>
uniform sampler2D Sample0; // Colour texture
uniform sampler2D Sample1; // Depth texture
uniform sampler2D Sample2; // Blurred texture

uniform float BlurCoefficient;	// Calculated from the blur equation, b = ( f * ms / N )
uniform float FocusDistance;	// The distance to the subject in perfect focus (= Ds)
uniform float Near;				// Near clipping plane
uniform float Far;				// Far clipping plane
uniform float PPM;				// Pixels per millimetre

/// <summary>
/// Varying variables.
/// <summary>
varying vec2 vUv;


/// <summary>
/// Unpack an RGBA pixel to floating point value.
/// </summary>
float unpack (vec4 colour)
{
	const vec4 bitShifts = vec4(1.0,
								1.0 / 255.0,
								1.0 / (255.0 * 255.0),
								1.0 / (255.0 * 255.0 * 255.0));
	return dot(colour, bitShifts);
}


/// <summary>
/// Calculate the blur diameter to apply on the image.
/// b = (f * ms / N) * (xd / (Ds +- xd))
/// Where:
/// (Ds + xd) for background objects
/// (Ds - xd) for foreground objects
/// </summary>
/// <param name="d">Depth of the fragment.</param>
float GetBlurDiameter (float d)
{
	// Convert from linear depth to metres
	float Dd = d * (Far - Near);
	
	float xd = abs(Dd - FocusDistance);
	float xdd = (Dd < FocusDistance) ? (FocusDistance - xd) : (FocusDistance + xd);
	float b = BlurCoefficient * (xd / xdd);
	
	return b * PPM;
}


/// <summary>
/// Fragment shader entry.
/// <summary>
void main ()
{
	// Maximum blur radius to limit hardware requirements.
	// Cannot #define this due to a driver issue with some setups
	const float MAX_BLUR_RADIUS = 10.0;
		
	// Get the colour, depth, and blur pixels
	vec4 colour = texture2D(Sample0, vUv);
	float depth = unpack(texture2D(Sample1, vUv));
	vec4 blur = texture2D(Sample2, vUv);
	
	// Linearly interpolate between the colour and blur pixels based on DOF
	float blurAmount = GetBlurDiameter(depth);
	float lerp = min(blurAmount / MAX_BLUR_RADIUS, 1.0);
	
	// Blend
	gl_FragColor = (colour * (1.0 - lerp)) + (blur * lerp);
}