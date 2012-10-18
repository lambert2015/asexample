package org.angle3d.material;
import org.angle3d.material.technique.TechniqueFill;
import org.angle3d.math.Color;


/**
 * 单色的Material
 * @author andy
 */
class MaterialFill extends Material
{
	private var _technique:TechniqueFill;

	public function new(color:UInt = 0xFFFFF) 
	{
		super();

		_technique = new TechniqueFill(color);
		
		addTechnique(_technique);
	}
	
	override private function _setAlpha(alpha:Float):Float
	{
		_technique.setAlpha(alpha);
		
		return super._setAlpha(alpha);
	}
	
	public function setColor(color:UInt):Void
	{
		_technique.setColor(color);
	}
	
	public function getColor():UInt
	{
		return _technique.getColor();
	}
}