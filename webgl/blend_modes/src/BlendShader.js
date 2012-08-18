// This shader renders geometry to the alpha channel, which will be used by the
// refraction shader
// to process tagged pixels. The fragment shader will tag pixels by setting their
// alpha value to 0.
function BlendShader() {
	// Setup inherited members.
	ImageShader.call(this);

	// Shader variables.
	this.mSrcColourId = null;
	this.mDstColourId = null;

	// Matrices not used
	this.projection = new Matrix(4, 4);
	this.view = new Matrix(4, 4);
}

// Prototypal Inheritance.
BlendShader.prototype = new ImageShader();
BlendShader.prototype.constructor = BlendShader;

// Colour (tint) applied to the destination texture.
// Variable is static so that the colour applies to all blend modes.
BlendShader.dstColour = new Point(1, 1, 1, 1);

// Colour (tint) applied to the source texture.
// Variable is static so that the colour applies to all blend modes.

BlendShader.srcColour = new Point(1, 1, 1, 1);

// Implementation.
BlendShader.prototype.init = function() {
	ImageShader.prototype.init.call(this);

	// Get shader variables
	this.mSrcColourId = this.getVariable("u_srcColour");
	this.mDstColourId = this.getVariable("u_dstColour");
}
// Implementation.
BlendShader.prototype.enable = function() {
	ImageShader.prototype.enable.call(this);

	// Set colours
	this.setVariable(this.mDstColourId, BlendShader.dstColour.x, BlendShader.dstColour.y, BlendShader.dstColour.z, BlendShader.dstColour.w);
	this.setVariable(this.mSrcColourId, BlendShader.srcColour.x, BlendShader.srcColour.y, BlendShader.srcColour.z, BlendShader.srcColour.w);
}