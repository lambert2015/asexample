// The deferred shader outputs geometry data to a texture, which can later be used
// in a post-processing shader to perform some sort of computation on the data. The
// texture storing the geometry data should be of a floating point type.

function DeferredShader ()
{
	
	// Setup inherited members.
	BaseShader.call(this);
	
	// Shader variables.
	this.mProjectionId;
	this.mViewId;
	this.mModelId;
	this.mModelScaleId;
	this.mLinearDepthId;

	// Projection matrix.
	this.projection;

	// View matrix.
	this.view;
	
	// Gets or sets the (Far - Near) clip value used for calculating linear depth.
	// This applies only to storing positional data. RGBA = XYZD (depth).
	this.linearDepth = 0.0;
}

// Prototypal Inheritance.
DeferredShader.prototype = new BaseShader();
DeferredShader.prototype.constructor = DeferredShader;

// Implementation.
DeferredShader.prototype.init = function ()
{
	BaseShader.prototype.init.call(this);
	
	// Get matrices
	this.mProjectionId = this.getVariable("u_projectionMatrix");
	this.mViewId = this.getVariable("u_viewMatrix");
	this.mModelId = this.getVariable("u_modelMatrix");
	this.mModelScaleId = this.getVariable("u_modelScale");
	
	// Get variables
	this.mLinearDepthId = this.getVariable("u_linearDepth");
}



// Implementation.

DeferredShader.prototype.enable = function ()
{
	BaseShader.prototype.enable.call(this);

	// Set variables
	this.setVariable(this.mLinearDepthId, this.linearDepth);
}



// Implementation.

DeferredShader.prototype.draw = function (entity, numPoints, numIndices)
{
	// Matrices
	this.setMatrix(this.mProjectionId, this.projection.elements, 4);
	this.setMatrix(this.mViewId, this.view.elements, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.elements, 4);
	
	var scale = entity.objectMatrix.getScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);

	// draw
	BaseShader.prototype.draw.call(this, entity.objectEntity, numPoints, numIndices);
}