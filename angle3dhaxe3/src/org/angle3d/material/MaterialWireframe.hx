package org.angle3d.material;

import org.angle3d.material.technique.TechniqueWireframe;

/**
 * 线框模式
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

		sortingId = 3;
	}

	public function set thickness(thickness:Float):Void
	{
		_technique.thickness = thickness;
	}

	public function get thickness():Float
	{
		return _technique.thickness;
	}

	public function get technique():TechniqueWireframe
	{
		return _technique;
	}

	override public function set alpha(alpha:Float):Void
	{
		_technique.alpha = alpha;

		super.alpha = alpha;
	}

	public function set color(color:UInt):Void
	{
		_technique.color = color;
	}

	public function get color():UInt
	{
		return _technique.color;
	}

}

