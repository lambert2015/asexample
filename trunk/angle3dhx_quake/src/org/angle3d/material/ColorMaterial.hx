package org.angle3d.material;
import flash.display3D.Context3D;
import org.angle3d.math.Color;
import org.angle3d.shader.basic.SingleColorShader;
import org.angle3d.shader.ShaderType;

import flash.Vector;

/**
 * 单色的Material
 * @author andy
 */
class ColorMaterial extends Material
{
	private var _color:Color;
	
	private var _colorVector:Vector<Float>;

	public function new(color:UInt = 0xFFFFF) 
	{
		super();
		
		_color = new Color(1, 0, 0, 1);
		_colorVector = new Vector<Float>(4, true);
		
		setShader(new SingleColorShader());
		setLightMode(LightMode.Disable);
		
		setColor(color);
	}
	
	public function setColor(color:UInt):Void
	{
		_color.setColor(color);
		
		setTransparent(_color.a < 1);
		
		setParam(ShaderType.VERTEX, "u_color", _color.toUniform(_colorVector));
	}
	
	public function getColor():Color
	{
		return _color;
	}
	
}