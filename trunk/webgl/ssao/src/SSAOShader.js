// SSAO is a post-processing shader that computes the amount of ambient occlusion at each
// fragment. This shader requires 3 textures and outputs one luninance floating point texture.
//
// 1. Texture map containing the 3D view-space positions.
// 2. Texture map containing the 3D view-space normal vectors.
// 3. A normalmap to be used when randomizing the kernel filter to produce noisier, but uniform results.
//
// The resulting output from this shader can be blended with the original rendered scene.

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
	this.attenuation = new Point(1.0, 0.0, 0.0);
	
	// Occluder bias to minimize self-occlusion.
	this.occluderBias = 0.05;
	
	// Specifies the size of the sampling radius.
	this.samplingRadius = 20.0;
	
	
	// View matrices not used
	this.projection = new Matrix(4, 4);
	this.view = new Matrix(4, 4);
}

// Prototypal Inheritance.
SSAOShader.prototype = new ImageShader();
SSAOShader.prototype.constructor = SSAOShader;

// Implementation.
SSAOShader.prototype.init = function ()
{
	ImageShader.prototype.init.call(this);
	
	// Get variables
	this.mOccluderBiasId = this.getVariable("u_occluderBias");
	this.mSamplingRadiusId = this.getVariable("u_samplingRadius");
	this.mAttenuationId = this.getVariable("u_attenuation");
}

// Implementation.
SSAOShader.prototype.enable = function ()
{
	ImageShader.prototype.enable.call(this);

	// Set shader variables
	this.setVariable(this.mOccluderBiasId, this.occluderBias);
	this.setVariable(this.mSamplingRadiusId, this.samplingRadius);
	this.setVariable(this.mAttenuationId, this.attenuation.x, this.attenuation.y);
}