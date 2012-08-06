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
/// Basic Lighting Vertex Shader.
/// </summary>


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
/// Attributes.
/// <summary>
attribute vec3 Vertex;
attribute vec2 Uv;
attribute vec3 Normal;


/// <summary>
/// Uniform variables.
/// <summary>
uniform mat4 ProjectionMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ModelMatrix;
uniform vec3 ModelScale;

uniform int NumLight;
uniform LightSource Light[4];
uniform MaterialSource Material;

/// <summary>
/// Gets or sets whether vertex lighting (Gouraud Shading) or
/// fragment lighting (Phong Shading) is used.
/// <summary>
uniform int ShadingType;


/// <summary>
/// Varying variables.
/// <summary>
varying vec4 vWorldVertex;
varying vec3 vWorldNormal;
varying vec2 vUv;
varying vec3 vViewVec;
varying vec4 vColour;


/// <summary>
/// Vertex shader entry.
/// <summary>
void main ()
{
	vWorldVertex = ModelMatrix * vec4(Vertex * ModelScale, 1.0);
	vec4 viewVertex = ViewMatrix * vWorldVertex;
	gl_Position = ProjectionMatrix * viewVertex;
	
	vUv = Material.TextureOffset + (Uv * Material.TextureScale);
	
	vWorldNormal = normalize(mat3(ModelMatrix) * Normal);
	
	vViewVec = normalize(-viewVertex.xyz);
	
	if ( ShadingType == 0 )
	{
		vColour = vec4(Material.Ambient, 0.0);
		for (int i = 0; i < 4; ++i)
		{
			if ( i >= NumLight )
				break;
			
			// Calculate diffuse term
			vec3 lightVec = normalize(Light[i].Position - vWorldVertex.xyz);
			float l = dot(vWorldNormal, lightVec);
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
				vec3 r = -normalize(reflect(lightVec, vWorldNormal));
				float s = pow(max(dot(r, vViewVec), 0.0), Material.Shininess);
				
				// Calculate attenuation factor
				float d = distance(vWorldVertex.xyz, Light[i].Position);
				float a = 1.0 / (Light[i].Attenuation.x + (Light[i].Attenuation.y * d) + (Light[i].Attenuation.z * d * d));
				
				// Add to colour
				vColour.xyz += ((Material.Diffuse.xyz * l) + (Material.Specular * s)) * Light[i].Colour * a * spotlight;
			}
		}
		
		vColour.w = Material.Diffuse.w;
	}
}