// This fragment shader produces the final image with the DOF effect. The blurred image is
// blended with the higher resolution texture based on how much each pixel is blurred.

#ifdef GL_ES
	precision highp float;
#endif

// Uniform variables.
uniform sampler2D u_sample0; // Colour texture
uniform sampler2D u_sample1; // Depth texture
uniform sampler2D u_sample2; // Blurred texture

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
		
	// Get the colour, depth, and blur pixels
	vec4 colour = texture2D(u_sample0, v_uv);
	float depth = unpack(texture2D(u_sample1, v_uv));
	vec4 blur = texture2D(u_sample2, v_uv);
	
	// Linearly interpolate between the colour and blur pixels based on DOF
	float blurAmount = GetBlurDiameter(depth);
	float lerp = min(blurAmount / MAX_BLUR_RADIUS, 1.0);
	
	// Blend
	gl_FragColor = (colour * (1.0 - lerp)) + (blur * lerp);
}