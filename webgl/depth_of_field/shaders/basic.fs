// Basic lighting fragment shader.

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
uniform int u_numLight;
uniform LightSource u_lights[4];
uniform MaterialSource u_material;
uniform sampler2D u_sample0;

// Varying variables.
varying vec4 v_worldVertex;
varying vec3 v_worldNormal;
varying vec2 v_uv;
varying vec3 v_viewVec;

// Fragment shader entry.
void main ()
{
	// v_worldNormal is interpolated when passed into the fragment shader.
	// We need to renormalize the vector so that it stays at unit length.
	vec3 normal = normalize(v_worldNormal);

	vec3 colour = u_material.ambient;
	for (int i = 0; i < 4; ++i)
	{
		if ( i >= u_numLight )
			break;
		
		// Calculate diffuse term
		vec3 lightVec = normalize(u_lights[i].position - v_worldVertex.xyz);
		float l = dot(normal, lightVec);
		if ( l > 0.0 )
		{
			// Calculate spotlight effect
			float spotlight = 1.0;
			if ( (u_lights[i].direction.x != 0.0) || 
			(u_lights[i].direction.y != 0.0) || 
			(u_lights[i].direction.z != 0.0) )
			{
				spotlight = max(-dot(lightVec, u_lights[i].direction), 0.0);
				float spotlightFade = clamp((u_lights[i].outerCutoff - spotlight) / (u_lights[i].outerCutoff - u_lights[i].innerCutoff), 0.0, 1.0);
				spotlight = pow(spotlight * spotlightFade, u_lights[i].exponent);
			}
			
			// Calculate specular term
			vec3 r = -normalize(reflect(lightVec, normal));
			float s = pow(max(dot(r, v_viewVec), 0.0), u_material.shininess);
			
			// Calculate attenuation factor
			float d = distance(v_worldVertex.xyz, u_lights[i].position);
			float a = 1.0 / (u_lights[i].attenuation.x + (u_lights[i].attenuation.y * d) + (u_lights[i].attenuation.z * d * d));
			
			// Add to colour
			colour += ((u_material.diffuse.xyz * l) + (u_material.specular * s)) * u_lights[i].colour * a * spotlight;
		}
	}
	
	gl_FragColor = clamp(vec4(colour, u_material.diffuse.w), 0.0, 1.0) * texture2D(u_sample0, v_uv);
}