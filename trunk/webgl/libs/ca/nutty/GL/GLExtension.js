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
/// This class enables OpenGL extensions. See GLInfo for a list of available extensions.
/// </summary>


/// <summary>
/// Constructor.
/// <summary>
function GLExtension ()
{
	/// <summary>
	/// Stores the company responsible for this GL implementation. This name does not change
	/// from release to release.
	/// </summary>
	this.Vendor = gl.getParameter(gl.VENDOR);
}


/// <summary>
/// Generic method for enabling an extension.
/// </summary>
/// <param name="name">Name of the extension to enable.</param>
/// <returns>True if the extension was enabled successfully, otherwise false.</returns>
GLExtension.prototype.EnableExtension = function (name)
{
	return (gl.getExtension(name) != null);
}


/// <summary>
/// Utility method for enabling floating point texture use.
/// </summary>
/// <returns>True if the extension was enabled successfully, otherwise false.</returns>
GLExtension.prototype.EnableFloatTexture = function ()
{
	return this.EnableExtension("OES_texture_float");
}