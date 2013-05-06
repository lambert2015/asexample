package quake3.shader;

//假设传入的VertexBuffer值顺序为[position,color]
class SingleColorShader extends Shader
{
	public function new() 
	{
		super();

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
		setSource(sources[0],sources[1]);
	}
}