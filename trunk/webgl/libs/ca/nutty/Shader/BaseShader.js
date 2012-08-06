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
/// This class is a container for storing common vertex buffer objects that may
/// or may not be rendered in the vertex and fragment shaders. Implementations of
/// this class should extend it to support additional parameters required by that
/// specific shader.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function BaseShader ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	GLShaderProgram.call(this);


	/// <summary>
	/// Reference to shader attributes.
	/// </summary>
	this.mAttribVertex = -1;
	this.mAttribUv = -1;
	this.mAttribNormal = -1;
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
BaseShader.prototype = new GLShaderProgram();
BaseShader.prototype.constructor = BaseShader;


/// <summary>
/// Initialize the shader. Only call once after all shaders have been added.
/// </summary>
BaseShader.prototype.Init = function ()
{
	this.mAttribVertex = this.GetAttribute("Vertex");
	this.mAttribUv = this.GetAttribute("Uv");
	this.mAttribNormal = this.GetAttribute("Normal");
}


/// <summary>
/// Enable the shader.
/// </summary>
BaseShader.prototype.Enable = function ()
{
	this.Load();

	if ( this.mAttribVertex != -1 )
		gl.enableVertexAttribArray(this.mAttribVertex);

	if ( this.mAttribUv != -1 )
		gl.enableVertexAttribArray(this.mAttribUv);

	if ( this.mAttribNormal != -1 )
		gl.enableVertexAttribArray(this.mAttribNormal);
}


/// <summary>
/// Disable the shader.
/// </summary>
BaseShader.prototype.Disable = function ()
{
	// Disable states
	if ( this.mAttribVertex != -1 )
		gl.disableVertexAttribArray(this.mAttribVertex);

	if ( this.mAttribUv != -1 )
		gl.disableVertexAttribArray(this.mAttribUv);

	if ( this.mAttribNormal != -1 )
		gl.disableVertexAttribArray(this.mAttribNormal);
}


/// <summary>
/// Draw the object.
/// </summary>
/// <param name="vbo">VBO to draw.</param>
/// <param name="numPoints">Number of points to override in VBO.</param>
/// <param name="numIndices">Number of indices to override in VBO.</param>
BaseShader.prototype.Draw = function (vbo, numPoints, numIndices)
{
	if ( this.mAttribVertex != -1 )
	{
		gl.bindBuffer(gl.ARRAY_BUFFER, vbo.VertexBuffer);
		gl.vertexAttribPointer(this.mAttribVertex, 3, gl.FLOAT, false, 0, 0);
	}

	if ( this.mAttribUv != -1 )
	{
		gl.bindBuffer(gl.ARRAY_BUFFER, vbo.UvBuffer);
		gl.vertexAttribPointer(this.mAttribUv, 2, gl.FLOAT, false, 0, 0);
	}

	if ( this.mAttribNormal != -1 )
	{
		gl.bindBuffer(gl.ARRAY_BUFFER, vbo.NormalBuffer);
		gl.vertexAttribPointer(this.mAttribNormal, 3, gl.FLOAT, false, 0, 0);
	}

	// Draw
	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, vbo.IndexBuffer);
	gl.drawElements(gl.TRIANGLES, (numIndices != null) ? numIndices : vbo.Mesh.GetNumIndices(), gl.UNSIGNED_SHORT, 0);
}