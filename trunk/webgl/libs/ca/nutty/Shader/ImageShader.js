// Image shader renderer (base shader for image processing).
function ImageShader() {
	// Setup inherited members.
	BaseShader.call(this);

	// Image Fragment Variables.
	this.mProjectionId
	this.mViewId
	this.mModelId
	this.mModelScaleId

	this.mImageSizeId
	this.mTexelSizeId
	this.mColourId

	// Array of texture samples
	this.mSampleId

	// Projection matrix.
	this.projection

	// View matrix.
	this.view

	// Stores the size of the image.
	this.mImageSize = new Point();

	// Stores the size of one texel.
	this.mTexelSize = new Point();
}

// Prototypal Inheritance.
ImageShader.prototype = new BaseShader();
ImageShader.prototype.constructor = ImageShader;

// Implementation.
ImageShader.prototype.init = function() {
	BaseShader.prototype.init.call(this);

	// Get shader variables
	this.mProjectionId = this.getVariable("u_projectionMatrix");
	this.mViewId = this.getVariable("u_viewMatrix");
	this.mModelId = this.getVariable("u_modelMatrix");
	this.mModelScaleId = this.getVariable("u_modelScale");

	this.mImageSizeId = this.getVariable("u_imageSize");
	this.mTexelSizeId = this.getVariable("u_texelSize");
	this.mColourId = this.getVariable("u_colour");

	// Get texture samples
	this.mSampleId = [];
	var sampleId;
	index = 0;
	do {
		sampleId = this.getVariable("u_sample" + index);
		if (sampleId != null) {
			this.mSampleId.push(sampleId); ++index;
		}
	} while ( sampleId != null );
}
// Implementation.
ImageShader.prototype.enable = function() {
	BaseShader.prototype.enable.call(this);

	// Initialize samples
	for (var i = 0; i < this.mSampleId.length; ++i) {
		if (i < this.mSampleId.length)
			this.setVariableInt(this.mSampleId[i], i);
	}
}
// Sets the size of the image.
ImageShader.prototype.setSize = function(width, height) {
	this.mImageSize.x = width;
	this.mImageSize.y = height;

	this.mTexelSize.x = (width != 0.0) ? 1.0 / width : 0.0;
	this.mTexelSize.y = (height != 0.0) ? 1.0 / height : 0.0;
}
// Implementation.
ImageShader.prototype.draw = function(entity, numPoints, numIndices) {
	// Set matrices
	this.setMatrix(this.mProjectionId, this.projection.elements, 4);
	this.setMatrix(this.mViewId, this.view.elements, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.elements, 4);

	var scale = entity.objectMatrix.getScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);

	// Set material
	var material = entity.objectMaterial;
	this.setVariable(this.mImageSizeId, this.mImageSize.x, this.mImageSize.y);
	this.setVariable(this.mTexelSizeId, this.mTexelSize.x, this.mTexelSize.y);
	this.setVariable(this.mColourId, material.diffuse.x, material.diffuse.y, material.diffuse.z, material.alpha);

	// Set texture samples
	if ((material.texture != null) && (material.texture.length != null) && (material.texture.length > 0)) {
		for (var i = 0; (i < material.texture.length) && (i < this.mSampleId.length); ++i) {
			gl.activeTexture(gl.TEXTURE0 + i);
			material.texture[i].bind();
		}
	}

	// Draw
	BaseShader.prototype.draw.call(this, entity.objectEntity, numPoints, numIndices);
}