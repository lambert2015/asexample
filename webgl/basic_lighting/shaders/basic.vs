// Basic Lighting Vertex Shader.

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

// Attributes.
attribute vec3 a_vertex;
attribute vec2 a_uv;
attribute vec3 a_normal;

// Uniform variables.
uniform mat4 u_projectionMatrix;
uniform mat4 u_viewMatrix;
uniform mat4 u_modelMatrix;
uniform vec3 u_modelScale;

uniform int u_numLight;
uniform LightSource u_lights[4];
uniform MaterialSource u_material;

// Gets or sets whether vertex lighting (Gouraud Shading) or
// fragment lighting (Phong Shading) is used.
uniform int u_shadingType;

// Varying variables.
varying vec4 v_worldVertex;
varying vec3 v_worldNormal;
varying vec2 v_uv;
varying vec3 v_viewVec;
varying vec4 v_colour;

// Vertex shader entry.
void main ()
{
	v_worldVertex = u_modelMatrix * vec4(a_vertex * u_modelScale, 1.0);
	vec4 t_viewVertex = u_viewMatrix * v_worldVertex;
	gl_Position = u_projectionMatrix * t_viewVertex;
	
	v_uv = u_material.textureOffset + (a_uv * u_material.textureScale);
	
	v_worldNormal = normalize(mat3(u_modelMatrix) * a_normal);
	
	v_viewVec = normalize(-t_viewVertex.xyz);
	
	if ( u_shadingType == 0 )
	{
		v_colour = vec4(u_material.ambient, 0.0);
		for (int i = 0; i < 4; ++i)
		{
			if ( i >= u_numLight )
				break;
			
			// Calculate diffuse term
			vec3 lightVec = normalize(u_lights[i].position - v_worldVertex.xyz);
			float l = dot(v_worldNormal, lightVec);
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
				vec3 r = -normalize(reflect(lightVec, v_worldNormal));
				float s = pow(max(dot(r, v_viewVec), 0.0), u_material.shininess);
				
				// Calculate attenuation factor
				float d = distance(v_worldVertex.xyz, u_lights[i].position);
				float a = 1.0 / (u_lights[i].attenuation.x + (u_lights[i].attenuation.y * d) + (u_lights[i].attenuation.z * d * d));
				
				// Add to colour
				v_colour.xyz += ((u_material.diffuse.xyz * l) + (u_material.specular * s)) * u_lights[i].colour * a * spotlight;
			}
		}
		
		v_colour.w = u_material.diffuse.w;
	}
}