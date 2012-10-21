package org.angle3d.effect.gpu.influencers.birth
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	/**
	 * 根据每秒发射数量分开发射
	 */
	public class PerSecondBirthInfluencer extends AbstractInfluencer implements IBirthInfluencer
	{
		private var _scale:Number;

		public function PerSecondBirthInfluencer(scale:Number=1.0)
		{
			super();
			_scale=scale;
		}

		public function getBirth(index:int):Number
		{
			return int(index / _generator.perSecondParticleCount) * _scale;
		}
	}
}
