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
/// Fragment shader for rendering the scene with shadows using a cubemap (point light).
/// </summary>


#ifdef GL_ES
	precision highp float;
#endif


/// <summary>
/// Linear depth calculation.
/// You could optionally upload this as a shader parameter.
/// <summary>
const float Near = 1.0;
const float Far = 30.0;
const float LinearDepthConstant = 1.0 / (Far - Near);


/// <summary>
/// Light source structure.
/// <summary>
struct LightSource
{
	int Type;
	vec3 Position;
	vec3 Attenuation;
	vec3 Direction;
	vec3 Colour;
	float OuterCutoff;
	float InnerCutoff;
	float Exponent;
};


/// <summary>
/// Material source structure.
/// <summary>
struct MaterialSource
{
	vec3 Ambient;
	vec4 Diffuse;
	vec3 Specular;
	float Shininess;
	vec2 TextureOffset;
	vec2 TextureScale;
};


/// <summary>
/// Uniform variables.
/// <summary>
uniform int NumLight;
uniform LightSource Light[4];
uniform MaterialSource Material;
uniform samplerCube DepthMap;
uniform int FilterType;


/// <summary>
/// Varying variables.
/// <summary>
varying vec4 vWorldVertex;
varying vec3 vWorldNormal;
varying vec2 vUv;
varying vec3 vViewVec;
varying vec4 vPosition;


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
/// Calculate Chebychev's inequality.
/// <summary>
/// <param name="moments">
/// moments.x = mean
/// moments.y = mean^2
/// </param>
/// <param name="t">Current depth value.</param>
/// <returns>The upper bound (0.0, 1.0), or rather the amount to shadow the current fragment colour.</param>
float ChebychevInequality (vec2 moments, float t)
{
	// No shadow if depth of fragment is in front
	if ( t <= moments.x )
		return 1.0;

	// Calcualte variance, which is actually the amount of
	// error due to precision loss from fp32 to fp16 to RG/BA
	// (moment1 / moment2)
	float variance = moments.y - (moments.x * moments.x);
	variance = max(variance, 0.02);
	
	// Calculate the upper bound
	float d = t - moments.x;
	return variance / (variance + d * d);
}


/// <summary>
/// VSM can suffer from light bleeding when shadows overlap. This method
/// tweaks the chebychev upper bound to eliminate the bleeding, but at the
/// expense of creating a shadow with sharper, darker edges.
/// <summary>
float VsmFixLightBleed (float pMax, float amount)
{
	return clamp((pMax - amount) / (1.0 - amount), 0.0, 1.0);
}


/// <summary>
/// Fragment shader entry.
/// <summary>
void main ()
{
	// vWorldNormal is interpolated when passed into the fragment shader.
	// We need to renormalize the vector so that it stays at unit length.
	vec3 normal = normalize(vWorldNormal);

	// Colour the fragment as normal
	vec3 colour = Material.Ambient;
	for (int i = 0; i < 4; ++i)
	{
		if ( i >= NumLight )
			break;
		
		// Calculate diffuse term
		vec3 lightVec = normalize(Light[i].Position - vWorldVertex.xyz);
		float l = dot(normal, lightVec);
		if ( l > 0.0 )
		{
			// Calculate spotlight effect
			float spotlight = 1.0;
			if ( Light[i].Type == 1 )
			{
				spotlight = max(-dot(lightVec, Light[i].Direction), 0.0);
				float spotlightFade = clamp((Light[i].OuterCutoff - spotlight) / (Light[i].OuterCutoff - Light[i].InnerCutoff), 0.0, 1.0);
				spotlight = pow(spotlight * spotlightFade, Light[i].Exponent);
			}
			
			// Calculate specular term
			vec3 r = -normalize(reflect(lightVec, normal));
			float s = pow(max(dot(r, vViewVec), 0.0), Material.Shininess);
			
			// Calculate attenuation factor
			float d = distance(vWorldVertex.xyz, Light[i].Position);
			float a = 1.0 / (Light[i].Attenuation.x + (Light[i].Attenuation.y * d) + (Light[i].Attenuation.z * d * d));
			
			// Add to colour
			colour += ((Material.Diffuse.xyz * l) + (Material.Specular * s)) * Light[i].Colour * a * spotlight;
		}
	}
	
	//
	// Calculate shadow amount
	//
	vec3 lightVec = normalize(vWorldVertex.xyz - Light[0].Position);
	lightVec.y = -lightVec.y;
	lightVec.z = -lightVec.z;
	float depth = length(vWorldVertex.xyz - Light[0].Position) * LinearDepthConstant;
	float shadow = 1.0;
	if ( FilterType <= 1 )
	{
		//
		// No filtering, just render the shadow map
		// Note, no PCF filtering is performed for point lights for
		// simplicity reasons.
		//
		
		// Offset depth a bit
		// This causes "Peter Panning", but solves "Shadow Acne"
		depth *= 0.96;
		
		float shadowDepth = unpack(textureCube(DepthMap, lightVec));
		if ( depth > shadowDepth )
			shadow = 0.5;
	}
	else if ( FilterType == 2 )
	{
		//
		// Variance shadow map algorithm
		//
		vec4 texel = textureCube(DepthMap, lightVec);
		vec2 moments = vec2(unpackHalf(texel.xy), unpackHalf(texel.zw));
		shadow = ChebychevInequality(moments, depth);
		//shadow = VsmFixLightBleed(shadow, 0.1);
	}
	else
	{
		//
		// Exponential shadow map algorithm
		//
		float c = 4.0;
		vec4 texel = textureCube(DepthMap, lightVec);
		shadow = clamp(exp(-c * (depth - unpack(texel))), 0.0, 1.0);
	}
	
	
	//
	// Apply colour and shadow
	//
	gl_FragColor = clamp(vec4(colour * shadow, Material.Diffuse.w), 0.0, 1.0);
}