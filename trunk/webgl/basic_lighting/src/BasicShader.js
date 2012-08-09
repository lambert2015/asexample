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
	this.mProjectionId = this.getVariable("ProjectionMatrix");
	this.mViewId = this.getVariable("ViewMatrix");
	this.mModelId = this.getVariable("ModelMatrix");
	this.mModelScaleId = this.getVariable("ModelScale");

	
	// Get Shading type
	this.mShadingTypeId = this.getVariable("ShadingType");
	
	
	// Get light sources
	this.mNumLightId = this.getVariable("NumLight");
	
	this.mLightId = new Array();
	var lightPosId;
	var index = 0;
	do
	{
		lightPosId = this.getVariable("Light[" + index + "].position");
		if ( lightPosId != null )
		{
			var light = new BasicShader.LightSource();
			light.positionId	= lightPosId;
			light.attenuationId	= this.getVariable("Light[" + index + "].attenuation");
			light.directionId	= this.getVariable("Light[" + index + "].direction");
			light.colourId		= this.getVariable("Light[" + index + "].colour");
			light.outerCutoffId	= this.getVariable("Light[" + index + "].outerCutoff");
			light.InnerCutoffId	= this.getVariable("Light[" + index + "].innerCutoff");
			light.exponentId	= this.getVariable("Light[" + index + "].exponent");
			
			this.mLightId.push(light);			
			++index;
		}
	}
	while ( lightPosId != null );

	
	// Get material
	this.mMaterialId = new BasicShader.MaterialSource();
	this.mMaterialId.ambientId			= this.getVariable("Material.ambient");
	this.mMaterialId.diffuseId			= this.getVariable("Material.diffuse");
	this.mMaterialId.specularId			= this.getVariable("Material.specular");
	this.mMaterialId.shininessId		= this.getVariable("Material.shininess");
	this.mMaterialId.textureOffsetId	= this.getVariable("Material.textureOffset");
	this.mMaterialId.textureScaleId		= this.getVariable("Material.textureScale");
	
	
	// Get texture samples
	this.mSampleId = new Array();
	var sampleId;
	index = 0;
	do
	{
		sampleId = this.getVariable("Sample" + index);
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
			this.setVariableInt(this.mSampleId[i], i);
	}
	
	// Set shading type
	this.setVariableInt(this.mShadingTypeId, this.ShadingType);


	// Set light sources
	this.setVariableInt(this.mNumLightId, this.LightObject.length);
	for (var i = 0; (i < this.mLightId.length) && (i < this.LightObject.length); ++i)
	{
		this.setVariable(this.mLightId[i].positionId, this.LightObject[i].Position.x, this.LightObject[i].Position.y, this.LightObject[i].Position.z);
		this.setVariable(this.mLightId[i].attenuationId, this.LightObject[i].Attenuation.x, this.LightObject[i].Attenuation.y, this.LightObject[i].Attenuation.z);
		this.setVariable(this.mLightId[i].directionId, this.LightObject[i].Direction.x, this.LightObject[i].Direction.y, this.LightObject[i].Direction.z);
		this.setVariable(this.mLightId[i].colourId, this.LightObject[i].Colour.x, this.LightObject[i].Colour.y, this.LightObject[i].Colour.z);
		this.setVariable(this.mLightId[i].outerCutoffId, this.LightObject[i].OuterCutoff);
		this.setVariable(this.mLightId[i].InnerCutoffId, this.LightObject[i].InnerCutoff);
		this.setVariable(this.mLightId[i].exponentId, this.LightObject[i].Exponent);
	}
}



// Implementation.

BasicShader.prototype.Draw = function (entity, numPoints, numIndices)
{
	// Set matrices
	this.setMatrix(this.mProjectionId, this.Projection.MMatrix, 4);
	this.setMatrix(this.mViewId, this.View.MMatrix, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.MMatrix, 4);
	
	var scale = entity.objectMatrix.GetScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);
	

	// Set material
	var material = entity.objectMaterial;
	this.setVariable(this.mMaterialId.ambientId, material.Ambient.x, material.Ambient.y, material.Ambient.z);
	this.setVariable(this.mMaterialId.diffuseId, material.Diffuse.x, material.Diffuse.y, material.Diffuse.z, material.Alpha);
	this.setVariable(this.mMaterialId.specularId, material.Specular.x, material.Specular.y, material.Specular.z);
	this.setVariable(this.mMaterialId.shininessId, material.Shininess);
	this.setVariable(this.mMaterialId.textureOffsetId, material.TextureOffset.x, material.TextureOffset.y);
	this.setVariable(this.mMaterialId.textureScaleId, material.TextureScale.x, material.TextureScale.y);
	
	
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
	BaseShader.prototype.Draw.call(this, entity.objectEntity, numPoints, numIndices);
}