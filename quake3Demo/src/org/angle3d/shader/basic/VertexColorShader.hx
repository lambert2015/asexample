package org.angle3d.shader.basic;
import flash.display3D.Context3D;
import org.angle3d.shader.Shader;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.UniformBinding;

/**
 * 顶点颜色
 */
class VertexColorShader extends Shader
{
	public function new() 
	{
		super();
		
		var sources:Array<String> =[
		                  "attribute vec3 a_position\n" +
						  "attribute vec3 a_color\n" +
						  "varying vec4 v_color\n" +
						  "uniform mat4 u_WorldViewProjectionMatrix\n" +
						  "##main\n" +
						  "op = m44(a_position,u_WorldViewProjectionMatrix)\n" +
						  "v_color = a_color",
						  
						  "##main\n" +
						  "oc = v_color"];
		setSource(sources[0],sources[1]);
	}
	
	override private function setUniformBinding():Void
	{
		bindUniform(ShaderType.VERTEX, "u_WorldViewProjectionMatrix",UniformBinding.WorldViewProjectionMatrix);
	}
}