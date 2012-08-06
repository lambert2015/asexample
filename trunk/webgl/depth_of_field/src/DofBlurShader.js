/// <summary>
/// Nutty Software Open WebGL Framework
/// 
/// Copyright (C) 2012 Nathaniel Meyer
/// Nutty Software, http://www.nutty.ca
/// All Rights Reserved.
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy of
/// this software and associated documentation files (the "Software"), to deal in
/// the Software without restriction, including without limitation the rights to
/// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
/// of the Software, and to permit persons to whom the Software is furnished to do
/// so, subject to the following conditions:
///     1. The above copyright notice and this permission notice shall be included in all
///        copies or substantial portions of the Software.
///     2. Redistributions in binary or minimized form must reproduce the above copyright
///        notice and this list of conditions in the documentation and/or other materials
///        provided with the distribution.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
/// </summary>


/// <summary>
/// The blur shader performs a box-blur on the target texture (aka: separable box filter).
/// It requires two passes. The first pass blurs the target along the horizontal axis. The
/// second pass blurs the target along the vertical axis.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function DofBlurShader ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	ImageShader.call(this);
	
	
	/// <summary>
	/// Shader variables.
	/// </summary>
	this.mOrientationId;
	this.mBlurAmountId;
	this.mBlurCoefficientId;
	this.mFocusDistanceId;
	this.mNearId;
	this.mFarId;
	this.mPPMId;
	
	
	/// <summary>
	/// Gets or sets the coefficient used during the blur process.
	/// This property helps to reduce the GPU cycles in order to calculate
	/// the blur diameter.
	///
	/// It is equal to (f * ms) / N.
	/// Where:
	/// f = focal length
	/// ms = magnitude of subject in focus
	/// N is the fstop
	/// </summary>
	this.BlurCoefficient = 0;
	
	
	/// <summary>
	/// Gets or sets camera properties used in the bluring process.
	/// </summary>
	this.FocalLength = 0.0;
	this.FocusDistance = 0.0;
	this.FStop = 0.0;
	
	
	/// <summary>
	/// Gets or sets the near and far clipping planes.
	/// </summary>
	this.Near = 0.0;
	this.Far = 0.0;
	
	
	/// <summary>
	/// Gets or sets the pixels per millimetre. This is used to determine how many pixels to blur
	/// from the result returned in the DOF blur equation.
	/// </summary>
	this.mPPM = 0;
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
DofBlurShader.prototype = new ImageShader();
DofBlurShader.prototype.constructor = DofBlurShader;


/// <summary>
/// Implementation.
/// </summary>
DofBlurShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);
	
	// Get variables
	this.mOrientationId = this.GetVariable("Orientation");
	this.mBlurCoefficientId = this.GetVariable("BlurCoefficient");
	this.mFocusDistanceId = this.GetVariable("FocusDistance");
	this.mNearId = this.GetVariable("Near");
	this.mFarId = this.GetVariable("Far");
	this.mPPMId = this.GetVariable("PPM");
}


/// <summary>
/// Sets the size of the image.
/// </summary>
DofBlurShader.prototype.SetSize = function (width, height)
{
	// Call base method
	ImageShader.prototype.SetSize.call(this, width, height);
	
	// Set PPM (assume 35mm camera sensor)
	this.mPPM = Math.sqrt((width * width) + (height * height)) / 35.0;
}


/// <summary>
/// Implementation.
/// </summary>
DofBlurShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);
	
	// Set variables
	this.SetVariable(this.mBlurCoefficientId, this.BlurCoefficient);
	this.SetVariable(this.mFocusDistanceId, this.FocusDistance);
	this.SetVariable(this.mNearId, this.Near);
	this.SetVariable(this.mFarId, this.Far);
	this.SetVariable(this.mPPMId, this.mPPM);
}


/// <summary>
/// Implementation.
/// </summary>
DofBlurShader.prototype.Draw = function (entity, orientation, numPoints, numIndices)
{
	// Blur on the horizontal axis
	this.SetVariableInt(this.mOrientationId, orientation);
	ImageShader.prototype.Draw.call(this, entity, numPoints, numIndices);
}


/// <summary>
/// Calculates the blur coefficient with the specified camera properties.
/// Calculating this here saves some GPU cycles.
/// </summary>
DofBlurShader.prototype.UpdateBlurCoefficient = function ()
{
	var ms = this.FocalLength / ((this.FocusDistance * 1000.0) - this.FocalLength);
	this.BlurCoefficient = (this.FocalLength * ms) / this.FStop;
}