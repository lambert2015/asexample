// This post-process shader adjusts the brightness and contrast of a texture.
function BrightnessShader ()
{
	
	// Setup inherited members.
	ImageShader.call(this);
	
	// Shader variables.
	this.mBrightnessId;
	this.mContrastId;
	this.mInvGammaId;

	// Gets or sets the brightness value to use.
	// Valid range: -1 to 1
	// Default is neutral brightness (0.0).
	this.brightness = 0.0;

	// Gets or sets the contrast value to use.
	// Valid range: -1 to 1
	// Default is neural constrast (0.0).
	this.contrast = 1.0;
	
	// Specifies the inverse gamma value to use.
	this.invGamma = 1.0 / 2.2;
	
	// View matrices not used
	this.projection = new Matrix(4, 4);
	this.view = new Matrix(4, 4);
}



// Prototypal Inheritance.

BrightnessShader.prototype = new ImageShader();
BrightnessShader.prototype.constructor = BrightnessShader;



// Implementation.

BrightnessShader.prototype.init = function ()
{
	ImageShader.prototype.init.call(this);

	// Get variables
	this.mBrightnessId = this.getVariable("u_brightness");
	this.mContrastId = this.getVariable("u_contrast");
	this.mInvGammaId = this.getVariable("u_invGamma");
}



// Implementation.

BrightnessShader.prototype.enable = function ()
{
	ImageShader.prototype.enable.call(this);
	
	// Set values
	this.setVariable(this.mBrightnessId, this.brightness);
	this.setVariable(this.mContrastId, this.contrast);
	this.setVariable(this.mInvGammaId, this.invGamma);
}



// Implementation.

//BrightnessShader.prototype.draw = function (entity, numPoints, numIndices)
//{
	// Forward
//	ImageShader.prototype.draw.call(this, entity, numPoints, numIndices);
//}