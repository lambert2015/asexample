
// This class enables OpenGL extensions. See GLInfo for a list of available extensions.




// Constructor.

function GLExtension ()
{
	
	// Stores the company responsible for this GL implementation. This name does not change
	// from release to release.
	
	this.vendor = gl.getParameter(gl.VENDOR);
}



// Generic method for enabling an extension.

// <param name="name">Name of the extension to enable.</param>
// <returns>True if the extension was enabled successfully, otherwise false.</returns>
GLExtension.prototype.enableExtension = function (name)
{
	return (gl.getExtension(name) != null);
}



// Utility method for enabling floating point texture use.

// <returns>True if the extension was enabled successfully, otherwise false.</returns>
GLExtension.prototype.enableFloatTexture = function ()
{
	return this.EnableExtension("OES_texture_float");
}