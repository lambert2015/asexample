package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueWireframe;

	/**
	 * 线框模式
	 * @author andy
	 */

	public class MaterialWireframe extends Material
	{
		private var _technique:TechniqueWireframe;

		public function MaterialWireframe(color:uint = 0xFF0000, thickness:Number = 1.0)
		{
			super();

			_technique = new TechniqueWireframe(color, thickness);

			addTechnique(_technique);
		}

		public function set thickness(thickness:Number):void
		{
			_technique.thickness = thickness;
		}

		public function get thickness():Number
		{
			return _technique.thickness;
		}

		public function get technique():TechniqueWireframe
		{
			return _technique;
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

