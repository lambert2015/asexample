// Depth shader renders the depth values to an RGB texture.
function DepthShader() {
	// Setup inherited members.
	BaseShader.call(this);

	// Shader variables.
	this.mProjectionId
	this.mViewId
	this.mModelId
	this.mModelScaleId
	this.mFilterTypeId
	this.mNearId
	this.mFarId

	// Projection matrix.
	this.projection

	// View matrix.
	this.view

	// Gets or sets the near and far clipping planes, which determine
	// how to compute the linear depth values.
	this.near = 0.0;
	this.far = 0.0;
}

// Prototypal Inheritance.
DepthShader.prototype = new BaseShader();
DepthShader.prototype.constructor = DepthShader;

// Implementation.
DepthShader.prototype.init = function() {
	BaseShader.prototype.init.call(this);

	// Get matrices
	this.mProjectionId = this.getVariable("u_projectionMatrix");
	this.mViewId = this.getVariable("u_viewMatrix");
	this.mModelId = this.getVariable("u_modelMatrix");
	this.mModelScaleId = this.getVariable("u_modelScale");

	// Get variables
	this.mNearId = this.getVariable("u_near");
	this.mFarId = this.getVariable("u_far");
}
// Implementation.
DepthShader.prototype.enable = function() {
	BaseShader.prototype.enable.call(this);

	// Set variables
	this.setVariable(this.mNearId, this.near);
	this.setVariable(this.mFarId, this.far);
}
// Implementation.
DepthShader.prototype.draw = function(entity, numPoints, numIndices) {
	// Matrices
	this.setMatrix(this.mProjectionId, this.projection.elements, 4);
	this.setMatrix(this.mViewId, this.view.elements, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.elements, 4);

	var scale = entity.objectMatrix.getScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);

	// Draw
	BaseShader.prototype.draw.call(this, entity.objectEntity, numPoints, numIndices);
}