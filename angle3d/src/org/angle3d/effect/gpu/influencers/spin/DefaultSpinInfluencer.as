package org.angle3d.effect.gpu.influencers.spin
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.FastMath;

	public class DefaultSpinInfluencer extends AbstractInfluencer implements ISpinInfluencer
	{
		private var _spin:Number;
		private var _variation:Number;

		public function DefaultSpinInfluencer(spin:Number = 0, variation:Number = 0.0)
		{
			_spin = spin;
			_variation = variation;
		}

		public function getSpin(index:int):Number
		{
			return FastMath.lerp(_spin, (Math.random() * 2 - 1) * _spin, _variation);
		}
	}
}
