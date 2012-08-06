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
// This post-process shader refracts pixels that have their alpha channel set to 0. To animate
// the refraction, increase the RandomNumber value by some amount.
// </summary>


// <summary>
// Constructor.
// </summary>
function RefractionShader ()
{
	// <summary>
	// Setup inherited members.
	// </summary>
	ImageShader.call(this);
	
	
	// <summary>
	// Shader variables.
	// </summary>
	this.mAmplitudeId;
	this.mFrequencyId;
	this.mPeriodId;
	this.mRandomNumberId;
		
	
	// <summary>
	// Gets or sets the size of refraction.
	// </summary>
	this.Amplitude = 1.0;
	
	
	// <summary>
	// Gets or sets the frequency of the refraction. Larger numbers produce
	// more grain.
	// </summary>
	this.Frequency = 256.0;
	
	
	// <summary>
	// Gets or sets the relative speed (period).
	// </summary>
	this.Period = 4.0;
	
	
	// <summary>
	// Gets or sets the random number to supply into the shader. This can
	// be used to animate the noise.
	// </summary>
	this.RandomNumber = 0.0;
	
	
	// View matrices not used
	this.Projection = new Matrix(4, 4);
	this.View = new Matrix(4, 4);
}


// <summary>
// Prototypal Inheritance.
// </summary>
RefractionShader.prototype = new ImageShader();
RefractionShader.prototype.constructor = RefractionShader;


// <summary>
// Implementation.
// </summary>
RefractionShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);

	// Get variables
	this.mAmplitudeId = this.GetVariable("Amplitude");
	this.mFrequencyId = this.GetVariable("Frequency");
	this.mPeriodId = this.GetVariable("Period");
	this.mRandomNumberId = this.GetVariable("RandomNumber");
}


// <summary>
// Implementation.
// </summary>
RefractionShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);
	
	// Set values
	this.SetVariable(this.mAmplitudeId, this.Amplitude);
	this.SetVariable(this.mFrequencyId, this.Frequency);
	this.SetVariable(this.mPeriodId, this.Period);
	this.SetVariable(this.mRandomNumberId, this.RandomNumber);
}


// <summary>
// Implementation.
// </summary>
//RefractionShader.prototype.Draw = function (entity, numPoints, numIndices)
//{
	// Forward
//	ImageShader.prototype.Draw.call(this, entity, numPoints, numIndices);
//}