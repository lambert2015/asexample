// Fragment shader for rendering the t_depth cubemap to screen.

#ifdef GL_ES
	precision highp float;
#endif

// Uniform variables.
uniform int u_filterType;
uniform samplerCube u_sample0;

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

// Unpack a vec2 to a floating point (used by VSM).
float unpackHalf (vec2 colour)
{
	return colour.x + (colour.y / 255.0);
}

// Fragment shader entry.
void main ()
{
	float t_depth = 0.0;
	
	// Determine what cube face to render based on UV coordinates
	vec3 t_dir;
	if ( v_uv.y < 0.5 )
	{
		float y = (0.25 - v_uv.y) / 0.25;
		
		// Left
		if ( v_uv.x < 0.33 )
			t_dir = vec3(-1.0,
						y,
						(v_uv.x - 0.165) / 0.165);
		// Front
		else if ( v_uv.x < 0.66 )
			t_dir = vec3(((v_uv.x - 0.33) - 0.165) / 0.165,
						y,
						-1.0);
		// Right
		else
			t_dir = vec3(1.0,
						y,
						((v_uv.x - 0.66) - 0.165) / 0.165);
	}
	else
	{
		float y = (0.75 - v_uv.y) / 0.25;
	
		// Back
		if ( v_uv.x < 0.33 )
			t_dir = vec3((v_uv.x - 0.165) / 0.165,
						y,
						1.0);
		// Top
		else if ( v_uv.x < 0.66 )
			t_dir = vec3(((v_uv.x - 0.33) - 0.165) / 0.165,
						1.0,
						-y);
		// Bottom
		else
			t_dir = vec3(((v_uv.x - 0.66) - 0.165) / 0.165,
						-1.0,
						-y);
	}
		
	if ( u_filterType == 2 )
		t_depth = unpackHalf(textureCube(u_sample0, t_dir).xy);
	else
		t_depth = unpack(textureCube(u_sample0, t_dir));
	
	gl_FragColor = vec4(t_depth, t_depth, t_depth, 1.0);
}