package org.angle3d.effect.gpu.influencers.alpha
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	
	public class RandomAlphaInfluencer extends AbstractInfluencer implements IAlphaInfluencer
	{
		public function RandomAlphaInfluencer()
		{
			super();
		}
		
		public function getAlpha(index:int):Number
		{
			return Math.random();
		}
	}
}