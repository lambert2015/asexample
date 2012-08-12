// This class represents a single light source.

function Light ()
{
	// True if the light source should be used in calculations.
	this.enabled = true;

	// The type of light source used.
	this.lightType = Light.LightSourceType.Point;

	// Position of the light source.
	this.position = new Point();

	// Attenuation factor.
	//		x = K (Constant)
	//		y = L (Linear)
	//		z = Q (Quadratic)
	this.attenuation = new Point(1, 0, 0);
	
	// Direction of the light source, used by directional lights.
	this.direction = new Point();

	// Angular cutoff in radians used by directional light sources.
	this.outerCutoff = 0.0;
	
	// Inner cutoff in radians used by directional light sources to
	// smooth out the fade. Should be less than or equal to OuterCutoff.
	
	this.innerCutoff = 0.0;

	// Power used by directional light sources.
	this.exponent = 1.0;

	// Colour of this light source.
	this.colour = new Point(1, 1, 1);
	
	
	// Set initial cutoff
	this.setCutoff(45.0, 0.0);
}

// Enumerator listing the possible light source types.
Light.LightSourceType =
{
	Point : 0,
	Directional : 1
};


// Sets the cutoff for directional light sources in radians.
// <param name="outer">Outer cutoff angle.</param>
// <param name="inner">Inner cutoff angle.</param>
Light.prototype.setCutoff = function (outer, inner)
{
	if ( inner == null )
		inner = 0.0;

	this.outerCutoff = Math.cos(outer * (Math.PI / 180.0));
	this.innerCutoff = Math.cos(inner * (Math.PI / 180.0));
}

// Returns the attenuation factor based on the distance to the target.
// <param name="distance">Distance to the target.</param>
// <returns>Attenuation factor.</returns>
Light.prototype.attenuationFactor = function (distance)
{
	var attenuation = attenuation.x + 
					  (attenuation.y * distance) +
					  (attenuation.z * (distance * distance));

	if ( attenuation > 0 )
		return 1.0 / attenuation;
	return 1;
}