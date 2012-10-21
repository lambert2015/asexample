package org.angle3d.effect.gpu.influencers.scale
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.FastMath;

	/**
	 * 粒子缩放
	 */
	public class DefaultScaleInfluencer extends AbstractInfluencer implements IScaleInfluencer
	{
		private var _scale:Number;
		private var _variation:Number;

		public function DefaultScaleInfluencer(scale:Number=1.0, variation:Number=0.0)
		{
			_scale=scale;
			_variation=variation;
		}

		public function getDefaultScale(index:int):Number
		{
			return FastMath.lerp(_scale, Math.random() * 2 - 1, _variation);
		}
	}
}
