// Shader for blending the DOF blur with the rendered scene. It uses the same
// fragment properties as the DofBlur shader in order to reproduce the blur
// calculations and determine how much to blend the blurred texture into the
// rendered scene texture.
function DofImageShader() {
	// Setup inherited members.
	DofBlurShader.call(this);
}

// Prototypal Inheritance.
DofImageShader.prototype = new DofBlurShader();
DofImageShader.prototype.constructor = DofImageShader;
