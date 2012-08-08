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
attribute vec3 Vertex;
attribute vec2 Uv;
attribute vec3 Normal;

// Uniform variables.
uniform mat4 ProjectionMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ModelMatrix;
uniform vec3 ModelScale;

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

// Vertex shader entry.
void main ()
{
	vWorldVertex = ModelMatrix * vec4(Vertex * ModelScale, 1.0);
	vec4 viewVertex = ViewMatrix * vWorldVertex;
	gl_Position = ProjectionMatrix * viewVertex;
	
	vUv = Material.textureOffset + (Uv * Material.textureScale);
	
	vWorldNormal = normalize(mat3(ModelMatrix) * Normal);
	
	vViewVec = normalize(-viewVertex.xyz);
	
	if ( ShadingType == 0 )
	{
		vColour = vec4(Material.ambient, 0.0);
		for (int i = 0; i < 4; ++i)
		{
			if ( i >= NumLight )
				break;
			
			// Calculate diffuse term
			vec3 lightVec = normalize(Light[i].position - vWorldVertex.xyz);
			float l = dot(vWorldNormal, lightVec);
			if ( l > 0.0 )
			{
				// Calculate spotlight effect
				float spotlight = 1.0;
				if ( (Light[i].direction.x != 0.0) || 
				(Light[i].direction.y != 0.0) || 
				(Light[i].direction.z != 0.0) )
				{
					spotlight = max(-dot(lightVec, Light[i].direction), 0.0);
					float spotlightFade = clamp((Light[i].outerCutoff - spotlight) / (Light[i].outerCutoff - Light[i].innerCutoff), 0.0, 1.0);
					spotlight = pow(spotlight * spotlightFade, Light[i].exponent);
				}
				
				// Calculate specular term
				vec3 r = -normalize(reflect(lightVec, vWorldNormal));
				float s = pow(max(dot(r, vViewVec), 0.0), Material.shininess);
				
				// Calculate attenuation factor
				float d = distance(vWorldVertex.xyz, Light[i].position);
				float a = 1.0 / (Light[i].attenuation.x + (Light[i].attenuation.y * d) + (Light[i].attenuation.z * d * d));
				
				// Add to colour
				vColour.xyz += ((Material.diffuse.xyz * l) + (Material.specular * s)) * Light[i].colour * a * spotlight;
			}
		}
		
		vColour.w = Material.diffuse.w;
	}
}