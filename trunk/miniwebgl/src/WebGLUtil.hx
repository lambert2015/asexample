package;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.html.webgl.Shader;

/**
 * ...
 * @author andy
 */
class WebGLUtil 
{
	public static function createShader(gl:RenderingContext,shaderSource:String, type:Int):Shader
	{
		var shader:Shader = gl.createShader(type);
		gl.shaderSource(shader, shaderSource);
		gl.compileShader(shader);

		//if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS))
		//{
			//throw gl.getShaderInfoLog(shader);
		//}
		return shader;
	}
	
	public static function createProgram(gl:RenderingContext,vertexSource:String, fragSource:String):Program
	{
		var program:Program = gl.createProgram();
		var vshader:Shader = createShader(gl, vertexSource, GL.VERTEX_SHADER);
		var fshader:Shader = createShader(gl, fragSource, GL.FRAGMENT_SHADER);
		gl.attachShader(program, vshader);
		gl.attachShader(program, fshader);
		gl.linkProgram(program);
		//if (!gl.getProgramParameter(program, GL.LINK_STATUS))
		//{
			//throw gl.getProgramInfoLog(program);
		//}
		return program;
	}
	
}