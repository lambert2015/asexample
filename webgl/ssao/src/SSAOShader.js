
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




// SSAO is a post-processing shader that computes the amount of ambient occlusion at each
// fragment. This shader requires 3 textures and outputs one luninance floating point texture.
//
// 1. Texture map containing the 3D view-space positions.
// 2. Texture map containing the 3D view-space normal vectors.
// 3. A normalmap to be used when randomizing the kernel filter to produce noisier, but uniform results.
//
// The resulting output from this shader can be blended with the original rendered scene.




// Constructor.

function SSAOShader ()
{
	
	// Setup inherited members.
	
	ImageShader.call(this);
	
	
	
	// Shader variables.
	
	this.mOccluderBiasId;
	this.mSamplingRadiusId
	this.mAttenuationId;


	
	// Attenuation amounts.
	// x = constant
	// y = linear
	// z = quadratic (not used)
	
	this.Attenuation = new Point(1.0, 0.0, 0.0);
	
	
	
	// Occluder bias to minimize self-occlusion.
	
	this.OccluderBias = 0.05;
	
	
	
	// Specifies the size of the sampling radius.
	
	this.SamplingRadius = 20.0;
	
	
	// View matrices not used
	this.Projection = new Matrix(4, 4);
	this.View = new Matrix(4, 4);
}



// Prototypal Inheritance.

SSAOShader.prototype = new ImageShader();
SSAOShader.prototype.constructor = SSAOShader;



// Implementation.

SSAOShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);
	
	// Get variables
	this.mOccluderBiasId = this.GetVariable("OccluderBias");
	this.mSamplingRadiusId = this.GetVariable("SamplingRadius");
	this.mAttenuationId = this.GetVariable("Attenuation");
}



// Implementation.

SSAOShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);

	// Set shader variables
	this.SetVariable(this.mOccluderBiasId, this.OccluderBias);
	this.SetVariable(this.mSamplingRadiusId, this.SamplingRadius);
	this.SetVariable(this.mAttenuationId, this.Attenuation.x, this.Attenuation.y);
}