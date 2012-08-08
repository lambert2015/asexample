
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




// This fragment shader calculates the ambient occlusion contributions for each fragment.
// This shader requires:
// 1. View-space position buffer
// 2. View-space normal vector buffer
// 3. Normalmap to preturb the sampling kernel



#ifdef GL_ES
	precision highp float;
#endif



// Texture samples used by this shader.

uniform sampler2D Sample0;	// View space position data
uniform sampler2D Sample1;	// View space normal vectors
uniform sampler2D Sample2;	// Normalmap to randomize the sampling kernel
uniform vec2 TexelSize;



// Occluder bias to minimize self-occlusion.

uniform float OccluderBias;



// Specifies the size of the sampling radius.

uniform float SamplingRadius;



// Ambient occlusion attenuation values.
// These parameters control the amount of AO calculated based on distance
// to the occluders. You need to play with them to find the right balance.
//
// .x = constant attenuation. This is useful for removing self occlusion. When
//		 set to zero or a low value, you will start to notice edges or wireframes
//		 being shown. Typically use a value between 1.0 and 3.0.
//
//	.y = linear attenuation. This provides a linear distance falloff.
// .z = quadratic attenuation. Smoother falloff, but is not used in this shader.

uniform vec2 Attenuation;



// Varying variables.

varying vec2 vUv;



// Sample the ambient occlusion at the following UV coordinate.

// <param name="srcPosition">3D position of the source pixel being tested.</param>
// <param name="srcNormal">Normal of the source pixel being tested.</param>
// <param name="uv">UV coordinate to sample/test for ambient occlusion.</param>
// <returns>Ambient occlusion amount.</returns>
float SamplePixels (vec3 srcPosition, vec3 srcNormal, vec2 uv)
{
	// Get the 3D position of the destination pixel
	vec3 dstPosition = texture2D(Sample0, uv).xyz;

	// Calculate ambient occlusion amount between these two points
	// It is simular to diffuse lighting. Objects directly above the fragment cast
	// the hardest shadow and objects closer to the horizon have minimal effect.
	vec3 positionVec = dstPosition - srcPosition;
	float intensity = max(dot(normalize(positionVec), srcNormal) - OccluderBias, 0.0);

	// Attenuate the occlusion, similar to how you attenuate a light source.
	// The further the distance between points, the less effect AO has on the fragment.
	float dist = length(positionVec);
	float attenuation = 1.0 / (Attenuation.x + (Attenuation.y * dist));
	
	return intensity * attenuation;
}



// Fragment shader entry.

void main ()
{
	// Get position and normal vector for this fragment
	vec3 srcPosition = texture2D(Sample0, vUv).xyz;
	vec3 srcNormal = texture2D(Sample1, vUv).xyz;
	vec2 randVec = normalize(texture2D(Sample2, vUv).xy * 2.0 - 1.0);
	float srcDepth = texture2D(Sample0, vUv).w;
	
	// The following variable specifies how many pixels we skip over after each
	// iteration in the ambient occlusion loop. We can't sample every pixel within
	// the sphere of influence because that's too slow. We only need to sample
	// some random pixels nearby to apprxomate the solution.
	//
	// Pixels far off in the distance will not sample as many pixels as those close up.
	float kernelRadius = SamplingRadius * (1.0 - srcDepth);
	
	// Sample neighbouring pixels
	vec2 kernel[4];
	kernel[0] = vec2(0.0, 1.0);		// top
	kernel[1] = vec2(1.0, 0.0);		// right
	kernel[2] = vec2(0.0, -1.0);	// bottom
	kernel[3] = vec2(-1.0, 0.0);	// left
	
	const float Sin45 = 0.707107;	// 45 degrees = sin(PI / 4)
	
	// Sample from 16 pixels, which should be enough to appromixate a result. You can
	// sample from more pixels, but it comes at the cost of performance.
	float occlusion = 0.0;
	for (int i = 0; i < 4; ++i)
	{
		vec2 k1 = reflect(kernel[i], randVec);
		vec2 k2 = vec2(k1.x * Sin45 - k1.y * Sin45,
					   k1.x * Sin45 + k1.y * Sin45);
		k1 *= TexelSize;
		k2 *= TexelSize;
		
		occlusion += SamplePixels(srcPosition, srcNormal, vUv + k1 * kernelRadius);
		occlusion += SamplePixels(srcPosition, srcNormal, vUv + k2 * kernelRadius * 0.75);
		occlusion += SamplePixels(srcPosition, srcNormal, vUv + k1 * kernelRadius * 0.5);
		occlusion += SamplePixels(srcPosition, srcNormal, vUv + k2 * kernelRadius * 0.25);
	}
	
	// Average and clamp ambient occlusion
	occlusion /= 16.0;
	occlusion = clamp(occlusion, 0.0, 1.0);
	
	gl_FragColor.x = occlusion;
}