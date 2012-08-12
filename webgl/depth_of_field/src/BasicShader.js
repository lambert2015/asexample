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
	this.projection;

	// View matrix.
	this.view;
	
	// Shading type.
	// 0 = Gouraud shading
	// 1 = Phong shading
	this.shadingType = 1;
	
	// Array of light objects.
	this.lightObject = [];
}

// Prototypal Inheritance.
BasicShader.prototype = new BaseShader();
BasicShader.prototype.constructor = BasicShader;

// Light source structure.
BasicShader.LightSource = function ()
{
	this.typeId;
	this.positionId;
	this.attenuationId;
	this.directionId;
	this.colourId;
	this.outerCutoffId;
	this.innerCutoffId;
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
BasicShader.prototype.init = function ()
{
	BaseShader.prototype.init.call(this);

	// Get matrices
	this.mProjectionId = this.getVariable("u_projectionMatrix");
	this.mViewId = this.getVariable("u_viewMatrix");
	this.mModelId = this.getVariable("u_modelMatrix");
	this.mModelScaleId = this.getVariable("u_modelScale");

	// Get Shading type
	this.mShadingTypeId = this.getVariable("u_shadingType");
	
	// Get light sources
	this.mNumLightId = this.getVariable("u_numLight");
	
	this.mLightId = [];
	var lightPosId;
	var index = 0;
	do
	{
		lightPosId = this.getVariable("u_lights[" + index + "].position");
		if ( lightPosId != null )
		{
			var light = new BasicShader.LightSource();
			light.positionId	= lightPosId;
			light.TypeId		= this.getVariable("u_lights[" + index + "].type");
			light.attenuationId	= this.getVariable("u_lights[" + index + "].attenuation");
			light.directionId	= this.getVariable("u_lights[" + index + "].direction");
			light.colourId		= this.getVariable("u_lights[" + index + "].colour");
			light.outerCutoffId	= this.getVariable("u_lights[" + index + "].outerCutoff");
			light.innerCutoffId	= this.getVariable("u_lights[" + index + "].innerCutoff");
			light.exponentId	= this.getVariable("u_lights[" + index + "].exponent");
			
			this.mLightId.push(light);			
			++index;
		}
	}
	while ( lightPosId != null );

	
	// Get material
	this.mMaterialId = new BasicShader.MaterialSource();
	this.mMaterialId.ambientId			= this.getVariable("u_material.ambient");
	this.mMaterialId.diffuseId			= this.getVariable("u_material.diffuse");
	this.mMaterialId.specularId			= this.getVariable("u_material.specular");
	this.mMaterialId.shininessId		= this.getVariable("u_material.shininess");
	this.mMaterialId.textureOffsetId	= this.getVariable("u_material.textureOffset");
	this.mMaterialId.textureScaleId		= this.getVariable("u_material.textureScale");
	
	
	// Get texture samples
	this.mSampleId = [];
	var sampleId;
	index = 0;
	do
	{
		sampleId = this.getVariable("u_sample" + index);
		if ( sampleId != null )
		{
			this.mSampleId.push(sampleId);
			++index;
		}
	}
	while ( sampleId != null );
}

// Implementation.
BasicShader.prototype.enable = function ()
{
	BaseShader.prototype.enable.call(this);
	
	for (var i = 0; i < this.mSampleId.length; ++i)
	{
		if ( i < this.mSampleId.length )
			this.setVariableInt(this.mSampleId[i], i);
	}
	
	// Set shading type
	this.setVariableInt(this.mShadingTypeId, this.shadingType);


	// Set light sources
	this.setVariableInt(this.mNumLightId, this.lightObject.length);
	for (var i = 0; (i < this.mLightId.length) && (i < this.lightObject.length); ++i)
	{
		var lightSrc = this.mLightId[i];
		var light = this.lightObject[i];
		this.setVariableInt(lightSrc.typeId, light.lightType);
		this.setVariable(lightSrc.positionId, light.position.x, light.position.y, light.position.z);
		this.setVariable(lightSrc.attenuationId, light.attenuation.x, light.attenuation.y, light.attenuation.z);
		this.setVariable(lightSrc.directionId, light.direction.x, light.direction.y, light.direction.z);
		this.setVariable(lightSrc.colourId, light.colour.x, light.colour.y, light.colour.z);
		this.setVariable(lightSrc.outerCutoffId, light.outerCutoff);
		this.setVariable(lightSrc.innerCutoffId, light.innerCutoff);
		this.setVariable(lightSrc.exponentId, light.exponent);
	}
}



// Implementation.

BasicShader.prototype.draw = function (entity, numPoints, numIndices)
{
	// Set matrices
	this.setMatrix(this.mProjectionId, this.projection.elements, 4);
	this.setMatrix(this.mViewId, this.view.elements, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.elements, 4);
	
	var scale = entity.objectMatrix.getScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);
	

	// Set material
	var material = entity.objectMaterial;
	this.setVariable(this.mMaterialId.ambientId, material.ambient.x, material.ambient.y, material.ambient.z);
	this.setVariable(this.mMaterialId.diffuseId, material.diffuse.x, material.diffuse.y, material.diffuse.z, material.alpha);
	this.setVariable(this.mMaterialId.specularId, material.specular.x, material.specular.y, material.specular.z);
	this.setVariable(this.mMaterialId.shininessId, material.shininess);
	this.setVariable(this.mMaterialId.textureOffsetId, material.textureOffset.x, material.textureOffset.y);
	this.setVariable(this.mMaterialId.textureScaleId, material.textureScale.x, material.textureScale.y);
	
	
	// Set texture samples
	if ( (material.texture != null) && (material.texture.length != null) )
	{
		for (var i = 0; i < material.texture.length; ++i)
		{
			gl.activeTexture(gl.TEXTURE0 + i);
			material.texture[i].bind();
		}
	}


	// Draw
	BaseShader.prototype.draw.call(this, entity.objectEntity, numPoints, numIndices);
}