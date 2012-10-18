package org.angle3d.material;
import org.angle3d.material.technique.TechniqueWireframe;

/**
 * ...
 * @author andy
 */

class MaterialWireframe extends Material
{
	private var _technique:TechniqueWireframe;

	public function new(color:UInt = 0xFF0000, thickness:Float = 1.0) 
	{
		super();
		
		_technique = new TechniqueWireframe(color, thickness);
		
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