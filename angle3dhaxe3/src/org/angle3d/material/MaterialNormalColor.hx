package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueNormalColor;


	/**
	 * 顶点法线的Material
	 * @author andy
	 */
	class MaterialNormalColor extends Material
	{
		private var _technique:TechniqueNormalColor;

		public function MaterialNormalColor()
		{
			super();

			_technique = new TechniqueNormalColor();

			addTechnique(_technique);
		}

		override public function set influence(value:Float):Void
		{
			_technique.influence = value;
		}

		public function get technique():TechniqueNormalColor
		{
			return _technique;
		}
	}
}

