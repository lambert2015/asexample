// Fragment shader for performing a seperable blur on the specified cubemap.

#ifdef GL_ES
	precision highp float;
#endif

// Uniform variables.
uniform vec2 u_texelSize;
uniform samplerCube u_sample0;

uniform int u_cubeFace;
uniform int u_orientation;
uniform int u_blurAmount;

// Varying variables.
varying vec2 v_uv;


// Gets the Gaussian value in the first dimension.
// <param name="x">Distance from origin on the x-axis.</param>
// <param name="deviation">Standard deviation.</param>
// <returns>The gaussian value on the x-axis.</returns>
float Gaussian (float x, float deviation)
{
	return (1.0 / sqrt(2.0 * 3.141592 * deviation)) * exp(-((x * x) / (2.0 * deviation)));	
}

// Fragment shader entry.
void main ()
{
	float halfBlur = float(u_blurAmount) * 0.5;
	//float deviation = halfBlur * 0.5;
	vec4 colour;
	
	// u_cubeFace will be +X, -X, +Y, -Y, +Z, -Z
	vec3 dir;
	vec2 uv = (v_uv - 0.5) * 2.0;
	if ( u_orientation == 0 )
	{
		// Blur horizontal
		for (int i = 0; i < 10; ++i)
		{
			if ( i >= u_blurAmount )
				break;
			
			float offset = float(i) - halfBlur;
			if ( u_cubeFace == 0 )
				dir = vec3(1.0, uv.x + offset * u_texelSize.x, uv.y);
			else if ( u_cubeFace == 1 )
				dir = vec3(-1.0, -uv.x + offset * u_texelSize.x, uv.y);
			else if ( u_cubeFace == 2 )
				dir = vec3(uv.x + offset * u_texelSize.x, 1.0, uv.y);
			else if ( u_cubeFace == 3 )
				dir = vec3(uv.x + offset * u_texelSize.x, -1.0, uv.y);
			else if ( u_cubeFace == 4 )
				dir = vec3(uv.x + offset * u_texelSize.x, uv.y, 1.0);
			else if ( u_cubeFace == 5 )
				dir = vec3(uv.x + offset * u_texelSize.x, uv.y, -1.0);
			
			colour += textureCube(u_sample0, normalize(dir)) /* Gaussian(offset, deviation)*/;
		}
	}
	else
	{
		// Blur vertical
		for (int i = 0; i < 10; ++i)
		{
			if ( i >= u_blurAmount )
				break;
			
			float offset = float(i) - halfBlur;
			if ( u_cubeFace == 0 )
				dir = vec3(1.0, uv.x, uv.y + offset * u_texelSize.y);
			else if ( u_cubeFace == 1 )
				dir = vec3(-1.0, -uv.x, uv.y + offset * u_texelSize.y);
			else if ( u_cubeFace == 2 )
				dir = vec3(uv.x, 1.0, uv.y + offset * u_texelSize.y);
			else if ( u_cubeFace == 3 )
				dir = vec3(uv.x, -1.0, uv.y + offset * u_texelSize.y);
			else if ( u_cubeFace == 4 )
				dir = vec3(uv.x, uv.y + offset * u_texelSize.y, 1.0);
			else if ( u_cubeFace == 5 )
				dir = vec3(uv.x, uv.y + offset * u_texelSize.y, -1.0);
			
			colour += textureCube(u_sample0, normalize(dir)) /* Gaussian(offset, deviation)*/;
		}
	}
	
	// Calculate average
	colour = colour / float(u_blurAmount);
	
	// Apply colour
	gl_FragColor = colour;
}