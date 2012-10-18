package org.angle3d.shader.basic;
import flash.display3D.Context3D;
import org.angle3d.shader.Shader;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.UniformBinding;

/**
 * 顶点颜色
 */
class LightMapShader extends Shader
{
	public function new() 
	{
		super();
		
		var sources:Array<String> =
		                  ["attribute vec3 a_position\n" +
						  "attribute vec2 a_texCoord\n" +
						  "attribute vec2 a_texCoord2\n" +
						  "varying vec2 v_texCoord\n" +
						  "varying vec2 v_texCoord2\n" +
						  "uniform mat4 u_WorldViewProjectionMatrix\n" +
						  "##main\n" +
						  "op = m44(a_position,u_WorldViewProjectionMatrix)\n" +
						  "v_texCoord = a_texCoord\n" +
						  "v_texCoord2 = a_texCoord2\n",
						  
						  "temp vec4 t_diffuseColor\n" +
						  "temp vec4 t_lightColor\n" +
						  "texture s_texture\n" +
						  "texture s_lightmap\n" +
						  "##main\n" +
						  "t_diffuseColor = texture(v_texCoord,s_texture<linear,nomip,wrap,2d>)\n" +
						  "t_lightColor = tex(v_lightCoord,s_lightmap<linear,nomip,wrap,2d>)\n" +
						  "t_diffuseColor = multiply(t_diffuseColor,t_lightColor)\n" +
						  "oc = t_diffuseColor\n"];
		setSource(sources[0],sources[1]);
	}
	
	override private function setUniformBinding():Void
	{
		bindUniform(ShaderType.VERTEX, "u_WorldViewProjectionMatrix",UniformBinding.WorldViewProjectionMatrix);
	}
}