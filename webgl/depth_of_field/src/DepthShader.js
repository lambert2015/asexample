
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




// Depth shader renders the depth values to an RGB texture.




// Constructor.

function DepthShader ()
{
	
	// Setup inherited members.
	
	BaseShader.call(this);
	
	
	
	// Shader variables.
	
	this.mProjectionId;
	this.mViewId;
	this.mModelId;
	this.mModelScaleId;
	this.mFilterTypeId;
	this.mNearId;
	this.mFarId;


	
	// Projection matrix.
	
	this.Projection;


	
	// View matrix.
	
	this.View;
	
	
	
	// Gets or sets the near and far clipping planes, which determine
	// how to compute the linear depth values.
	
	this.Near = 0.0;
	this.Far = 0.0;
}



// Prototypal Inheritance.

DepthShader.prototype = new BaseShader();
DepthShader.prototype.constructor = DepthShader;



// Implementation.

DepthShader.prototype.Init = function ()
{
	BaseShader.prototype.Init.call(this);
	
	// Get matrices
	this.mProjectionId = this.getVariable("ProjectionMatrix");
	this.mViewId = this.getVariable("ViewMatrix");
	this.mModelId = this.getVariable("ModelMatrix");
	this.mModelScaleId = this.getVariable("ModelScale");
	
	// Get variables
	this.mNearId = this.getVariable("Near");
	this.mFarId = this.getVariable("Far");
}



// Implementation.

DepthShader.prototype.Enable = function ()
{
	BaseShader.prototype.Enable.call(this);
	
	// Set variables
	this.setVariable(this.mNearId, this.Near);
	this.setVariable(this.mFarId, this.Far);
}



// Implementation.

DepthShader.prototype.Draw = function (entity, numPoints, numIndices)
{
	// Matrices
	this.setMatrix(this.mProjectionId, this.Projection.MMatrix, 4);
	this.setMatrix(this.mViewId, this.View.MMatrix, 4);
	this.setMatrix(this.mModelId, entity.objectMatrix.MMatrix, 4);
	
	var scale = entity.objectMatrix.GetScale();
	this.setVariable(this.mModelScaleId, scale.x, scale.y, scale.z);


	// Draw
	BaseShader.prototype.Draw.call(this, entity.objectEntity, numPoints, numIndices);
}