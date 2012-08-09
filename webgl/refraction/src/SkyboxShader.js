
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




// Shader for rendering a cubemapped skybox.




// Constructor.

function SkyboxShader ()
{
	
	// Setup inherited members.
	
	BaseShader.call(this);
	
	
	
	// Shader variables.
	
	this.mProjectionId;
	this.mViewId;
	this.mModelId;
	this.mModelScaleId;
	this.mSampleId;		// Array of texture samples


	
	// Projection matrix.
	
	this.Projection;


	
	// View matrix.
	
	this.View;
}



// Prototypal Inheritance.

SkyboxShader.prototype = new BaseShader();
SkyboxShader.prototype.constructor = SkyboxShader;



// Implementation.

SkyboxShader.prototype.Init = function ()
{
	BaseShader.prototype.Init.call(this);

	// Get shader variables
	this.mProjectionId = this.getVariable("ProjectionMatrix");
	this.mViewId = this.getVariable("ViewMatrix");
	this.mModelId = this.getVariable("ModelMatrix");
	this.mModelScaleId = this.getVariable("ModelScale");
	
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

SkyboxShader.prototype.Enable = function ()
{
	BaseShader.prototype.Enable.call(this);
	
	for (var i = 0; i < this.mSampleId.length; ++i)
	{
		if ( i < this.mSampleId.length )
			this.setVariableInt(this.mSampleId[i], i);
	}
}



// Implementation.

SkyboxShader.prototype.Draw = function (entity, vbo, numPoints, numIndices)
{
	// Set matrices
	this.setMatrix(this.mProjectionId, this.Projection.MMatrix, 4);
	this.setMatrix(this.mViewId, this.View.MMatrix, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.MMatrix, 4);
	
	var scale = entity.objectMatrix.GetScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);
	
	
	// Set texture samples
	var material = entity.objectMaterial;
	if ( (material.Texture != null) && (material.Texture.length != null) )
	{
		for (var i = 0; (i < material.Texture.length) && (i < this.mSampleId.length); ++i)
		{
			gl.activeTexture(gl.TEXTURE0 + i);
			material.Texture[i].Bind();
		}
	}
	
	
	// Draw
	BaseShader.prototype.Draw.call(this, entity.objectEntity, numPoints, numIndices);
}