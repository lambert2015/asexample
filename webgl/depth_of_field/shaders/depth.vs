// This vertex shader sets up the geometry for rendering to a depth map.

// Attributes.
attribute vec3 a_vertex;

// Uniform variables.
uniform mat4 u_projectionMatrix;
uniform mat4 u_viewMatrix;
uniform mat4 u_modelMatrix;
uniform vec3 u_modelScale;

// Varying variables.
varying vec4 v_position;

// Vertex shader entry.
void main ()
{
	v_position = u_viewMatrix * u_modelMatrix * vec4(a_vertex * u_modelScale, 1.0);
	gl_Position = u_projectionMatrix * v_position;
}