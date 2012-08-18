// The blur shader performs a box-blur on the target texture (aka: separable box
// filter).
// It requires two passes. The first pass blurs the target along the horizontal
// axis. The
// second pass blurs the target along the vertical axis.
function DofBlurShader() {

	// Setup inherited members.
	ImageShader.call(this);

	// Shader variables.
	this.mOrientationId
	this.mBlurAmountId
	this.mBlurCoefficientId
	this.mFocusDistanceId
	this.mNearId
	this.mFarId
	this.mPPMId

	// Gets or sets the coefficient used during the blur process.
	// This property helps to reduce the GPU cycles in order to calculate
	// the blur diameter.
	//
	// It is equal to (f * ms) / N.
	// Where:
	// f = focal length
	// ms = magnitude of subject in focus
	// N is the fstop
	this.blurCoefficient = 0;

	// Gets or sets camera properties used in the bluring process.
	this.focalLength = 0.0;
	this.focusDistance = 0.0;
	this.fStop = 0.0;

	// Gets or sets the near and far clipping planes.
	this.near = 0.0;
	this.far = 0.0;

	// Gets or sets the pixels per millimetre. This is used to determine how many
	// pixels to blur
	// from the result returned in the DOF blur equation.
	this.mPPM = 0;
}

// Prototypal Inheritance.
DofBlurShader.prototype = new ImageShader();
DofBlurShader.prototype.constructor = DofBlurShader;

// Implementation.
DofBlurShader.prototype.init = function() {
	ImageShader.prototype.init.call(this);

	// Get variables
	this.mOrientationId = this.getVariable("u_orientation");
	this.mBlurCoefficientId = this.getVariable("u_blurCoefficient");
	this.mFocusDistanceId = this.getVariable("u_focusDistance");
	this.mNearId = this.getVariable("u_near");
	this.mFarId = this.getVariable("u_far");
	this.mPPMId = this.getVariable("u_pPM");
}
// Sets the size of the image.

DofBlurShader.prototype.setSize = function(width, height) {
	// Call base method
	ImageShader.prototype.setSize.call(this, width, height);

	// Set PPM (assume 35mm camera sensor)
	this.mPPM = Math.sqrt((width * width) + (height * height)) / 35.0;
}
// Implementation.

DofBlurShader.prototype.enable = function() {
	ImageShader.prototype.enable.call(this);

	// Set variables
	this.setVariable(this.mBlurCoefficientId, this.blurCoefficient);
	this.setVariable(this.mFocusDistanceId, this.focusDistance);
	this.setVariable(this.mNearId, this.near);
	this.setVariable(this.mFarId, this.far);
	this.setVariable(this.mPPMId, this.mPPM);
}
// Implementation.

DofBlurShader.prototype.draw = function(entity, orientation, numPoints, numIndices) {
	// Blur on the horizontal axis
	this.setVariableInt(this.mOrientationId, orientation);
	ImageShader.prototype.draw.call(this, entity, numPoints, numIndices);
}
// Calculates the blur coefficient with the specified camera properties.
// Calculating this here saves some GPU cycles.

DofBlurShader.prototype.updateBlurCoefficient = function() {
	var ms = this.focalLength / ((this.focusDistance * 1000.0) - this.focalLength);
	this.blurCoefficient = (this.focalLength * ms) / this.fStop;
}