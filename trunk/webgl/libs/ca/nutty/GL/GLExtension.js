// <summary>
// This class enables OpenGL extensions. See GLInfo for a list of available extensions.
// </summary>


// <summary>
// Constructor.
// <summary>
function GLExtension ()
{
	// <summary>
	// Stores the company responsible for this GL implementation. This name does not change
	// from release to release.
	// </summary>
	this.Vendor = gl.getParameter(gl.VENDOR);
}


// <summary>
// Generic method for enabling an extension.
// </summary>
// <param name="name">Name of the extension to enable.</param>
// <returns>True if the extension was enabled successfully, otherwise false.</returns>
GLExtension.prototype.EnableExtension = function (name)
{
	return (gl.getExtension(name) != null);
}


// <summary>
// Utility method for enabling floating point texture use.
// </summary>
// <returns>True if the extension was enabled successfully, otherwise false.</returns>
GLExtension.prototype.EnableFloatTexture = function ()
{
	return this.EnableExtension("OES_texture_float");
}