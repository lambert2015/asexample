package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueColorFill;


	/**
	 * 单色的Material
	 * @author andy
	 */
	class MaterialColorFill extends Material
	{
		private var _technique:TechniqueColorFill;

		public function MaterialColorFill(color:uint = 0xFFFFF, alpha:Float = 1.0)
		{
			super();

			_technique = new TechniqueColorFill(color);

			addTechnique(_technique);

			this.alpha = alpha;

			sortingId = 1;
		}

		public function get technique():TechniqueColorFill
		{
			return _technique;
		}

		override public function set influence(value:Float):Void
		{
			_technique.influence = value;
		}

		override public function set alpha(alpha:Float):Void
		{
			_technique.alpha = alpha;

			super.alpha = alpha;
		}

		public function set color(color:uint):Void
		{
			_technique.color = color;
		}

		public function get color():uint
		{
			return _technique.color;
		}
	}
}

