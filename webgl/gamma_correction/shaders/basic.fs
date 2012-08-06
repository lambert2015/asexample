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
/// Basic lighting fragment shader.
/// </summary>


#ifdef GL_ES
	precision highp float;
#endif


/// <summary>
/// Light source structure.
/// <summary>
struct LightSource
{
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
uniform sampler2D Sample0;

/// <summary>
/// This gamma value is used for "uncorrecting" or "linearizing" a texture before
/// mixing it with the fragment.
/// <summary>
uniform float Gamma;


/// <summary>
/// Varying variables.
/// <summary>
varying vec4 vWorldVertex;
varying vec3 vWorldNormal;
varying vec2 vUv;
varying vec3 vViewVec;


/// <summary>
/// Fragment shader entry.
/// <summary>
void main ()
{
	// vWorldNormal is interpolated when passed into the fragment shader.
	// We need to renormalize the vector so that it stays at unit length.
	vec3 normal = normalize(vWorldNormal);

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
			if ( (Light[i].Direction.x != 0.0) || (Light[i].Direction.y != 0.0) || (Light[i].Direction.z != 0.0) )
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
	
	// Note: Lighting is performed in linear space, but textures are nonlinear gamma corrected. As such,
	// we need to 'uncorrect' or linearize the texture before applying it to the fragment. Later, in another shader,
	// we will perform gamma correction on the fragment before sending it to the monitor.
	//
	// Optionally, you could linearize all your textures before they're loaded into WebGL, thus eliminating the need
	// for uncorrecting the texture at runtime. This would improve performance and avoid data loss (gamma correction is
	// lossy).
	vec4 texColour = texture2D(Sample0, vUv);
	texColour.xyz = pow(texColour.xyz, vec3(Gamma));
	
	gl_FragColor = clamp(vec4(colour, Material.Diffuse.w), 0.0, 1.0) * texColour;
}