
// GLShader is a high level class to create and remove vertex and
// fragment shaders.




// Constructor.

function GLShader ()
{
	this.ShaderType =
	{
		"Vertex" : 0,
		"Fragment" : 1
	};
	
	
	
	// Name to identify this shader.
	
	this.name = null;
	
	
	
	// Stores a reference to the shader object.
	
	this.shader = null;
}



// Creates a new shader.

// <param name="type">Type of shader to create.</param>
// <param name="source">String containing the source code of the shader.</param>
// <returns>True if the shader compiled successfully, otherwise false.</param>
GLShader.prototype.create = function (type, source)
{
	this.release();

	if ( type == this.ShaderType.Vertex )
		this.shader = gl.createShader(gl.VERTEX_SHADER);
	else
		this.shader = gl.createShader(gl.FRAGMENT_SHADER);
		
	if ( this.shader != null )
	{
		gl.shaderSource(this.shader, source);
		gl.compileShader(this.shader);
		
		return gl.getShaderParameter(this.shader, gl.COMPILE_STATUS);
	}
	
	return false;
}



// Removes the shader.

GLShader.prototype.release = function ()
{
	gl.deleteShader(this.shader);
	this.shader = null;
}



// Retrieves debugging information.

GLShader.prototype.getLog = function ()
{
	return gl.getShaderInfoLog(this.shader)
}