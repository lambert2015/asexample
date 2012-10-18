package org.angle3d.shader.basic;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.UniformBinding;
import org.angle3d.shader.Shader;

/**
 * 没有进行裁剪的WireframeShader
 * Wireframe Shader
 * @author andy
 */
class WireframeShader extends Shader
{

	public function new() 
	{
		super();
		
		var vertexSrc:String =
		                  "attribute vec3 a_position\n" +
						  "attribute vec3 a_position1\n" +
						  "attribute float a_thickness\n" +
						  "attribute vec3 a_color\n" +
						  
						  "varying vec4 v_color\n" +
						  
						  "uniform mat4 u_worldViewMatrix\n" +
						  "uniform mat4 u_projectionMatrix\n" +

						  "temp vec4 t_start\n" +
						  "temp vec4 t_end\n" +
						  "temp vec3 t_L\n" +
						  "temp float t_distance\n"+
						  "temp vec3 t_sideVec\n" +
						  
						  "##main\n" +
						  
						  "t_start = m44(a_position,u_worldViewMatrix)\n" +
						  "t_end = m44(a_position1,u_worldViewMatrix)\n" +
						  
						  // calculate side vector for line
						  "t_L = sub(t_end.xyz,t_start.xyz)\n" +
						  "t_sideVec = cross(t_L,t_start.xyz)\n" +
						  "t_sideVec = normalize(t_sideVec)\n" +
						  
						  // calculate the amount required to move at the point's distance to correspond to the line's pixel width
						  // scale the side vector by that amount
						  "t_distance = mul(t_start.z,0.001)\n" +
						  "t_distance = mul(t_distance,a_thickness)\n" +
						  "t_sideVec = mul(t_sideVec,t_distance)\n" +
						  
						  // add scaled side vector to Q0 and transform to clip space
						  "t_start.xyz = add(t_start.xyz,t_sideVec)\n" +
						  
						  // transform Q0 to clip space
						  "op = m44(t_start,u_projectionMatrix)\n" +
						  
                           // interpolate color
						  "v_color = a_color";
						  
		var fragmentSrc:String = "##main\n" +
						  "oc = v_color";
		setSource(vertexSrc,fragmentSrc);
	}
	
	override private function setUniformBinding():Void
	{
		bindUniform(ShaderType.VERTEX, "u_worldViewMatrix",UniformBinding.WorldViewMatrix);
		bindUniform(ShaderType.VERTEX, "u_projectionMatrix", UniformBinding.ProjectionMatrix);
	}
	
}