// Gaussian blur shader performs a box-blur on the target texture (aka: seperable
// box filter).
// It requires two passes. The first pass blurs the target along the horizontal
// axis. The
// second pass blurs the target along the vertical axis.
function GaussianBlurShader() {

	// Setup inherited members.
	ImageShader.call(this);

	// Shader variables.
	this.mOrientationId
	this.mBlurAmountId
	this.mCubeFaceId

	// Gets or sets the amount of bluring.
	this.blurAmount = 0;

	// Gets or sets the face of the cube being blurred.
	this.cubeFace = 0;
}

// Prototypal Inheritance.
GaussianBlurShader.prototype = new ImageShader();
GaussianBlurShader.prototype.constructor = GaussianBlurShader;

// Implementation.
GaussianBlurShader.prototype.init = function() {
	ImageShader.prototype.init.call(this);

	// Get variables
	this.mOrientationId = this.getVariable("u_orientation");
	this.mBlurAmountId = this.getVariable("u_blurAmount");
	this.mCubeFaceId = this.getVariable("u_cubeFace");
}
// Implementation.

GaussianBlurShader.prototype.enable = function() {
	ImageShader.prototype.enable.call(this);

	// Set variables
	this.setVariableInt(this.mBlurAmountId, this.blurAmount);
}
// Implementation.
GaussianBlurShader.prototype.draw = function(entity, orientation, numPoints, numIndices) {
	// Blur on the horizontal axis
	this.setVariableInt(this.mOrientationId, orientation);
	this.setVariableInt(this.mCubeFaceId, this.cubeFace);
	ImageShader.prototype.draw.call(this, entity, numPoints, numIndices);
}