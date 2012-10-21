package org.angle3d.effect.gpu.influencers.velocity
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;

	public class DefaultVelocityInfluencer extends AbstractInfluencer implements IVelocityInfluencer
	{
		private var _velocity:Vector3f;
		private var _velocityLength:Number;
		private var _temp:Vector3f;
		private var _variation:Number;

		public function DefaultVelocityInfluencer(velocity:Vector3f=null, variation:Number=0.2)
		{
			_velocity=velocity == null ? new Vector3f(0, 0, 0) : velocity;
			_velocityLength=_velocity.length;

			_variation=FastMath.fclamp(variation, 0.0, 1.0);

			_temp=new Vector3f();
		}

		public function getVelocity(index:int, store:Vector3f):Vector3f
		{
			_temp.x=(Math.random() * 2 - 1) * _velocityLength;
			_temp.y=(Math.random() * 2 - 1) * _velocityLength;
			_temp.z=(Math.random() * 2 - 1) * _velocityLength;

			store.lerp(_velocity, _temp, _variation);

			return store;
		}
	}
}
