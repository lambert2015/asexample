package org.angle3d.effect.gpu.influencers.angle
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	public class DefaultAngleInfluencer extends AbstractInfluencer implements IAngleInfluencer
	{
		public function DefaultAngleInfluencer()
		{
		}

		public function getDefaultAngle(index:int):Number
		{
			return Math.PI * 2 * Math.random();
		}
	}
}
