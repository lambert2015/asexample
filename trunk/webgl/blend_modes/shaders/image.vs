// Vertex shader for rendering a 2D plane on the screen. The plane should be sized
// from -1.0 to 1.0 in the x and y axis. This shader can be shared amongst multiple
// post-processing fragment shaders.

// Attributes.
attribute vec3 a_vertex;
attribute vec2 a_uv;

// Varying variables.
varying vec2 v_uv;

// Vertex shader entry.

void main ()
{
	gl_Position = vec4(a_vertex, 1.0);
	
	// Flip y-axis
	v_uv = vec2(a_uv.x, 1.0 - a_uv.y);
}