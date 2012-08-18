// This post-process shader refracts pixels that have their alpha channel set to
// 0. To animate
// the refraction, increase the RandomNumber value by some amount.

// Constructor.

function RefractionShader() {

	// Setup inherited members.

	ImageShader.call(this);

	// Shader variables.

	this.mAmplitudeId
	this.mFrequencyId
	this.mPeriodId
	this.mRandomNumberId

	// Gets or sets the size of refraction.

	this.Amplitude = 1.0;

	// Gets or sets the frequency of the refraction. Larger numbers produce
	// more grain.

	this.Frequency = 256.0;

	// Gets or sets the relative speed (period).

	this.Period = 4.0;

	// Gets or sets the random number to supply into the shader. This can
	// be used to animate the noise.

	this.RandomNumber = 0.0;

	// View matrices not used
	this.Projection = new Matrix(4, 4);
	this.View = new Matrix(4, 4);
}

// Prototypal Inheritance.

RefractionShader.prototype = new ImageShader();
RefractionShader.prototype.constructor = RefractionShader;

// Implementation.

RefractionShader.prototype.Init = function() {
	ImageShader.prototype.Init.call(this);

	// Get variables
	this.mAmplitudeId = this.getVariable("Amplitude");
	this.mFrequencyId = this.getVariable("Frequency");
	this.mPeriodId = this.getVariable("Period");
	this.mRandomNumberId = this.getVariable("RandomNumber");
}
// Implementation.

RefractionShader.prototype.Enable = function() {
	ImageShader.prototype.Enable.call(this);

	// Set values
	this.setVariable(this.mAmplitudeId, this.Amplitude);
	this.setVariable(this.mFrequencyId, this.Frequency);
	this.setVariable(this.mPeriodId, this.Period);
	this.setVariable(this.mRandomNumberId, this.RandomNumber);
}
// Implementation.

//RefractionShader.prototype.Draw = function (entity, numPoints, numIndices)
//{
// Forward
//	ImageShader.prototype.Draw.call(this, entity, numPoints, numIndices);
//}