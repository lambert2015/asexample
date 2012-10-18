package org.angle3d.material;
import org.angle3d.material.technique.TechniqueVertexColor;


/**
 * 顶点颜色的Material
 * @author andy
 */
class MaterialVertexColor extends Material
{
	private var _technique:TechniqueVertexColor;

	public function new() 
	{
		super();

		_technique = new TechniqueVertexColor();
		
		addTechnique(_technique);
	}
	
	override private function _setAlpha(alpha:Float):Float
	{
		_technique.setAlpha(alpha);
		
		return super._setAlpha(alpha);
	}
}