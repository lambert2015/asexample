// Shader for rendering a cubemapped skybox.

// Constructor.

function SkyboxShader() {

	// Setup inherited members.

	BaseShader.call(this);

	// Shader variables.

	this.mProjectionId
	this.mViewId
	this.mModelId
	this.mModelScaleId
	this.mSampleId// Array of texture samples

	// Projection matrix.

	this.Projection

	// View matrix.

	this.View
}

// Prototypal Inheritance.

SkyboxShader.prototype = new BaseShader();
SkyboxShader.prototype.constructor = SkyboxShader;

// Implementation.

SkyboxShader.prototype.Init = function() {
	BaseShader.prototype.Init.call(this);

	// Get shader variables
	this.mProjectionId = this.getVariable("ProjectionMatrix");
	this.mViewId = this.getVariable("ViewMatrix");
	this.mModelId = this.getVariable("ModelMatrix");
	this.mModelScaleId = this.getVariable("ModelScale");

	// Get texture samples
	this.mSampleId = [];
	var sampleId;
	index = 0;
	do {
		sampleId = this.getVariable("Sample" + index);
		if (sampleId != null) {
			this.mSampleId.push(sampleId); ++index;
		}
	} while ( sampleId != null );
}
// Implementation.

SkyboxShader.prototype.Enable = function() {
	BaseShader.prototype.Enable.call(this);

	for (var i = 0; i < this.mSampleId.length; ++i) {
		if (i < this.mSampleId.length)
			this.setVariableInt(this.mSampleId[i], i);
	}
}
// Implementation.

SkyboxShader.prototype.Draw = function(entity, vbo, numPoints, numIndices) {
	// Set matrices
	this.setMatrix(this.mProjectionId, this.Projection.elements, 4);
	this.setMatrix(this.mViewId, this.View.elements, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.elements, 4);

	var scale = entity.objectMatrix.GetScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);

	// Set texture samples
	var material = entity.objectMaterial;
	if ((material.Texture != null) && (material.Texture.length != null)) {
		for (var i = 0; (i < material.Texture.length) && (i < this.mSampleId.length); ++i) {
			gl.activeTexture(gl.TEXTURE0 + i);
			material.Texture[i].Bind();
		}
	}

	// Draw
	BaseShader.prototype.Draw.call(this, entity.objectEntity, numPoints, numIndices);
}