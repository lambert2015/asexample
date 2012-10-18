package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueFill;
	import org.angle3d.math.Color;


	/**
	 * 单色的Material
	 * @author andy
	 */
	public class MaterialFill extends Material
	{
		private var _technique:TechniqueFill;

		public function MaterialFill(color:uint = 0xFFFFF, alpha:Number = 1.0)
		{
			super();

			_technique = new TechniqueFill(color);

			addTechnique(_technique);

			this.alpha = alpha;
		}
		
		public function get technique():TechniqueFill
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

