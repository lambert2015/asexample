// <summary>
// This class represents a single GL shader program. A program consists
// of exactly one vertex shader and one fragment shader. This class should
// be inherited by specific shader programs that will use the methods of
// this class to supply attributes and variables to the shaders.
// </summary>


// <summary>
// Constructor.
// <summary>
function GLShaderProgram ()
{
	// <summary>
	// Name to identify this shader.
	// </summary>
	this.Name = null;
	
	
	// <summary>
	// Stores a reference to the shader program.
	// </summary>
	this.Program = null;
}


// <summary>
// Creates a new program. Programs contains one or many shaders.
// </summary>
// <returns>ID of the created shader program.</returns>
GLShaderProgram.prototype.Create = function ()
{
	this.Release();

	this.Program = gl.createProgram();
}


// <summary>
// Loads the program onto the video card.
// </summary>
GLShaderProgram.prototype.Load = function ()
{
	gl.useProgram(this.Program);
}


// <summary>
// Removes the speicifed program.
// </summary>
// <param name="programID">ID of the program to remove.</param>
GLShaderProgram.prototype.Release = function ()
{
	gl.deleteProgram(this.Program);
	this.Program = null;
}


// <summary>
// Adds the specified a shader to the program.
// </summary>
// <param name="shader">Shader to attach to the program.</param>
GLShaderProgram.prototype.AddShader = function (shader)
{
	// Attach the shader
	gl.attachShader(this.Program, shader.Shader);
}


// <summary>
// Removes the speicifed shader from the specified program.
// </summary>
// <param name="shader">Shader to remove.</param>
GLShaderProgram.prototype.RemoveShader = function (shader)
{
	gl.detachShader(this.Program, shader.Shader);
}


// <summary>
// Once all shaders have been added, link the program.
// </summary>
// <returns>True if the shaders linked to the program sucessfully, otherwise false.</returns>
GLShaderProgram.prototype.Link = function ()
{
	gl.linkProgram(this.Program);
	return gl.getProgramParameter(this.Program, gl.LINK_STATUS);
}


// <summary>
// Finds and returns the index of the attribute.
// </summary>
// <param name="name">Name of the variable to be retrieve.</param>
GLShaderProgram.prototype.GetAttribute = function (name)
{
	// Create the variable
	return gl.getAttribLocation(this.Program, name);
}


// <summary>
// Finds and returns the index of the variable.
// </summary>
// <param name="name">Name of the variable to be retrieve.</param>
GLShaderProgram.prototype.GetVariable = function (name)
{
	// Create the variable
	return gl.getUniformLocation(this.Program, name);
}


// <summary>
// Assigns a uniform variable to the program.
// </summary>
// <param name="name">Name of the variable referenced in the shader program.</param>
// <param name="data">Data to set.</param>
// <param name="size">Size of the data. Valid range is between 1 - 4.</param>
GLShaderProgram.prototype.SetVariableIntByName = function (name, x, y, z, w)
{
	// Create the variable
	this.SetVariableInt(gl.getUniformLocation(this.Program, name), x, y, z, w);
}

GLShaderProgram.prototype.SetVariableInt = function (variable, x, y, z, w)
{
	// Assign the variable
	if ( y == null )
		gl.uniform1i(variable, x);
	else if ( z == null )
		gl.uniform2i(variable, x, y);
	else if ( w == null )
		gl.uniform3i(variable, x, y, z);
	else
		gl.uniform4i(variable, x, y, z, w);
}


// <summary>
// Assigns a uniform variable to the program.
// </summary>
// <param name="name">Name of the variable referenced in the shader program.</param>
// <param name="data">Data to set.</param>
// <param name="size">Size of the data. Valid range is between 1 - 4.</param>
GLShaderProgram.prototype.SetVariableByName = function (name, x, y, z, w)
{
	// Create the variable
	this.SetVariable(gl.getUniformLocation(this.Program, name), x, y, z, w);
}

//GLShaderProgram.prototype.SetVariable = function (variable, data, size)
GLShaderProgram.prototype.SetVariable = function (variable, x, y, z, w)
{
	// Assign the variable
	if ( y == null )
		gl.uniform1f(variable, x);
	else if ( z == null )
		gl.uniform2f(variable, x, y);
	else if ( w == null )
		gl.uniform3f(variable, x, y, z);
	else
		gl.uniform4f(variable, x, y, z, w);
}


// <summary>
// Assigns a uniform matrix to the program.
// </summary>
// <param name="name">Name of the matrix referenced in the shader program.</param>
// <param name="matrix">Matrix data.</param>
// <param name="size">Size of the matrix. Valid range is between 2 - 4 (2x2 - 4x4).</param>
GLShaderProgram.prototype.SetMatrixByName = function (name, matrix, size)
{
	// Create the variable
	this.SetMatrix(gl.getUniformLocation(this.Program, name), matrix, size);
}

GLShaderProgram.prototype.SetMatrix = function (variable, matrix, size)
{
	// Assign the variable
	if ( size == 2 )
		gl.uniformMatrix2fv(variable, false, matrix);
	else if ( size == 3 )
		gl.uniformMatrix3fv(variable, false, matrix);
	else if ( size > 3 )
		gl.uniformMatrix4fv(variable, false, matrix);
}


// <summary>
// Retrieves debugging information.
// </summary>
GLShaderProgram.prototype.GetLog = function ()
{
	return gl.getProgramInfoLog(this.Program);
}