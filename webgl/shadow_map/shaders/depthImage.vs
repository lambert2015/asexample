// Vertex shader for rendering the depth map to screen.

// Attributes.
attribute vec3 a_vertex;
attribute vec2 a_uv;

// Uniform variables.
uniform mat4 u_projectionMatrix;

// Varying variables.
varying vec2 v_uv;

// a_vertex shader entry.
void main ()
{
	gl_Position = u_projectionMatrix * vec4(a_vertex, 1.0);
	v_uv = a_uv;
}