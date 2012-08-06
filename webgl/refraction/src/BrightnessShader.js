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
/// This post-process shader adjusts the brightness and contrast of a texture.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function BrightnessShader ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	ImageShader.call(this);
	
	
	/// <summary>
	/// Shader variables.
	/// </summary>
	this.mBrightnessId;
	this.mContrastId;
	this.mInvGammaId;
	
	
	/// <summary>
	/// Gets or sets the brightness value to use.
	/// Valid range: -1 to 1
	/// Default is neutral brightness (0.0).
	/// </summary>
	this.Brightness = 0.0;
	
	
	/// <summary>
	/// Gets or sets the contrast value to use.
	/// Valid range: -1 to 1
	/// Default is neural constrast (0.0).
	/// </summary>
	this.Contrast = 1.0;
	
	
	/// <summary>
	/// Specifies the inverse gamma value to use.
	/// </summary>
	this.InvGamma = 1.0 / 2.2;
	
	
	// View matrices not used
	this.Projection = new Matrix(4, 4);
	this.View = new Matrix(4, 4);
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
BrightnessShader.prototype = new ImageShader();
BrightnessShader.prototype.constructor = BrightnessShader;


/// <summary>
/// Implementation.
/// </summary>
BrightnessShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);

	// Get variables
	this.mBrightnessId = this.GetVariable("Brightness");
	this.mContrastId = this.GetVariable("Contrast");
	this.mInvGammaId = this.GetVariable("InvGamma");
}


/// <summary>
/// Implementation.
/// </summary>
BrightnessShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);
	
	// Set values
	this.SetVariable(this.mBrightnessId, this.Brightness);
	this.SetVariable(this.mContrastId, this.Contrast);
	this.SetVariable(this.mInvGammaId, this.InvGamma);
}


/// <summary>
/// Implementation.
/// </summary>
//BrightnessShader.prototype.Draw = function (entity, numPoints, numIndices)
//{
	// Forward
//	ImageShader.prototype.Draw.call(this, entity, numPoints, numIndices);
//}