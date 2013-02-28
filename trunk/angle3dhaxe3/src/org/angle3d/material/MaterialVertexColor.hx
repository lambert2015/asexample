package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueVertexColor;


	/**
	 * 顶点颜色
	 * Mesh中需要有color部分
	 * @author andy
	 */
	class MaterialVertexColor extends Material
	{
		private var _technique:TechniqueVertexColor;

		public function MaterialVertexColor()
		{
			super();

			_technique = new TechniqueVertexColor();

			addTechnique(_technique);

			sortingId = 4;
		}

		override public function set alpha(alpha:Float):Void
		{
			_technique.setAlpha(alpha);

			super.alpha = alpha;
		}
	}
}

