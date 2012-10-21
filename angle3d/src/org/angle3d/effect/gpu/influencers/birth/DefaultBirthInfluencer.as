package org.angle3d.effect.gpu.influencers.birth
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	public class DefaultBirthInfluencer extends AbstractInfluencer implements IBirthInfluencer
	{
		public function DefaultBirthInfluencer()
		{
			super();
		}

		public function getBirth(index:int):Number
		{
			var perCount:int=_generator.perSecondParticleCount;

			var count:int=int(index / perCount);

			return count + (index - count * perCount) / perCount;
		}
	}
}
