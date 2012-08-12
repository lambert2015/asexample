// This fragment shader renders the depth map to screen.

#ifdef GL_ES
	precision highp float;
#endif

// Uniform variables.
uniform sampler2D u_sample0;

// Varying variables.
varying vec2 v_uv;

// Unpack an RGBA pixel to floating point value.
float unpack (vec4 colour)
{
	const vec4 bitShifts = vec4(1.0,
								1.0 / 255.0,
								1.0 / (255.0 * 255.0),
								1.0 / (255.0 * 255.0 * 255.0));
	return dot(colour, bitShifts);
}

// Fragment shader entry.
void main ()
{
	float depth = unpack(texture2D(u_sample0, v_uv));
	gl_FragColor = vec4(depth, depth, depth, 1.0);
}