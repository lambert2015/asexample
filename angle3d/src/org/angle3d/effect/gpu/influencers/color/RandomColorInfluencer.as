package org.angle3d.effect.gpu.influencers.color
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Color;

	public class RandomColorInfluencer extends AbstractInfluencer implements IColorInfluencer
	{
		public function RandomColorInfluencer()
		{
			super();
		}

		public function getColor(index:int, color:Color):Color
		{
			color.r = Math.random();
			color.g = Math.random();
			color.b = Math.random();
			return color;
		}
	}
}
