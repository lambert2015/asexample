package org.angle3d.shader.basic;
import flash.display3D.Context3D;
import org.angle3d.shader.Shader;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.UniformBinding;

/**
 * 法线颜色
 */
class NormalColorShader extends Shader
{
	public function new() 
	{
		super("NormalColorShader");
		
		var sources:Array<String> =[
		                  "attribute vec3 a_position\n" +
						  "attribute vec3 a_normal\n" +
						  "varying vec4 v_normal\n" +
						  "uniform mat4 u_WorldViewProjectionMatrix\n" +
						  "##main\n" +
						  "op = m44(a_position,u_WorldViewProjectionMatrix)\n" +
						  "v_normal = a_normal\n",
						  
						  "uniform vec4 u_scale\n" +
						  "temp vec4 t_normal\n" +
						  "temp vec4 t_color\n" +
						  "##main\n" +
						  "t_normal = mul(v_normal,u_scale)\n" +
						  "t_normal = add(t_normal,u_scale)\n" +
						  "t_color.xyz = t_normal.xyz\n" +
						  "t_color.w = 1.0\n" +
						  "oc = t_color\n"];
		setSource(sources);
	}
	
	override private function setUniformBinding():Void
	{
		bindUniform(ShaderType.VERTEX, "u_WorldViewProjectionMatrix",UniformBinding.WorldViewProjectionMatrix);
	}
}