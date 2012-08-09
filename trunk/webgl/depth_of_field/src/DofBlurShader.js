
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




// The blur shader performs a box-blur on the target texture (aka: separable box filter).
// It requires two passes. The first pass blurs the target along the horizontal axis. The
// second pass blurs the target along the vertical axis.




// Constructor.

function DofBlurShader ()
{
	
	// Setup inherited members.
	
	ImageShader.call(this);
	
	
	
	// Shader variables.
	
	this.mOrientationId;
	this.mBlurAmountId;
	this.mBlurCoefficientId;
	this.mFocusDistanceId;
	this.mNearId;
	this.mFarId;
	this.mPPMId;
	
	
	
	// Gets or sets the coefficient used during the blur process.
	// This property helps to reduce the GPU cycles in order to calculate
	// the blur diameter.
	//
	// It is equal to (f * ms) / N.
	// Where:
	// f = focal length
	// ms = magnitude of subject in focus
	// N is the fstop
	
	this.BlurCoefficient = 0;
	
	
	
	// Gets or sets camera properties used in the bluring process.
	
	this.FocalLength = 0.0;
	this.FocusDistance = 0.0;
	this.FStop = 0.0;
	
	
	
	// Gets or sets the near and far clipping planes.
	
	this.Near = 0.0;
	this.Far = 0.0;
	
	
	
	// Gets or sets the pixels per millimetre. This is used to determine how many pixels to blur
	// from the result returned in the DOF blur equation.
	
	this.mPPM = 0;
}



// Prototypal Inheritance.

DofBlurShader.prototype = new ImageShader();
DofBlurShader.prototype.constructor = DofBlurShader;



// Implementation.

DofBlurShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);
	
	// Get variables
	this.mOrientationId = this.getVariable("Orientation");
	this.mBlurCoefficientId = this.getVariable("BlurCoefficient");
	this.mFocusDistanceId = this.getVariable("FocusDistance");
	this.mNearId = this.getVariable("Near");
	this.mFarId = this.getVariable("Far");
	this.mPPMId = this.getVariable("PPM");
}



// Sets the size of the image.

DofBlurShader.prototype.SetSize = function (width, height)
{
	// Call base method
	ImageShader.prototype.SetSize.call(this, width, height);
	
	// Set PPM (assume 35mm camera sensor)
	this.mPPM = Math.sqrt((width * width) + (height * height)) / 35.0;
}



// Implementation.

DofBlurShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);
	
	// Set variables
	this.setVariable(this.mBlurCoefficientId, this.BlurCoefficient);
	this.setVariable(this.mFocusDistanceId, this.FocusDistance);
	this.setVariable(this.mNearId, this.Near);
	this.setVariable(this.mFarId, this.Far);
	this.setVariable(this.mPPMId, this.mPPM);
}



// Implementation.

DofBlurShader.prototype.Draw = function (entity, orientation, numPoints, numIndices)
{
	// Blur on the horizontal axis
	this.setVariableInt(this.mOrientationId, orientation);
	ImageShader.prototype.Draw.call(this, entity, numPoints, numIndices);
}



// Calculates the blur coefficient with the specified camera properties.
// Calculating this here saves some GPU cycles.

DofBlurShader.prototype.UpdateBlurCoefficient = function ()
{
	var ms = this.FocalLength / ((this.FocusDistance * 1000.0) - this.FocalLength);
	this.BlurCoefficient = (this.FocalLength * ms) / this.FStop;
}