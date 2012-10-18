package org.angle3d.material.technique;
import flash.display3D.Context3D;
import flash.Vector;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.UniformBinding;

/**
 * ...
 * @author andy
 */

class TechniqueVertexColor extends Technique
{
	private var _alpha:Vector<Float>;
	
	public function new() 
	{
		super("VertexColorTechnique");
		
		_renderState.applyDepthTest = true;
		_renderState.depthTest = true;
		
		_renderState.applyBlendMode = false;
		
		_alpha = new Vector<Float>(4,true);
	}
	
	public function setAlpha(alpha:Float):Void
	{
		_alpha[0] = FastMath.fclamp(alpha, 0.0, 1.0);
	}
	
	public function getAlpha():Float
	{
		return _alpha[0];
	}
	
	/**
	 * 更新Uniform属性
	 * @param	shader
	 */
	override public function updateShader(shader:Shader):Void
	{
		shader.getUniform(ShaderType.VERTEX, "u_alpha").setVector(_alpha);
	}
	
	override private function getVertexSource():String
	{
		return 
		    "attribute vec3 a_position\n" +
		    "attribute vec3 a_color\n" +
			
			"uniform mat4 u_WorldViewProjectionMatrix\n" +
			"uniform vec4 u_alpha\n" +
			
			"varying vec4 v_color\n" +
			
			"@main\n" +
			"op = m44(a_position,u_WorldViewProjectionMatrix)\n" +
			"v_color.xyz = a_color.xyz\n"+
			"v_color.w = u_alpha.x";
	}
	
	override private function getFragmentSource():String
	{
		return "@main\n" +
			   "oc = v_color";
	}
	
	override private function _initUniformBindings():Void
	{
		addUniformBinding(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix);
	}
	
}