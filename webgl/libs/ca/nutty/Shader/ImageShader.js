// <summary>
// Image shader renderer (base shader for image processing).
// </summary>


// <summary>
// Constructor.
// </summary>
function ImageShader ()
{
	// <summary>
	// Setup inherited members.
	// </summary>
	BaseShader.call(this);
	

	// <summary>
	// Image Fragment Variables.
	// </summary>
	this.mProjectionId;
	this.mViewId;
	this.mModelId;
	this.mModelScaleId;
	
	this.mImageSizeId;
	this.mTexelSizeId;
	this.mColourId;
	
	
	// <summary>
	// Array of texture samples
	// </summary>
	this.mSampleId;
	
	
	// <summary>
	// Projection matrix.
	// </summary>
	this.Projection;


	// <summary>
	// View matrix.
	// </summary>
	this.View;
	
	
	// <summary>
	// Stores the size of the image.
	// </summary>
	this.mImageSize = new Point();
	
	
	// <summary>
	// Stores the size of one texel.
	// </summary>
	this.mTexelSize = new Point();
}


// <summary>
// Prototypal Inheritance.
// </summary>
ImageShader.prototype = new BaseShader();
ImageShader.prototype.constructor = ImageShader;


// <summary>
// Implementation.
// </summary>
ImageShader.prototype.Init = function ()
{
	BaseShader.prototype.Init.call(this);

	// Get shader variables
	this.mProjectionId = this.GetVariable("ProjectionMatrix");
	this.mViewId = this.GetVariable("ViewMatrix");
	this.mModelId = this.GetVariable("ModelMatrix");
	this.mModelScaleId = this.GetVariable("ModelScale");
	
	this.mImageSizeId = this.GetVariable("ImageSize");
	this.mTexelSizeId = this.GetVariable("TexelSize");
	this.mColourId = this.GetVariable("Colour");
	
	// Get texture samples
	this.mSampleId = new Array();
	var sampleId;
	index = 0;
	do
	{
		sampleId = this.GetVariable("Sample" + index);
		if ( sampleId != null )
		{
			this.mSampleId.push(sampleId);
			++index;
		}
	}
	while ( sampleId != null );
}


// <summary>
// Implementation.
// </summary>
ImageShader.prototype.Enable = function ()
{
	BaseShader.prototype.Enable.call(this);
	
	// Initialize samples
	for (var i = 0; i < this.mSampleId.length; ++i)
	{
		if ( i < this.mSampleId.length )
			this.SetVariableInt(this.mSampleId[i], i);
	}
}


// <summary>
// Sets the size of the image.
// </summary>
ImageShader.prototype.SetSize = function (width, height)
{
	this.mImageSize.x = width;
	this.mImageSize.y = height;
	
	this.mTexelSize.x = (width != 0.0) ? 1.0 / width : 0.0;
	this.mTexelSize.y = (height != 0.0) ? 1.0 / height : 0.0;
}


// <summary>
// Implementation.
// </summary>
ImageShader.prototype.Draw = function (entity, numPoints, numIndices)
{
	// Set matrices
	this.SetMatrix(this.mProjectionId, this.Projection.MMatrix, 4);
	this.SetMatrix(this.mViewId, this.View.MMatrix, 4);
	this.SetMatrix(this.mModelId, entity.ObjectMatrix.MMatrix, 4);
	
	var scale = entity.ObjectMatrix.GetScale();
	this.SetVariable(this.mModelScaleId, scale.x, scale.y, scale.z);

	// Set material
	var material = entity.ObjectMaterial;
	this.SetVariable(this.mImageSizeId, this.mImageSize.x, this.mImageSize.y);
	this.SetVariable(this.mTexelSizeId, this.mTexelSize.x, this.mTexelSize.y);
	this.SetVariable(this.mColourId, material.Diffuse.x, material.Diffuse.y, material.Diffuse.z, material.Alpha);

	// Set texture samples
	if ( (material.Texture != null) && (material.Texture.length != null) && (material.Texture.length > 0) )
	{
		for (var i = 0; (i < material.Texture.length) && (i < this.mSampleId.length); ++i)
		{
			gl.activeTexture(gl.TEXTURE0 + i);
			material.Texture[i].Bind();
		}
	}
	
	// Draw
	BaseShader.prototype.Draw.call(this, entity.ObjectEntity, numPoints, numIndices);
}