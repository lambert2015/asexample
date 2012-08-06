/// <summary>
/// Copyright (C) 2012 Nathaniel Meyer
/// Nutty Software, http://www.nutty.ca
/// All Rights Reserved.
///
/// 2D Noise
/// Author : Ian McEwan, Ashima Arts.
///	Copyright (C) 2011 Ashima Arts. All rights reserved.
/// Distributed under the MIT License.
///	https://github.com/ashima/webgl-noise
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
/// Fragment shader for performing a seperable blur on the specified cubemap.
/// </summary>


#ifdef GL_ES
	precision highp float;
#endif


/// <summary>
/// Uniform variables.
/// <summary>
uniform vec2 TexelSize;
uniform samplerCube Sample0;

uniform int CubeFace;
uniform int Orientation;
uniform int BlurAmount;


/// <summary>
/// Varying variables.
/// <summary>
varying vec2 vUv;


/// <summary>
/// Gets the Gaussian value in the first dimension.
/// </summary>
/// <param name="x">Distance from origin on the x-axis.</param>
/// <param name="deviation">Standard deviation.</param>
/// <returns>The gaussian value on the x-axis.</returns>
float Gaussian (float x, float deviation)
{
	return (1.0 / sqrt(2.0 * 3.141592 * deviation)) * exp(-((x * x) / (2.0 * deviation)));	
}


/// <summary>
/// Fragment shader entry.
/// <summary>
void main ()
{
	float halfBlur = float(BlurAmount) * 0.5;
	//float deviation = halfBlur * 0.5;
	vec4 colour;
	
	// CubeFace will be +X, -X, +Y, -Y, +Z, -Z
	vec3 dir;
	vec2 uv = (vUv - 0.5) * 2.0;
	if ( Orientation == 0 )
	{
		// Blur horizontal
		for (int i = 0; i < 10; ++i)
		{
			if ( i >= BlurAmount )
				break;
			
			float offset = float(i) - halfBlur;
			if ( CubeFace == 0 )
				dir = vec3(1.0, uv.x + offset * TexelSize.x, uv.y);
			else if ( CubeFace == 1 )
				dir = vec3(-1.0, -uv.x + offset * TexelSize.x, uv.y);
			else if ( CubeFace == 2 )
				dir = vec3(uv.x + offset * TexelSize.x, 1.0, uv.y);
			else if ( CubeFace == 3 )
				dir = vec3(uv.x + offset * TexelSize.x, -1.0, uv.y);
			else if ( CubeFace == 4 )
				dir = vec3(uv.x + offset * TexelSize.x, uv.y, 1.0);
			else if ( CubeFace == 5 )
				dir = vec3(uv.x + offset * TexelSize.x, uv.y, -1.0);
			
			colour += textureCube(Sample0, normalize(dir)) /* Gaussian(offset, deviation)*/;
		}
	}
	else
	{
		// Blur vertical
		for (int i = 0; i < 10; ++i)
		{
			if ( i >= BlurAmount )
				break;
			
			float offset = float(i) - halfBlur;
			if ( CubeFace == 0 )
				dir = vec3(1.0, uv.x, uv.y + offset * TexelSize.y);
			else if ( CubeFace == 1 )
				dir = vec3(-1.0, -uv.x, uv.y + offset * TexelSize.y);
			else if ( CubeFace == 2 )
				dir = vec3(uv.x, 1.0, uv.y + offset * TexelSize.y);
			else if ( CubeFace == 3 )
				dir = vec3(uv.x, -1.0, uv.y + offset * TexelSize.y);
			else if ( CubeFace == 4 )
				dir = vec3(uv.x, uv.y + offset * TexelSize.y, 1.0);
			else if ( CubeFace == 5 )
				dir = vec3(uv.x, uv.y + offset * TexelSize.y, -1.0);
			
			colour += textureCube(Sample0, normalize(dir)) /* Gaussian(offset, deviation)*/;
		}
	}
	
	// Calculate average
	colour = colour / float(BlurAmount);
	
	// Apply colour
	gl_FragColor = colour;
}