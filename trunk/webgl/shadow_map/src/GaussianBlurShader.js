
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




// Gaussian blur shader performs a box-blur on the target texture (aka: seperable box filter).
// It requires two passes. The first pass blurs the target along the horizontal axis. The
// second pass blurs the target along the vertical axis.




// Constructor.

function GaussianBlurShader ()
{
	
	// Setup inherited members.
	
	ImageShader.call(this);
	
	
	
	// Shader variables.
	
	this.mOrientationId;
	this.mBlurAmountId;
	this.mCubeFaceId;
	
	
	
	// Gets or sets the amount of bluring.
	
	this.BlurAmount = 0;
	
	
	
	// Gets or sets the face of the cube being blurred.
	
	this.CubeFace = 0;
}



// Prototypal Inheritance.

GaussianBlurShader.prototype = new ImageShader();
GaussianBlurShader.prototype.constructor = GaussianBlurShader;



// Implementation.

GaussianBlurShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);
	
	// Get variables
	this.mOrientationId = this.GetVariable("Orientation");
	this.mBlurAmountId = this.GetVariable("BlurAmount");
	this.mCubeFaceId = this.GetVariable("CubeFace");
}



// Implementation.

GaussianBlurShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);
	
	// Set variables
	this.SetVariableInt(this.mBlurAmountId, this.BlurAmount);
}



// Implementation.

GaussianBlurShader.prototype.Draw = function (entity, orientation, numPoints, numIndices)
{
	// Blur on the horizontal axis
	this.SetVariableInt(this.mOrientationId, orientation);
	this.SetVariableInt(this.mCubeFaceId, this.CubeFace);
	ImageShader.prototype.Draw.call(this, entity, numPoints, numIndices);
}