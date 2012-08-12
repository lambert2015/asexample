// Fragment shader for rendering the scene with shadows using a cubemap (point light).

#ifdef GL_ES
	precision highp float;
#endif

// Linear depth calculation.
// You could optionally upload this as a shader parameter.

const float near = 1.0;
const float far = 30.0;
const float linearDepthConstant = 1.0 / (far - near);

// Light source structure.
struct LightSource
{
	int type;
	vec3 position;
	vec3 attenuation;
	vec3 direction;
	vec3 colour;
	float outerCutoff;
	float innerCutoff;
	float exponent;
};

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

// Uniform variables.
uniform int u_numLight;
uniform LightSource u_lights[4];
uniform MaterialSource u_material;
uniform samplerCube u_depthMap;
uniform int u_filterType;

// Varying variables.
varying vec4 v_worldVertex;
varying vec3 v_worldNormal;
varying vec2 v_uv;
varying vec3 v_viewVec;
varying vec4 v_position;

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

// Calculate Chebychev's inequality.
// <param name="moments">
// moments.x = mean
// moments.y = mean^2
// </param>
// <param name="t">Current depth value.</param>
// <returns>The upper bound (0.0, 1.0), or rather the amount to shadow the current fragment colour.</param>
float chebychevInequality (vec2 moments, float t)
{
	// No shadow if depth of fragment is in front
	if ( t <= moments.x )
		return 1.0;

	// Calcualte variance, which is actually the amount of
	// error due to precision loss from fp32 to fp16 to RG/BA
	// (moment1 / moment2)
	float variance = moments.y - (moments.x * moments.x);
	variance = max(variance, 0.02);
	
	// Calculate the upper bound
	float d = t - moments.x;
	return variance / (variance + d * d);
}

// VSM can suffer from light bleeding when shadows overlap. This method
// tweaks the chebychev upper bound to eliminate the bleeding, but at the
// expense of creating a shadow with sharper, darker edges.
float vsmFixLightBleed (float pMax, float amount)
{
	return clamp((pMax - amount) / (1.0 - amount), 0.0, 1.0);
}


// Fragment shader entry.
void main ()
{
	// v_worldNormal is interpolated when passed into the fragment shader.
	// We need to renormalize the vector so that it stays at unit length.
	vec3 normal = normalize(v_worldNormal);

	// Colour the fragment as normal
	vec3 colour = u_material.ambient;
	for (int i = 0; i < 4; ++i)
	{
		if ( i >= u_numLight )
			break;
		
		// Calculate diffuse term
		vec3 t_lightVec = normalize(u_lights[i].position - v_worldVertex.xyz);
		float l = dot(normal, t_lightVec);
		if ( l > 0.0 )
		{
			// Calculate spotlight effect
			float t_spotlight = 1.0;
			if ( u_lights[i].type == 1 )
			{
				t_spotlight = max(-dot(t_lightVec, u_lights[i].direction), 0.0);
				float spotlightFade = clamp((u_lights[i].outerCutoff - t_spotlight) / (u_lights[i].outerCutoff - u_lights[i].innerCutoff), 0.0, 1.0);
				t_spotlight = pow(t_spotlight * spotlightFade, u_lights[i].exponent);
			}
			
			// Calculate specular term
			vec3 r = -normalize(reflect(t_lightVec, normal));
			float s = pow(max(dot(r, v_viewVec), 0.0), u_material.shininess);
			
			// Calculate attenuation factor
			float d = distance(v_worldVertex.xyz, u_lights[i].position);
			float a = 1.0 / (u_lights[i].attenuation.x + (u_lights[i].attenuation.y * d) + (u_lights[i].attenuation.z * d * d));
			
			// Add to colour
			colour += ((u_material.diffuse.xyz * l) + (u_material.specular * s)) * u_lights[i].colour * a * t_spotlight;
		}
	}
	
	//
	// Calculate shadow amount
	//
	vec3 t_lightVec = normalize(v_worldVertex.xyz - u_lights[0].position);
	t_lightVec.y = -t_lightVec.y;
	t_lightVec.z = -t_lightVec.z;
	float depth = length(v_worldVertex.xyz - u_lights[0].position) * linearDepthConstant;
	float shadow = 1.0;
	if ( u_filterType <= 1 )
	{
		//
		// No filtering, just render the shadow map
		// Note, no PCF filtering is performed for point lights for
		// simplicity reasons.
		//
		
		// Offset depth a bit
		// This causes "Peter Panning", but solves "Shadow Acne"
		depth *= 0.96;
		
		float shadowDepth = unpack(textureCube(u_depthMap, t_lightVec));
		if ( depth > shadowDepth )
			shadow = 0.5;
	}
	else if ( u_filterType == 2 )
	{
		//
		// Variance shadow map algorithm
		//
		vec4 texel = textureCube(u_depthMap, t_lightVec);
		vec2 moments = vec2(unpackHalf(texel.xy), unpackHalf(texel.zw));
		shadow = chebychevInequality(moments, depth);
		//shadow = vsmFixLightBleed(shadow, 0.1);
	}
	else
	{
		//
		// Exponential shadow map algorithm
		//
		float c = 4.0;
		vec4 texel = textureCube(u_depthMap, t_lightVec);
		shadow = clamp(exp(-c * (depth - unpack(texel))), 0.0, 1.0);
	}
	
	
	//
	// Apply colour and shadow
	//
	gl_FragColor = clamp(vec4(colour * shadow, u_material.diffuse.w), 0.0, 1.0);
}