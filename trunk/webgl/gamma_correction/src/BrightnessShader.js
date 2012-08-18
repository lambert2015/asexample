
// This post-process shader adjusts the brightness and contrast of a texture.

// Constructor.

function BrightnessShader() {

	// Setup inherited members.

	ImageShader.call(this);

	// Shader variables.

	this.mBrightnessId
	this.mContrastId
	this.mGammaCutoffId
	this.mInvGammaId

	// Gets or sets the brightness value to use.
	// Valid range: -1 to 1
	// Default is neutral brightness (0.0).

	this.Brightness = 0.0;

	// Gets or sets the contrast value to use.
	// Valid range: -1 to 1
	// Default is neural constrast (0.0).

	this.Contrast = 1.0;

	// Specifies the cutoff point where gamma correction is
	// stopped.

	this.GammaCutoff = 1.0;

	// Specifies the inverse gamma value to use.

	this.InvGamma = 1.0 / 2.2;

	// View matrices not used
	this.Projection = new Matrix(4, 4);
	this.View = new Matrix(4, 4);
}

// Prototypal Inheritance.

BrightnessShader.prototype = new ImageShader();
BrightnessShader.prototype.constructor = BrightnessShader;

// Implementation.

BrightnessShader.prototype.Init = function() {
	ImageShader.prototype.Init.call(this);

	// Get variables
	this.mBrightnessId = this.getVariable("Brightness");
	this.mContrastId = this.getVariable("Contrast");
	this.mGammaCutoffId = this.getVariable("GammaCutoff");
	this.mInvGammaId = this.getVariable("InvGamma");
}
// Implementation.

BrightnessShader.prototype.Enable = function() {
	ImageShader.prototype.Enable.call(this);

	// Set values
	this.setVariable(this.mBrightnessId, this.Brightness);
	this.setVariable(this.mContrastId, this.Contrast);
	this.setVariable(this.mGammaCutoffId, this.GammaCutoff);
	this.setVariable(this.mInvGammaId, this.InvGamma);
}
// Implementation.

BrightnessShader.prototype.Draw = function(entity, numPoints, numIndices) {
	// Forward
	ImageShader.prototype.Draw.call(this, entity, numPoints, numIndices);
}