// Basic lighting vertex shader.

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

uniform MaterialSource u_material;

// Varying variables.
varying vec4 v_worldVertex;
varying vec3 v_worldNormal;
varying vec2 v_uv;
varying vec3 v_viewVec;

// Vertex shader entry.
void main ()
{
	v_worldVertex = u_modelMatrix * vec4(a_vertex * u_modelScale, 1.0);
	vec4 t_viewVertex = u_viewMatrix * v_worldVertex;
	gl_Position = u_projectionMatrix * t_viewVertex;

	v_uv = u_material.textureOffset + (a_uv * u_material.textureScale);
	
	v_worldNormal = normalize(mat3(u_modelMatrix) * a_normal);
	
	v_viewVec = normalize(-t_viewVertex.xyz);
}