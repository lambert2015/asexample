package org.angle3d.material.technique;
import org.angle3d.material.FaceCullMode;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.texture.CubeTextureMap;

/**
 * 天空体
 * @author andy
 */

class TechniqueSkyBox extends Technique
{
	private var _cubeTexture:CubeTextureMap;

	public function new(cubeTexture:CubeTextureMap) 
	{
		super("TechniqueSkyBox");
		
		_cubeTexture = cubeTexture;
		
		_renderState.applyCullMode = true;
		_renderState.cullMode = FaceCullMode.Off;
		
		_renderState.applyDepthTest = false;
		_renderState.depthTest = false;
		
		_renderState.applyBlendMode = false;
	}
	
	/**
	 * 更新Uniform属性
	 * @param	shader
	 */
	override public function updateShader(shader:Shader):Void
	{
		shader.getTextureVar("t_cubeTexture").textureMap = _cubeTexture;
	}
	
	override private function getVertexSource():String
	{
		return "attribute vec3 a_position\n" +
		       "attribute vec3 a_normal\n" +
			   
			   "uniform mat4 u_ViewMatrix\n" +
			   "uniform mat4 u_ProjectionMatrix\n" +
			   "uniform mat4 u_WorldMatrix\n" +
			   
			   "temp vec4 t_temp\n" +
			   
			   "varying vec4 v_direction\n" +
			   
			   "@main\n" +
			   "t_temp.xyz = a_position.xyz\n" +
			   "t_temp.w = 0.0\n"+
			   "t_temp = m44(t_temp,u_ViewMatrix)\n" +
			   "t_temp.w = 1.0\n"+
			   "op = m44(t_temp,u_ProjectionMatrix)\n" +
			   
			   "t_temp.xyz = a_normal.xyz\n" +
			   "t_temp.w = 0.0\n"+
			   "t_temp = m44(t_temp,u_WorldMatrix)\n" +
			   "t_temp.xyz = normalize(t_temp.xyz)\n" +
			   "t_temp.w = 1.0\n"+
			   "v_direction = t_temp";
	}
	
	override private function getFragmentSource():String
	{
		return "texture t_cubeTexture\n" +
		       "@main\n" +
			   "oc = texture(v_direction,t_cubeTexture<cube,nomip,linear,clamp>)";
	}
	
	override private function _initUniformBindings():Void
	{
		addUniformBinding(ShaderType.VERTEX, "u_ViewMatrix", UniformBinding.ViewMatrix);
		addUniformBinding(ShaderType.VERTEX, "u_ProjectionMatrix", UniformBinding.ProjectionMatrix);
		addUniformBinding(ShaderType.VERTEX, "u_WorldMatrix", UniformBinding.WorldMatrix);
	}
	
}