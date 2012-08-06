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
/// GLShader is a high level class to create and remove vertex and
/// fragment shaders.
/// </summary>


/// <summary>
/// Constructor.
/// <summary>
function GLShader ()
{
	this.ShaderType =
	{
		"Vertex" : 0,
		"Fragment" : 1
	};
	
	
	/// <summary>
	/// Name to identify this shader.
	/// </summary>
	this.Name = null;
	
	
	/// <summary>
	/// Stores a reference to the shader object.
	/// </summary>
	this.Shader = null;
}


/// <summary>
/// Creates a new shader.
/// </summary>
/// <param name="type">Type of shader to create.</param>
/// <param name="source">String containing the source code of the shader.</param>
/// <returns>True if the shader compiled successfully, otherwise false.</param>
GLShader.prototype.Create = function (type, source)
{
	this.Release();

	if ( type == this.ShaderType.Vertex )
		this.Shader = gl.createShader(gl.VERTEX_SHADER);
	else
		this.Shader = gl.createShader(gl.FRAGMENT_SHADER);
		
	if ( this.Shader != null )
	{
		gl.shaderSource(this.Shader, source);
		gl.compileShader(this.Shader);
		
		return gl.getShaderParameter(this.Shader, gl.COMPILE_STATUS);
	}
	
	return false;
}


/// <summary>
/// Removes the shader.
/// </summary>
GLShader.prototype.Release = function ()
{
	gl.deleteShader(this.Shader);
	this.Shader = null;
}


/// <summary>
/// Retrieves debugging information.
/// </summary>
GLShader.prototype.GetLog = function ()
{
	return gl.getShaderInfoLog(this.Shader)
}