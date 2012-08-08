
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
	
	this.Name = null;
	
	
	
	// Stores a reference to the shader object.
	
	this.Shader = null;
}



// Creates a new shader.

// <param name="type">Type of shader to create.</param>
// <param name="source">String containing the source code of the shader.</param>
// <returns>True if the shader compiled successfully, otherwise false.</param>
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



// Removes the shader.

GLShader.prototype.Release = function ()
{
	gl.deleteShader(this.Shader);
	this.Shader = null;
}



// Retrieves debugging information.

GLShader.prototype.GetLog = function ()
{
	return gl.getShaderInfoLog(this.Shader)
}