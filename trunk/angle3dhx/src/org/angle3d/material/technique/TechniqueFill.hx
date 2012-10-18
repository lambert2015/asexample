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

class TechniqueFill extends Technique
{
	private var _color:Color;

	public function new(color:UInt = 0xFFFFF) 
	{
		super("FillTechnique");
		
		_renderState.applyDepthTest = true;
		_renderState.depthTest = true;
		
		_renderState.applyBlendMode = false;
		
		_color = new Color(0, 0, 0, 1);

		setColor(color);
	}
	
	public function setColor(color:UInt):Void
	{
		_color.setRGB(color);
	}
	
	public function setAlpha(alpha:Float):Void
	{
		_color.a = FastMath.fclamp(alpha, 0.0, 1.0);
	}
	
	public function getAlpha():Float
	{
		return _color.a;
	}
	
	public function getColor():UInt
	{
		return _color.getColor();
	}
	
	/**
	 * 更新Uniform属性
	 * @param	shader
	 */
	override public function updateShader(shader:Shader):Void
	{
		shader.getUniform(ShaderType.VERTEX, "u_color").setColor(_color);
	}
	
	override private function getVertexSource():String
	{
		return "attribute vec3 a_position\n" +
			   "varying vec4 v_color\n" +
			   "uniform mat4 u_WorldViewProjectionMatrix\n" +
			   "uniform vec4 u_color\n" +
			   "@main\n" +
			   "op = m44(a_position,u_WorldViewProjectionMatrix)\n" +
			   "v_color = u_color";
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