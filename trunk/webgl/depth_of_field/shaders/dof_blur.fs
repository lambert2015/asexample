// This fragment shader performs a DOF separable blur algorithm on the specified
// texture.

#ifdef GL_ES
	precision highp float;
#endif

// Uniform variables.

uniform vec2 u_texelSize;		// Size of one texel (1 / width, 1 / height)
uniform sampler2D u_sample0;	// Colour texture
uniform sampler2D u_sample1;	// Depth texture

uniform int u_orientation;		// 0 = horizontal, 1 = vertical
uniform float u_blurCoefficient;	// Calculated from the blur equation, b = ( f * ms / N )
uniform float u_focusDistance;	// The distance to the subject in perfect focus (= Ds)
uniform float u_near;				// Near clipping plane
uniform float u_far;				// Far clipping plane
uniform float u_pPM;				// Pixels per millimetre



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



// Calculate the blur diameter to apply on the image.
// b = (f * ms / N) * (xd / (Ds +- xd))
// Where:
// (Ds + xd) for background objects
// (Ds - xd) for foreground objects

// <param name="d">Depth of the fragment.</param>
float GetBlurDiameter (float d)
{
	// Convert from linear depth to metres
	float Dd = d * (u_far - u_near);
	
	float xd = abs(Dd - u_focusDistance);
	float xdd = (Dd < u_focusDistance) ? (u_focusDistance - xd) : (u_focusDistance + xd);
	float b = u_blurCoefficient * (xd / xdd);
	
	return b * u_pPM;
}



// Fragment shader entry.

void main ()
{
	// Maximum blur radius to limit hardware requirements.
	// Cannot #define this due to a driver issue with some setups
	const float MAX_BLUR_RADIUS = 10.0;

	// Pass the linear depth values recorded in the depth map to the blur
	// equation to find out how much each pixel should be blurred with the
	// given camera settings.
	float depth = unpack(texture2D(u_sample1, v_uv));
	float blurAmount = GetBlurDiameter(depth);
	blurAmount = min(floor(blurAmount), MAX_BLUR_RADIUS);

	// Apply the blur
	float count = 0.0;
	vec4 colour = vec4(0.0);
	vec2 texelOffset;
	if ( u_orientation == 0 )
		texelOffset = vec2(u_texelSize.x, 0.0);
	else
		texelOffset = vec2(0.0, u_texelSize.y);
	
	if ( blurAmount >= 1.0 )
	{
		float halfBlur = blurAmount * 0.5;
		for (float i = 0.0; i < MAX_BLUR_RADIUS; ++i)
		{
			if ( i >= blurAmount )
				break;
			
			float offset = i - halfBlur;
			vec2 vOffset = v_uv + (texelOffset * offset);

			colour += texture2D(u_sample0, vOffset);
			++count;
		}
	}
	
	// Apply colour
	if ( count > 0.0 )
		gl_FragColor = colour / count;
	else
		gl_FragColor = texture2D(u_sample0, v_uv);
}