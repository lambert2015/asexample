package org.angle3d.effect.gpu.influencers.color
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Color;

	public class DefaultColorInfluencer extends AbstractInfluencer implements IColorInfluencer
	{
		private var _color:uint;

		public function DefaultColorInfluencer(color:uint=0x0)
		{
			super();
			_color=color;
		}

		public function getColor(index:int, color:Color):Color
		{
			color.setRGB(_color);
			return color;
		}
	}
}
