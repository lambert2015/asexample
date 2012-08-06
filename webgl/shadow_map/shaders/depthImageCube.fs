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
/// Fragment shader for rendering the depth cubemap to screen.
/// </summary>


#ifdef GL_ES
	precision highp float;
#endif


/// <summary>
/// Uniform variables.
/// <summary>
uniform int FilterType;
uniform samplerCube Sample0;


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
/// Unpack a vec2 to a floating point (used by VSM).
/// </summary>
float unpackHalf (vec2 colour)
{
	return colour.x + (colour.y / 255.0);
}


/// <summary>
/// Fragment shader entry.
/// <summary>
void main ()
{
	float depth = 0.0;
	
	// Determine what cube face to render based on UV coordinates
	vec3 dir;
	if ( vUv.y < 0.5 )
	{
		float y = (0.25 - vUv.y) / 0.25;
		
		// Left
		if ( vUv.x < 0.33 )
			dir = vec3(-1.0,
						y,
						(vUv.x - 0.165) / 0.165);
		// Front
		else if ( vUv.x < 0.66 )
			dir = vec3(((vUv.x - 0.33) - 0.165) / 0.165,
						y,
						-1.0);
		// Right
		else
			dir = vec3(1.0,
						y,
						((vUv.x - 0.66) - 0.165) / 0.165);
	}
	else
	{
		float y = (0.75 - vUv.y) / 0.25;
	
		// Back
		if ( vUv.x < 0.33 )
			dir = vec3((vUv.x - 0.165) / 0.165,
						y,
						1.0);
		// Top
		else if ( vUv.x < 0.66 )
			dir = vec3(((vUv.x - 0.33) - 0.165) / 0.165,
						1.0,
						-y);
		// Bottom
		else
			dir = vec3(((vUv.x - 0.66) - 0.165) / 0.165,
						-1.0,
						-y);
	}
		
	if ( FilterType == 2 )
		depth = unpackHalf(textureCube(Sample0, dir).xy);
	else
		depth = unpack(textureCube(Sample0, dir));
	
	gl_FragColor = vec4(depth, depth, depth, 1.0);
}