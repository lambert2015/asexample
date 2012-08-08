
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




// Fragment shader to modify brightness, contrast, and gamma of an image.



#ifdef GL_ES
	precision highp float;
#endif



// Uniform variables.

uniform float Brightness;	// 0 is the centre. < 0 = darken, > 1 = brighten
uniform float Contrast;		// 1 is the centre. < 1 = lower contrast, > 1 is raise contrast
uniform float GammaCutoff;	// UV cutoff before rendering the image uncorrected.
uniform float InvGamma;		// Inverse gamma correction applied to the pixel

uniform sampler2D Sample0;	// Colour texture to modify



// Varying variables.

varying vec2 vUv;



// Fragment shader entry.

void main ()
{
	// Get the sample
	vec4 colour = texture2D(Sample0, vUv);
	
	// Adjust the brightness
	colour.xyz = colour.xyz + Brightness;
	
	// Adjust the contrast
	colour.xyz = (colour.xyz - vec3(0.5)) * Contrast + vec3(0.5);
	
	// Clamp result
	colour.xyz = clamp(colour.xyz, 0.0, 1.0);
	
	// Apply gamma, except for the alpha channel
	if ( vUv.x < GammaCutoff )
		colour.xyz = pow(colour.xyz, vec3(InvGamma));
	
	// Set fragment
	gl_FragColor = colour;
}