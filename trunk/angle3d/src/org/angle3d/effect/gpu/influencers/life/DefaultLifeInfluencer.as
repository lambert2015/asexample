package org.angle3d.effect.gpu.influencers.life
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	public class DefaultLifeInfluencer extends AbstractInfluencer implements ILifeInfluencer
	{
		private var _lowLife:Number;
		private var _highLife:Number;

		public function DefaultLifeInfluencer(lowLife:Number, highLife:Number)
		{
			_lowLife = lowLife;
			_highLife = highLife;
		}

		public function getLife(index:int):Number
		{
			return _lowLife + (_highLife - _lowLife) * Math.random();
		}
	}
}
