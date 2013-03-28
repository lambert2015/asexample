package org.angle3d.material;

import org.angle3d.material.technique.TechniqueColorFill;


/**
 * 单色的Material
 * @author andy
 */
class MaterialColorFill extends Material
{
	private var _technique:TechniqueColorFill;

	public function new(color:UInt = 0xFFFFF, alpha:Float = 1.0)
	{
		super();

		_technique = new TechniqueColorFill(color);

		addTechnique(_technique);

		this.alpha = alpha;

		sortingId = 1;
	}

	public var technique(get, null):TechniqueColorFill;
	private function get_technique():TechniqueColorFill
	{
		return _technique;
	}

	override private function set_influence(value:Float):Float
	{
		return _technique.influence = value;
	}

	override private function set_alpha(alpha:Float):Float
	{
		_technique.alpha = alpha;

		super.alpha = alpha;
		
		return _technique.alpha;
	}

	public var color(get, set):UInt;
	private function get_color():UInt
	{
		return _technique.color;
	}
	private function set_color(color:UInt):UInt
	{
		return _technique.color = color;
	}
}

