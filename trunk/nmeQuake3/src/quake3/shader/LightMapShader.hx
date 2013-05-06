package quake3.shader;

class LightMapShader extends Shader
{
	public function new() 
	{
		super();

		var sources:Array<String> = [
		                  "attribute vec3 a_position\n" +
						  "attribute vec2 a_texCoord\n" +
						  "attribute vec2 a_lightCoord\n" +
						  "attribute vec3 a_normal\n" +
						  "attribute vec4 a_color\n" +
						  
						  "varying vec4 v_texCoord\n" +
						  "varying vec4 v_lightCoord\n" +
						  "varying vec4 v_color\n" +
						  "varying vec4 v_normal\n" +
						  
						  "uniform mat4 u_modelProjection\n" +
						  
						  "temp vec4 t_position\n" +
						  
						  "##main\n" +
						  "t_position = m44(a_position,u_modelProjection)\n" +
						  "op = t_position\n" +
						  "v_texCoord = a_texCoord\n" +
						  "v_lightCoord = a_lightCoord\n" +
						  "v_color = a_color\n" +
						  "v_normal = a_normal",
						  
						  "temp vec4 t_diffuseColor\n" +
						  "temp vec4 t_lightColor\n" +
						  "temp vec4 t_rgbColor\n" +
						  "texture s_texture\n" +
						  "texture s_lightmap\n" +
						  "##main\n" +
						  "t_diffuseColor = texture(v_texCoord,s_texture<linear,nomip,wrap,2d>)\n" +
						  "t_lightColor = texture(v_lightCoord,s_lightmap<linear,nomip,wrap,2d>)\n" +
						  "t_rgbColor = multiply(t_diffuseColor,t_lightColor)\n" +
						  "oc = t_rgbColor"];
		setSource(sources[0],sources[1]);
	}
}