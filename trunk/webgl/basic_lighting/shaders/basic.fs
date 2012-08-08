// Basic Lighting Fragment Shader.

#ifdef GL_ES
	precision highp float;
#endif

// Light source structure.
struct LightSource
{
	vec3 position;
	vec3 attenuation;
	vec3 direction;
	vec3 colour;
	float outerCutoff;
	float innerCutoff;
	float exponent;
};

// Material source structure.
struct MaterialSource
{
	vec3 ambient;
	vec4 diffuse;
	vec3 specular;
	float shininess;
	vec2 textureOffset;
	vec2 textureScale;
};

// Uniform variables.
uniform int NumLight;
uniform LightSource Light[4];
uniform MaterialSource Material;

// Gets or sets whether vertex lighting (Gouraud Shading) or
// fragment lighting (Phong Shading) is used.
uniform int ShadingType;

// Varying variables.
varying vec4 vWorldVertex;
varying vec3 vWorldNormal;
varying vec2 vUv;
varying vec3 vViewVec;
varying vec4 vColour;

// Fragment shader entry.
void main ()
{
	if ( ShadingType == 1 )
	{
		// vWorldNormal is interpolated when passed into the fragment shader.
		// We need to renormalize the vector so that it stays at unit length.
		vec3 normal = normalize(vWorldNormal);
	
		vec3 colour = Material.ambient;
		for (int i = 0; i < 4; ++i)
		{
			if ( i >= NumLight )
				break;
			
			// Calculate diffuse term
			vec3 lightVec = normalize(Light[i].position - vWorldVertex.xyz);
			float l = dot(normal, lightVec);
			if ( l > 0.0 )
			{
				// Calculate spotlight effect
				float spotlight = 1.0;
				if ( (Light[i].direction.x != 0.0) || (Light[i].direction.y != 0.0) || (Light[i].direction.z != 0.0) )
				{
					spotlight = max(-dot(lightVec, Light[i].direction), 0.0);
					float spotlightFade = clamp((Light[i].outerCutoff - spotlight) / (Light[i].outerCutoff - Light[i].innerCutoff), 0.0, 1.0);
					spotlight = pow(spotlight * spotlightFade, Light[i].exponent);
				}
				
				// Calculate specular term
				vec3 r = -normalize(reflect(lightVec, normal));
				float s = pow(max(dot(r, vViewVec), 0.0), Material.shininess);
				
				// Calculate attenuation factor
				float d = distance(vWorldVertex.xyz, Light[i].position);
				float a = 1.0 / (Light[i].attenuation.x + (Light[i].attenuation.y * d) + (Light[i].attenuation.z * d * d));
				
				// Add to colour
				colour += ((Material.diffuse.xyz * l) + (Material.specular * s)) * Light[i].colour * a * spotlight;
			}
		}
		
		gl_FragColor = clamp(vec4(colour, Material.diffuse.w), 0.0, 1.0);
	}
	else
	{
		// Set colour
		gl_FragColor = vColour;
	}
}