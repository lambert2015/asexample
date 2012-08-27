package three.utils;

/**
 * ...
 * @author andy
 */
import UserAgentContext;

class WebGLUtil 
{
	public static function createShader(gl:WebGLRenderingContext,shaderSource:String, type:GLenum):WebGLShader
	{
		var shader:WebGLShader = gl.createShader(type);
		gl.shaderSource(shader, shaderSource);
		gl.compileShader(shader);

		if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
		{
			throw gl.getShaderInfoLog(shader);
		}
		return shader;
	}
	
	public static function createProgram(gl:WebGLRenderingContext,vertexSource:String, fragSource:String):WebGLProgram
	{
		var program:WebGLProgram = gl.createProgram();
		var vshader:WebGLShader = createShader(gl, vertexSource, gl.VERTEX_SHADER);
		var fshader:WebGLShader = createShader(gl, fragSource, gl.FRAGMENT_SHADER);
		gl.attachShader(program, vshader);
		gl.attachShader(program, fshader);
		gl.linkProgram(program);
		if (!gl.getProgramParameter(program, gl.LINK_STATUS))
		{
			throw gl.getProgramInfoLog(program);
		}
		return program;
	}
	
}