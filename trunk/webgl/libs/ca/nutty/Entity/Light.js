// <summary>
// This class represents a single light source.
// </summary>


// <summary>
// Constructor.
// </summary>
function Light ()
{
	// <summary>
	// True if the light source should be used in calculations.
	// </summary>
	this.Enabled = true;


	// <summary>
	// The type of light source used.
	// </summary>
	this.LightType = Light.LightSourceType.Point;


	// <summary>
	// Position of the light source.
	// </summary>
	this.Position = new Point();


	// <summary>
	// Attenuation factor.
	//		x = K (Constant)
	//		y = L (Linear)
	//		z = Q (Quadratic)
	// </summary>
	this.Attenuation = new Point(1, 0, 0);


	// <summary>
	// Direction of the light source, used by directional lights.
	// </summary>
	this.Direction = new Point();


	// <summary>
	// Angular cutoff in radians used by directional light sources.
	// </summary>
	this.OuterCutoff = 0.0;
	
	
	// <summary>
	// Inner cutoff in radians used by directional light sources to
	// smooth out the fade. Should be less than or equal to OuterCutoff.
	// </summary>
	this.InnerCutoff = 0.0;


	// <summary>
	// Power used by directional light sources.
	// </summary>
	this.Exponent = 1.0;


	// <summary>
	// Colour of this light source.
	// </summary>
	this.Colour = new Point(1, 1, 1);
	
	
	// Set initial cutoff
	this.SetCutoff(45.0, 0.0);
}


// <summary>
// Enumerator listing the possible light source types.
// </summary>
Light.LightSourceType =
{
	Point : 0,
	Directional : 1
};


// <summary>
// Sets the cutoff for directional light sources in radians.
// </summary>
// <param name="outer">Outer cutoff angle.</param>
// <param name="inner">Inner cutoff angle.</param>
Light.prototype.SetCutoff = function (outer, inner)
{
	if ( inner == null )
		inner = 0.0;

	this.OuterCutoff = Math.cos(outer * (Math.PI / 180.0));
	this.InnerCutoff = Math.cos(inner * (Math.PI / 180.0));
}


// <summary>
// Returns the attenuation factor based on the distance to the target.
// </summary>
// <param name="distance">Distance to the target.</param>
// <returns>Attenuation factor.</returns>
Light.prototype.AttenuationFactor = function (distance)
{
	var attenuation = Attenuation.x + 
					  (Attenuation.y * distance) +
					  (Attenuation.z * (distance * distance));

	if ( attenuation > 0 )
		return 1.0 / attenuation;
	return 1;
}