package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueColorFill;


	/**
	 * 单色的Material
	 * @author andy
	 */
	public class MaterialColorFill extends Material
	{
		private var _technique:TechniqueColorFill;

		public function MaterialColorFill(color:uint = 0xFFFFF, alpha:Number = 1.0)
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

		override public function set influence(value:Number):void
		{
			_technique.influence = value;
		}

		override public function set alpha(alpha:Number):void
		{
			_technique.alpha = alpha;

			super.alpha = alpha;
		}

		public function set color(color:uint):void
		{
			_technique.color = color;
		}

		public function get color():uint
		{
			return _technique.color;
		}
	}
}

