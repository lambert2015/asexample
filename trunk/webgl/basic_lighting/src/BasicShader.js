// This shader is the default or "basic" shader that passes lighting and
// material parameters to the vertex and fragment shaders for rendering.
function BasicShader ()
{
	// Setup inherited members.
	BaseShader.call(this);
	
	// Shader variables.
	this.mProjectionId;
	this.mViewId;
	this.mModelId;
	this.mModelScaleId;

	this.mShadingTypeId;
	this.mNumLightId;
	this.mLightId;		// Array of light sources
	this.mMaterialId;
	this.mSampleId;		// Array of texture samples


	
	// Projection matrix.
	this.Projection;

	// View matrix.
	this.View;
	
	// Shading type.
	// 0 = Gouraud shading
	// 1 = Phong shading
	this.ShadingType = 1;
	
	// Array of light objects.
	this.LightObject = [];
}

// Prototypal Inheritance.
BasicShader.prototype = new BaseShader();
BasicShader.prototype.constructor = BasicShader;

// Light source structure.
BasicShader.LightSource = function ()
{
	this.positionId;
	this.attenuationId;
	this.directionId;
	this.colourId;
	this.outerCutoffId;
	this.InnerCutoffId;
	this.exponentId;
}

// Material structure.
BasicShader.MaterialSource = function ()
{
	this.ambientId;
	this.diffuseId;
	this.specularId;
	this.shininessId;
	this.textureOffsetId;
	this.textureScaleId;
}

// Implementation.
BasicShader.prototype.Init = function ()
{
	BaseShader.prototype.Init.call(this);

	// Get matrices
	this.mProjectionId = this.GetVariable("ProjectionMatrix");
	this.mViewId = this.GetVariable("ViewMatrix");
	this.mModelId = this.GetVariable("ModelMatrix");
	this.mModelScaleId = this.GetVariable("ModelScale");

	
	// Get Shading type
	this.mShadingTypeId = this.GetVariable("ShadingType");
	
	
	// Get light sources
	this.mNumLightId = this.GetVariable("NumLight");
	
	this.mLightId = new Array();
	var lightPosId;
	var index = 0;
	do
	{
		lightPosId = this.GetVariable("Light[" + index + "].position");
		if ( lightPosId != null )
		{
			var light = new BasicShader.LightSource();
			light.positionId	= lightPosId;
			light.attenuationId	= this.GetVariable("Light[" + index + "].attenuation");
			light.directionId	= this.GetVariable("Light[" + index + "].direction");
			light.colourId		= this.GetVariable("Light[" + index + "].colour");
			light.outerCutoffId	= this.GetVariable("Light[" + index + "].outerCutoff");
			light.InnerCutoffId	= this.GetVariable("Light[" + index + "].innerCutoff");
			light.exponentId	= this.GetVariable("Light[" + index + "].exponent");
			
			this.mLightId.push(light);			
			++index;
		}
	}
	while ( lightPosId != null );

	
	// Get material
	this.mMaterialId = new BasicShader.MaterialSource();
	this.mMaterialId.ambientId			= this.GetVariable("Material.ambient");
	this.mMaterialId.diffuseId			= this.GetVariable("Material.diffuse");
	this.mMaterialId.specularId			= this.GetVariable("Material.specular");
	this.mMaterialId.shininessId		= this.GetVariable("Material.shininess");
	this.mMaterialId.textureOffsetId	= this.GetVariable("Material.textureOffset");
	this.mMaterialId.textureScaleId		= this.GetVariable("Material.textureScale");
	
	
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



// Implementation.

BasicShader.prototype.Enable = function ()
{
	BaseShader.prototype.Enable.call(this);
	
	for (var i = 0; i < this.mSampleId.length; ++i)
	{
		if ( i < this.mSampleId.length )
			this.SetVariableInt(this.mSampleId[i], i);
	}
	
	// Set shading type
	this.SetVariableInt(this.mShadingTypeId, this.ShadingType);


	// Set light sources
	this.SetVariableInt(this.mNumLightId, this.LightObject.length);
	for (var i = 0; (i < this.mLightId.length) && (i < this.LightObject.length); ++i)
	{
		this.SetVariable(this.mLightId[i].positionId, this.LightObject[i].Position.x, this.LightObject[i].Position.y, this.LightObject[i].Position.z);
		this.SetVariable(this.mLightId[i].attenuationId, this.LightObject[i].Attenuation.x, this.LightObject[i].Attenuation.y, this.LightObject[i].Attenuation.z);
		this.SetVariable(this.mLightId[i].directionId, this.LightObject[i].Direction.x, this.LightObject[i].Direction.y, this.LightObject[i].Direction.z);
		this.SetVariable(this.mLightId[i].colourId, this.LightObject[i].Colour.x, this.LightObject[i].Colour.y, this.LightObject[i].Colour.z);
		this.SetVariable(this.mLightId[i].outerCutoffId, this.LightObject[i].OuterCutoff);
		this.SetVariable(this.mLightId[i].InnerCutoffId, this.LightObject[i].InnerCutoff);
		this.SetVariable(this.mLightId[i].exponentId, this.LightObject[i].Exponent);
	}
}



// Implementation.

BasicShader.prototype.Draw = function (entity, numPoints, numIndices)
{
	// Set matrices
	this.SetMatrix(this.mProjectionId, this.Projection.MMatrix, 4);
	this.SetMatrix(this.mViewId, this.View.MMatrix, 4);
	this.SetMatrix(this.mModelId, entity.ObjectMatrix.MMatrix, 4);
	
	var scale = entity.ObjectMatrix.GetScale();
	this.SetVariable(this.mModelScaleId, scale.x, scale.y, scale.z);
	

	// Set material
	var material = entity.ObjectMaterial;
	this.SetVariable(this.mMaterialId.ambientId, material.Ambient.x, material.Ambient.y, material.Ambient.z);
	this.SetVariable(this.mMaterialId.diffuseId, material.Diffuse.x, material.Diffuse.y, material.Diffuse.z, material.Alpha);
	this.SetVariable(this.mMaterialId.specularId, material.Specular.x, material.Specular.y, material.Specular.z);
	this.SetVariable(this.mMaterialId.shininessId, material.Shininess);
	this.SetVariable(this.mMaterialId.textureOffsetId, material.TextureOffset.x, material.TextureOffset.y);
	this.SetVariable(this.mMaterialId.textureScaleId, material.TextureScale.x, material.TextureScale.y);
	
	
	// Set texture samples
	if ( (material.Texture != null) && (material.Texture.length != null) )
	{
		for (var i = 0; i < material.Texture.length; ++i)
		{
			gl.activeTexture(gl.TEXTURE0 + i);
			material.Texture[i].Bind();
		}
	}

	// Draw
	BaseShader.prototype.Draw.call(this, entity.ObjectEntity, numPoints, numIndices);
}