
// Nutty Software Open WebGL Framework
// 
// Copyright (C) 2012 Nathaniel Meyer
// Nutty Software, http://www.nutty.ca
// All Rights Reserved.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//     1. The above copyright notice and this permission notice shall be included in all
//        copies or substantial portions of the Software.
//     2. Redistributions in binary or minimized form must reproduce the above copyright
//        notice and this list of conditions in the documentation and/or other materials
//        provided with the distribution.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.




// This shader is the default or "basic" shader that passes lighting and
// material parameters to the vertex and fragment shaders for rendering.




// Constructor.

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
	
	this.LightObject = new Array();
}



// Prototypal Inheritance.

BasicShader.prototype = new BaseShader();
BasicShader.prototype.constructor = BasicShader;



// Light source structure.

BasicShader.LightSource = function ()
{
	this.TypeId;
	this.PositionId;
	this.AttenuationId;
	this.DirectionId;
	this.ColourId;
	this.OuterCutoffId;
	this.InnerCutoffId;
	this.ExponentId;
}



// Material structure.

BasicShader.MaterialSource = function ()
{
	this.AmbientId;
	this.DiffuseId;
	this.SpecularId;
	this.ShininessId;
	this.TextureOffsetId;
	this.TextureScaleId;
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
		lightPosId = this.GetVariable("Light[" + index + "].Position");
		if ( lightPosId != null )
		{
			var light = new BasicShader.LightSource();
			light.PositionId	= lightPosId;
			light.TypeId		= this.GetVariable("Light[" + index + "].Type");
			light.AttenuationId	= this.GetVariable("Light[" + index + "].Attenuation");
			light.DirectionId	= this.GetVariable("Light[" + index + "].Direction");
			light.ColourId		= this.GetVariable("Light[" + index + "].Colour");
			light.OuterCutoffId	= this.GetVariable("Light[" + index + "].OuterCutoff");
			light.InnerCutoffId	= this.GetVariable("Light[" + index + "].InnerCutoff");
			light.ExponentId	= this.GetVariable("Light[" + index + "].Exponent");
			
			this.mLightId.push(light);			
			++index;
		}
	}
	while ( lightPosId != null );

	
	// Get material
	this.mMaterialId = new BasicShader.MaterialSource();
	this.mMaterialId.AmbientId			= this.GetVariable("Material.Ambient");
	this.mMaterialId.DiffuseId			= this.GetVariable("Material.Diffuse");
	this.mMaterialId.SpecularId			= this.GetVariable("Material.Specular");
	this.mMaterialId.ShininessId		= this.GetVariable("Material.Shininess");
	this.mMaterialId.TextureOffsetId	= this.GetVariable("Material.TextureOffset");
	this.mMaterialId.TextureScaleId		= this.GetVariable("Material.TextureScale");
	
	
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
		this.SetVariableInt(this.mLightId[i].TypeId, this.LightObject[i].LightType);
		this.SetVariable(this.mLightId[i].PositionId, this.LightObject[i].Position.x, this.LightObject[i].Position.y, this.LightObject[i].Position.z);
		this.SetVariable(this.mLightId[i].AttenuationId, this.LightObject[i].Attenuation.x, this.LightObject[i].Attenuation.y, this.LightObject[i].Attenuation.z);
		this.SetVariable(this.mLightId[i].DirectionId, this.LightObject[i].Direction.x, this.LightObject[i].Direction.y, this.LightObject[i].Direction.z);
		this.SetVariable(this.mLightId[i].ColourId, this.LightObject[i].Colour.x, this.LightObject[i].Colour.y, this.LightObject[i].Colour.z);
		this.SetVariable(this.mLightId[i].OuterCutoffId, this.LightObject[i].OuterCutoff);
		this.SetVariable(this.mLightId[i].InnerCutoffId, this.LightObject[i].InnerCutoff);
		this.SetVariable(this.mLightId[i].ExponentId, this.LightObject[i].Exponent);
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
	this.SetVariable(this.mMaterialId.AmbientId, material.Ambient.x, material.Ambient.y, material.Ambient.z);
	this.SetVariable(this.mMaterialId.DiffuseId, material.Diffuse.x, material.Diffuse.y, material.Diffuse.z, material.Alpha);
	this.SetVariable(this.mMaterialId.SpecularId, material.Specular.x, material.Specular.y, material.Specular.z);
	this.SetVariable(this.mMaterialId.ShininessId, material.Shininess);
	this.SetVariable(this.mMaterialId.TextureOffsetId, material.TextureOffset.x, material.TextureOffset.y);
	this.SetVariable(this.mMaterialId.TextureScaleId, material.TextureScale.x, material.TextureScale.y);
	
	
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