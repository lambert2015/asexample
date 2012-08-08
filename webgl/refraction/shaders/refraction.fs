
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




// Shader to refract all pixels with their alpha channel set to 0.



#ifdef GL_ES
	precision highp float;
#endif



// Uniform variables.

uniform vec2 ImageSize;
uniform vec2 TexelSize;
uniform sampler2D Sample0;


// Size of the refraction.

uniform float Amplitude;


// Frequency of the refraction.

uniform float Frequency;


// Relative speed (period) of the refraction.

uniform float Period;


// Random number to animate or mix up the refracted results.

uniform float RandomNumber;



// Varying variables.

varying vec2 vUv;


// Description : Array and textureless GLSL 3D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec4 permute(vec4 x) { return mod289(((x*34.0)+1.0)*x); }
vec4 taylorInvSqrt(vec4 r) { return 1.79284291400159 - 0.85373472095314 * r; }
float snoise(vec3 v)
{ 
  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

  // First corner
  vec3 i  = floor(v + dot(v, C.yyy) );
  vec3 x0 =   v - i + dot(i, C.xxx) ;

  // Other corners
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min( g.xyz, l.zxy );
  vec3 i2 = max( g.xyz, l.zxy );

  //   x0 = x0 - 0.0 + 0.0 * C.xxx;
  //   x1 = x0 - i1  + 1.0 * C.xxx;
  //   x2 = x0 - i2  + 2.0 * C.xxx;
  //   x3 = x0 - 1.0 + 3.0 * C.xxx;
  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
  vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

  // Permutations
  i = mod289(i); 
  vec4 p = permute( permute( permute( 
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

  // Gradients: 7x7 points over a square, mapped onto an octahedron.
  // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
  float n_ = 0.142857142857; // 1.0/7.0
  vec3  ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

  vec4 x = x_ *ns.x + ns.yyyy;
  vec4 y = y_ *ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4( x.xy, y.xy );
  vec4 b1 = vec4( x.zw, y.zw );

  //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
  //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
  vec4 s0 = floor(b0)*2.0 + 1.0;
  vec4 s1 = floor(b1)*2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

  vec3 p0 = vec3(a0.xy,h.x);
  vec3 p1 = vec3(a0.zw,h.y);
  vec3 p2 = vec3(a1.xy,h.z);
  vec3 p3 = vec3(a1.zw,h.w);

  //Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;

  // Mix final noise value
  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                dot(p2,x2), dot(p3,x3) ) );
}



// Compute the normal using a sobel filter on the adjacent noise pixels.
//
// Normally you would output the noise to a texture first and then calculate
// the normals on that texture to improve performance; however everthing is
// kept in this shader as a single process to help illustrate what's going on.

// <returns>A normal vector.</returns>
vec3 GetNormal ()
{
	// Get Sobel values
	vec2 uv = vUv * Frequency;
	float z = RandomNumber * Period;
	
	float tl = snoise(vec3(uv.x - TexelSize.x, uv.y - TexelSize.y, z));
	float t = snoise(vec3(uv.x, uv.y - TexelSize.y, z));
	float tr = snoise(vec3(uv.x + TexelSize.x, uv.y - TexelSize.y, z));
	float l = snoise(vec3(uv.x - TexelSize.x, uv.y, z));
	float r = snoise(vec3(uv.x + TexelSize.x, uv.y, z));
	float bl = snoise(vec3(uv.x - TexelSize.x, uv.y + TexelSize.y, z));
	float b = snoise(vec3(uv.x, uv.y + TexelSize.y, z));
	float br = snoise(vec3(uv.x + TexelSize.x, uv.y + TexelSize.y, z));

	// Sobel filter
	vec3 normal = vec3((-tl - l * 2.0 - bl) + (tr + r * 2.0 + br),
						(-tl - t * 2.0 - tr) + (bl + b * 2.0 + br),
						1.0 / Amplitude);
						
	// Return normalized vector
	return normalize(normal);
}



// Fragment shader entry.

void main ()
{
	// Refract only tagged pixels (that is, the alpha channel has been set)
	vec2 offset = vec2(0.0);
	if ( texture2D(Sample0, vUv).w == 0.0 )
	{
		// Method 1: Use noise as the refraction angle.
		// Fast and good results for some scenarios.
		//const float pi = 3.141592;
		//float noise = snoise(vec3((vUv * Frequency), RandomNumber * Period)) * pi;
		//offset = vec2(cos(noise), sin(noise)) * Amplitude * TexelSize;
		
		// Method 2: Get the normal from an animating normalmap to use as the refracted vector.
		// Slower, but better results.
		vec3 normal = GetNormal();
		offset = normal.xy;
	}
	
	// Use the colour at the specified offset into the texture
	gl_FragColor.xyz = texture2D(Sample0, vUv + offset).xyz;
	gl_FragColor.w = 1.0;
}