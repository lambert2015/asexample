package org.angle3d.effect.gpu.influencers.life
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	class SameLifeInfluencer extends AbstractInfluencer implements ILifeInfluencer
	{
		private var _life:Float;

		public function SameLifeInfluencer(life:Float)
		{
			_life = life;
		}

		public function getLife(index:Int):Float
		{
			return _life;
		}
	}
}
