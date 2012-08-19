// Vertex shader for rendering the scene with shadows.
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
uniform mat4 u_lightSourceProjectionMatrix;
uniform mat4 u_lightSourceViewMatrix;

uniform int u_numLight;
uniform MaterialSource u_material;

// The scale matrix is used to push the projected vertex into the 0.0 - 1.0 region.
// Similar in role to a * 0.5 + 0.5, where -1.0 < a < 1.0.
const mat4 ScaleMatrix = mat4(0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.5, 0.5, 0.5, 1.0);

// Varying variables.
varying vec4 v_worldVertex;
varying vec3 v_worldNormal;
varying vec2 v_uv;
varying vec3 v_viewVec;
varying vec4 v_position;

// Vertex shader entry.
void main ()
{
	// Standard basic lighting preperation
	v_worldVertex = u_modelMatrix * vec4(a_vertex * u_modelScale, 1.0);
	vec4 t_viewVertex = u_viewMatrix * v_worldVertex;
	gl_Position = u_projectionMatrix * t_viewVertex;
	
	v_uv = u_material.textureOffset + (a_uv * u_material.textureScale);
	
	v_worldNormal = normalize(mat3(u_modelMatrix) * a_normal);
	
	v_viewVec = normalize(-t_viewVertex.xyz);
	
	// Project the vertex from the light's point of view
	v_position = ScaleMatrix * u_lightSourceProjectionMatrix * u_lightSourceViewMatrix * v_worldVertex;
}