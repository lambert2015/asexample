package org.angle3d.effect.gpu.influencers.alpha
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	public class DefaultAlphaInfluencer extends AbstractInfluencer implements IAlphaInfluencer
	{
		private var _alpha:Number;

		public function DefaultAlphaInfluencer(alpha:Number = 1.0)
		{
			super();
			_alpha = alpha;
		}

		public function getAlpha(index:int):Number
		{
			return _alpha;
		}
	}
}
