// This shader renders the depth map to the screen, letting you visualize how it
// looks.
function DepthRenderShader() {
	// Setup inherited members.
	ImageShader.call(this);

	// Shader variables.
	this.mFilterTypeId;
	this.mSampleCubeId;

	// Specifies the type of shadow map filtering to perform.
	// 0 = None
	// 1 = PCM
	// 2 = VSM
	// 3 = ESM
	this.filterType = 0;
}

// Prototypal Inheritance.
DepthRenderShader.prototype = new ImageShader();
DepthRenderShader.prototype.constructor = DepthRenderShader;

// Implementation.
DepthRenderShader.prototype.init = function() {
	ImageShader.prototype.init.call(this);

	// Get variables
	this.mFilterTypeId = this.getVariable("u_filterType");
}
// Implementation.
DepthRenderShader.prototype.enable = function() {
	ImageShader.prototype.enable.call(this);

	// Set variables
	this.setVariableInt(this.mFilterTypeId, this.filterType);
}