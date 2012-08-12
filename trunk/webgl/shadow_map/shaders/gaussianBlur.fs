// Fragment shader for performing a seperable blur on the specified texture.

#ifdef GL_ES
	precision highp float;
#endif

// Uniform variables.
uniform vec2 u_texelSize;
uniform sampler2D u_sample0;

uniform int u_orientation;
uniform int u_blurAmount;

// Varying variables.
varying vec2 v_uv;

// Gets the gaussian value in the first dimension.
// <param name="x">Distance from origin on the x-axis.</param>
// <param name="deviation">Standard deviation.</param>
// <returns>The gaussian value on the x-axis.</returns>
float gaussian (float x, float deviation)
{
	return (1.0 / sqrt(2.0 * 3.141592 * deviation)) * exp(-((x * x) / (2.0 * deviation)));	
}

// Fragment shader entry.
void main ()
{
	float halfBlur = float(u_blurAmount) * 0.5;
	//float deviation = halfBlur * 0.5;
	vec4 colour;
	
	if ( u_orientation == 0 )
	{
		// Blur horizontal
		for (int i = 0; i < 10; ++i)
		{
			if ( i >= u_blurAmount )
				break;
			
			float offset = float(i) - halfBlur;
			colour += texture2D(u_sample0, v_uv + vec2(offset * u_texelSize.x, 0.0)) /* gaussian(offset, deviation)*/;
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
			colour += texture2D(u_sample0, v_uv + vec2(0.0, offset * u_texelSize.y)) /* gaussian(offset, deviation)*/;
		}
	}
	
	// Calculate average
	colour = colour / float(u_blurAmount);
	
	// Apply colour
	gl_FragColor = colour;
}