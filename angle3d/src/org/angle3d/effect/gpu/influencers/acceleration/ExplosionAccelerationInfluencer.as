package org.angle3d.effect.gpu.influencers.acceleration
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Vector3f;

	public class ExplosionAccelerationInfluencer extends AbstractInfluencer implements IAccelerationInfluencer
	{
		private var _scale:Number;

		public function ExplosionAccelerationInfluencer(scale:Number)
		{
			super();
			_scale=scale;
		}

		/**
		 * 沿着原来运动方向
		 */
		public function getAcceleration(velocity:Vector3f, store:Vector3f):Vector3f
		{
			store.x=velocity.x * _scale;
			store.y=velocity.y * _scale;
			store.z=velocity.z * _scale;
			return store;
		}
	}
}
