// <summary>
// This class is a container for storing common vertex buffer objects that may
// or may not be rendered in the vertex and fragment shaders. Implementations of
// this class should extend it to support additional parameters required by that
// specific shader.
// </summary>


// <summary>
// Constructor.
// </summary>
function BaseShader ()
{
	// <summary>
	// Setup inherited members.
	// </summary>
	GLShaderProgram.call(this);


	// <summary>
	// Reference to shader attributes.
	// </summary>
	this.mAttribVertex = -1;
	this.mAttribUv = -1;
	this.mAttribNormal = -1;
}


// <summary>
// Prototypal Inheritance.
// </summary>
BaseShader.prototype = new GLShaderProgram();
BaseShader.prototype.constructor = BaseShader;


// <summary>
// Initialize the shader. Only call once after all shaders have been added.
// </summary>
BaseShader.prototype.Init = function ()
{
	this.mAttribVertex = this.GetAttribute("Vertex");
	this.mAttribUv = this.GetAttribute("Uv");
	this.mAttribNormal = this.GetAttribute("Normal");
}


// <summary>
// Enable the shader.
// </summary>
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


// <summary>
// Disable the shader.
// </summary>
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


// <summary>
// Draw the object.
// </summary>
// <param name="vbo">VBO to draw.</param>
// <param name="numPoints">Number of points to override in VBO.</param>
// <param name="numIndices">Number of indices to override in VBO.</param>
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