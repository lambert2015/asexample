package org.angle3d.effect.gpu.influencers.alpha
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	class RandomAlphaInfluencer extends AbstractInfluencer implements IAlphaInfluencer
	{
		public function RandomAlphaInfluencer()
		{
			super();
		}

		public function getAlpha(index:Int):Float
		{
			return Math.random();
		}
	}
}
