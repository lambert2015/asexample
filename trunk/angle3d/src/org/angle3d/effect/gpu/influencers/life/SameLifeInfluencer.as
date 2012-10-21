package org.angle3d.effect.gpu.influencers.life
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	public class SameLifeInfluencer extends AbstractInfluencer implements ILifeInfluencer
	{
		private var _life:Number;

		public function SameLifeInfluencer(life:Number)
		{
			_life = life;
		}

		public function getLife(index:int):Number
		{
			return _life;
		}
	}
}
