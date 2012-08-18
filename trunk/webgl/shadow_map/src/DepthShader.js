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

	// Projection matrix.
	this.projection

	// View matrix.
	this.view

	// Specifies the type of shadow map filtering to perform.
	// 0 = None
	// 1 = PCM
	// 2 = VSM
	// 3 = ESM

	this.filterType = 0;
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
	this.mFilterTypeId = this.getVariable("u_filterType");
}
// Implementation.
DepthShader.prototype.enable = function() {
	BaseShader.prototype.enable.call(this);

	// Set variables
	this.setVariableInt(this.mFilterTypeId, this.filterType);
}
// Implementation.
DepthShader.prototype.draw = function(entity, numPoints, numIndices) {
	// Matrices
	this.setMatrix(this.mProjectionId, this.projection.elements, 4);
	this.setMatrix(this.mViewId, this.view.elements, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.elements, 4);

	var scale = entity.objectMatrix.getScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);

	// draw
	BaseShader.prototype.draw.call(this, entity.objectEntity, numPoints, numIndices);
}