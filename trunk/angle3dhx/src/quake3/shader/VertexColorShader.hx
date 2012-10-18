package quake3.shader;
import org.angle3d.material.shader.Shader;

//假设传入的VertexBuffer值顺序为[position,color]
class VertexColorShader extends Shader
{
	public function new() 
	{
		super("SingleColorShader");

		var sources:Array<String> = [
		                  "attribute vec3 a_position\n" +
						  "attribute vec3 a_normal\n" +
						  "attribute vec2 a_uv\n" +
						  "varying vec4 v_color\n" +
						  "uniform mat4 u_modelProjection\n" +
						  "uniform mat4 u_color\n" +
						  "##main\n" +
						  "op = m44(a_position,u_modelProjection)\n" +
						  "v_color = u_color\n",
						  
						  "##main\n" +
						  "oc = v_color\n"];
		setSource(sources);
	}
}