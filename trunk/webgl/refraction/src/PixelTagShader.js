// This shader renders geometry to the alpha channel, which will be used by the
// refraction shader
// to process tagged pixels. The fragment shader will tag pixels by setting their
// alpha value to 0.

// Constructor.

function PixelTagShader() {

	// Setup inherited members.

	BaseShader.call(this);

	// Shader variables.

	this.mProjectionId
	this.mViewId
	this.mModelId
	this.mModelScaleId

	// Projection matrix.

	this.Projection

	// View matrix.

	this.View
}

// Prototypal Inheritance.

PixelTagShader.prototype = new BaseShader();
PixelTagShader.prototype.constructor = PixelTagShader;

// Implementation.

PixelTagShader.prototype.Init = function() {
	BaseShader.prototype.Init.call(this);

	// Get matrices
	this.mProjectionId = this.getVariable("ProjectionMatrix");
	this.mViewId = this.getVariable("ViewMatrix");
	this.mModelId = this.getVariable("ModelMatrix");
	this.mModelScaleId = this.getVariable("ModelScale");
}
// Implementation.

PixelTagShader.prototype.Enable = function() {
	BaseShader.prototype.Enable.call(this);

	// Disable colour RGB writes and depth writes
	gl.depthMask(false);
	gl.colorMask(false, false, false, true)
}
// Implementation.

PixelTagShader.prototype.Disable = function() {
	BaseShader.prototype.Disable.call(this);

	// Restore colour RGB writes
	gl.depthMask(true);
	gl.colorMask(true, true, true, true)
}
// Implementation.

PixelTagShader.prototype.Draw = function(entity, numPoints, numIndices) {
	// Set matrices
	this.setMatrix(this.mProjectionId, this.Projection.elements, 4);
	this.setMatrix(this.mViewId, this.View.elements, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.elements, 4);

	var scale = entity.objectMatrix.GetScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);

	// Draw
	BaseShader.prototype.Draw.call(this, entity.objectEntity, numPoints, numIndices);
}