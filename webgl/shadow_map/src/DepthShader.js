// <summary>
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
// </summary>


// <summary>
// Depth shader renders the depth values to an RGB texture.
// </summary>


// <summary>
// Constructor.
// </summary>
function DepthShader ()
{
	// <summary>
	// Setup inherited members.
	// </summary>
	BaseShader.call(this);
	
	
	// <summary>
	// Shader variables.
	// </summary>
	this.mProjectionId;
	this.mViewId;
	this.mModelId;
	this.mModelScaleId;
	this.mFilterTypeId;


	// <summary>
	// Projection matrix.
	// </summary>
	this.Projection;


	// <summary>
	// View matrix.
	// </summary>
	this.View;
	
	
	// <summary>
	// Specifies the type of shadow map filtering to perform.
	// 0 = None
	// 1 = PCM
	// 2 = VSM
	// 3 = ESM
	// </summary>
	this.FilterType = 0;
}


// <summary>
// Prototypal Inheritance.
// </summary>
DepthShader.prototype = new BaseShader();
DepthShader.prototype.constructor = DepthShader;


// <summary>
// Implementation.
// </summary>
DepthShader.prototype.Init = function ()
{
	BaseShader.prototype.Init.call(this);
	
	// Get matrices
	this.mProjectionId = this.GetVariable("ProjectionMatrix");
	this.mViewId = this.GetVariable("ViewMatrix");
	this.mModelId = this.GetVariable("ModelMatrix");
	this.mModelScaleId = this.GetVariable("ModelScale");
	
	// Get variables
	this.mFilterTypeId = this.GetVariable("FilterType");
}


// <summary>
// Implementation.
// </summary>
DepthShader.prototype.Enable = function ()
{
	BaseShader.prototype.Enable.call(this);
	
	// Set variables
	this.SetVariableInt(this.mFilterTypeId, this.FilterType);
}


// <summary>
// Implementation.
// </summary>
DepthShader.prototype.Draw = function (entity, numPoints, numIndices)
{
	// Matrices
	this.SetMatrix(this.mProjectionId, this.Projection.MMatrix, 4);
	this.SetMatrix(this.mViewId, this.View.MMatrix, 4);
	this.SetMatrix(this.mModelId, entity.ObjectMatrix.MMatrix, 4);
	
	var scale = entity.ObjectMatrix.GetScale();
	this.SetVariable(this.mModelScaleId, scale.x, scale.y, scale.z);


	// Draw
	BaseShader.prototype.Draw.call(this, entity.ObjectEntity, numPoints, numIndices);
}