package org.angle3d.shader.basic;
import flash.display3D.Context3D;
import org.angle3d.shader.Shader;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.UniformBinding;

/**
 * 简单贴图
 */
class SimpleTextureShader extends Shader
{
	public function new() 
	{
		super();
		
		var sources:Array<String> =[
		                  "attribute vec3 a_position\n" +
						  "attribute vec2 a_texCoord\n" +
						  "varying vec2 v_texCoord\n" +
						  "uniform mat4 u_WorldViewProjectionMatrix\n" +
						  "##main\n" +
						  "op = m44(a_position,u_WorldViewProjectionMatrix)\n" +
						  "v_texCoord = a_texCoord\n",
						  
						  "temp vec4 t_diffuseColor\n" +
						  "texture s_texture\n" +
						  "##main\n" +
						  "t_diffuseColor = tex(v_texCoord,s_texture<nearest,nomip,wrap,2d>)\n" +
						  "oc = t_diffuseColor\n"];
		setSource(sources[0],sources[1]);
	}
	
	override private function setUniformBinding():Void
	{
		bindUniform(ShaderType.VERTEX, "u_WorldViewProjectionMatrix",UniformBinding.WorldViewProjectionMatrix);
	}
}