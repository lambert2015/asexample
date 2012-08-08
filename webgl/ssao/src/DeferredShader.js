
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




// The deferred shader outputs geometry data to a texture, which can later be used
// in a post-processing shader to perform some sort of computation on the data. The
// texture storing the geometry data should be of a floating point type.




// Constructor.

function DeferredShader ()
{
	
	// Setup inherited members.
	
	BaseShader.call(this);
	
	
	
	// Shader variables.
	
	this.mProjectionId;
	this.mViewId;
	this.mModelId;
	this.mModelScaleId;
	this.mLinearDepthId;


	
	// Projection matrix.
	
	this.Projection;


	
	// View matrix.
	
	this.View;
	
	
	
	// Gets or sets the (Far - Near) clip value used for calculating linear depth.
	// This applies only to storing positional data. RGBA = XYZD (depth).
	
	this.LinearDepth = 0.0;
}



// Prototypal Inheritance.

DeferredShader.prototype = new BaseShader();
DeferredShader.prototype.constructor = DeferredShader;



// Implementation.

DeferredShader.prototype.Init = function ()
{
	BaseShader.prototype.Init.call(this);
	
	// Get matrices
	this.mProjectionId = this.GetVariable("ProjectionMatrix");
	this.mViewId = this.GetVariable("ViewMatrix");
	this.mModelId = this.GetVariable("ModelMatrix");
	this.mModelScaleId = this.GetVariable("ModelScale");
	
	// Get variables
	this.mLinearDepthId = this.GetVariable("LinearDepth");
}



// Implementation.

DeferredShader.prototype.Enable = function ()
{
	BaseShader.prototype.Enable.call(this);

	// Set variables
	this.SetVariable(this.mLinearDepthId, this.LinearDepth);
}



// Implementation.

DeferredShader.prototype.Draw = function (entity, numPoints, numIndices)
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