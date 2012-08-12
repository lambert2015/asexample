// This class represents a single GL shader program. A program consists
// of exactly one vertex shader and one fragment shader. This class should
// be inherited by specific shader programs that will use the methods of
// this class to supply attributes and variables to the shaders.
function GLShaderProgram ()
{
	// Name to identify this shader.
	this.name = null;
	
	// Stores a reference to the shader program.
	this.program = null;
}

// Creates a new program. Programs contains one or many shaders.
// <returns>ID of the created shader program.</returns>
GLShaderProgram.prototype.create = function ()
{
	this.release();

	this.program = gl.createProgram();
}

// Loads the program onto the video card.
GLShaderProgram.prototype.load = function ()
{
	gl.useProgram(this.program);
}

// Removes the speicifed program.
// <param name="programID">ID of the program to remove.</param>
GLShaderProgram.prototype.release = function ()
{
	gl.deleteProgram(this.program);
	this.program = null;
}

// Adds the specified a shader to the program.
// <param name="shader">Shader to attach to the program.</param>
GLShaderProgram.prototype.addShader = function (shader)
{
	// Attach the shader
	gl.attachShader(this.program, shader.shader);
}

// Removes the speicifed shader from the specified program.
// <param name="shader">Shader to remove.</param>
GLShaderProgram.prototype.removeShader = function (shader)
{
	gl.detachShader(this.program, shader.shader);
}

// Once all shaders have been added, link the program.
// <returns>True if the shaders linked to the program sucessfully, otherwise false.</returns>
GLShaderProgram.prototype.link = function ()
{
	gl.linkProgram(this.program);
	return gl.getProgramParameter(this.program, gl.LINK_STATUS);
}

// Finds and returns the index of the attribute.
// <param name="name">Name of the variable to be retrieve.</param>
GLShaderProgram.prototype.getAttribute = function (name)
{
	// Create the variable
	return gl.getAttribLocation(this.program, name);
}

// Finds and returns the index of the variable.
// <param name="name">Name of the variable to be retrieve.</param>
GLShaderProgram.prototype.getVariable = function (name)
{
	// Create the variable
	return gl.getUniformLocation(this.program, name);
}

// Assigns a uniform variable to the program.
// <param name="name">Name of the variable referenced in the shader program.</param>
// <param name="data">Data to set.</param>
// <param name="size">Size of the data. Valid range is between 1 - 4.</param>
GLShaderProgram.prototype.setVariableIntByName = function (name, x, y, z, w)
{
	// Create the variable
	this.setVariableInt(gl.getUniformLocation(this.program, name), x, y, z, w);
}

GLShaderProgram.prototype.setVariableInt = function (variable, x, y, z, w)
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

// Assigns a uniform variable to the program.
// <param name="name">Name of the variable referenced in the shader program.</param>
// <param name="data">Data to set.</param>
// <param name="size">Size of the data. Valid range is between 1 - 4.</param>
GLShaderProgram.prototype.setVariableByName = function (name, x, y, z, w)
{
	// Create the variable
	this.setVariable(gl.getUniformLocation(this.program, name), x, y, z, w);
}

//GLShaderProgram.prototype.setVariable = function (variable, data, size)
GLShaderProgram.prototype.setVariable = function (variable, x, y, z, w)
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

GLShaderProgram.prototype.setVariableVec2 = function (variable, vec2)
{
	// Assign the variable
	gl.uniform2f(variable, vec2.x, vec2.y);
}

GLShaderProgram.prototype.setVariableVec3 = function (variable, vec3)
{
	// Assign the variable
	gl.uniform3f(variable, vec3.x, vec3.y, vec3.z);
}

GLShaderProgram.prototype.setVariableVec4 = function (variable, vec4)
{
	// Assign the variable
	gl.uniform4f(variable, vec4.x, vec4.y, vec4.z, vec4.w);
}

// Assigns a uniform matrix to the program.
// <param name="name">Name of the matrix referenced in the shader program.</param>
// <param name="matrix">Matrix data.</param>
// <param name="size">Size of the matrix. Valid range is between 2 - 4 (2x2 - 4x4).</param>
GLShaderProgram.prototype.setMatrixByName = function (name, matrix, size)
{
	// Create the variable
	this.setMatrix(gl.getUniformLocation(this.program, name), matrix, size);
}

GLShaderProgram.prototype.setMatrix = function (variable, matrix, size)
{
	// Assign the variable
	if ( size == 2 )
		gl.uniformMatrix2fv(variable, false, matrix);
	else if ( size == 3 )
		gl.uniformMatrix3fv(variable, false, matrix);
	else if ( size > 3 )
		gl.uniformMatrix4fv(variable, false, matrix);
}

// Retrieves debugging information.
GLShaderProgram.prototype.getLog = function ()
{
	return gl.getProgramInfoLog(this.program);
}