package org.angle3d.effect.gpu.influencers.velocity
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;

	/***
	 * 四面八方随机
	 */
	public class RandomVelocityInfluencer extends AbstractInfluencer implements IVelocityInfluencer
	{
		private var _speed:Number;

		private var _variation:Number;

		private var _temp:Vector3f;

		public function RandomVelocityInfluencer(speed:Number, variation:Number=0)
		{
			_speed=speed;

			_variation=FastMath.fclamp(variation, 0.0, 1.0);

			_temp=new Vector3f();
		}

		public function getVelocity(index:int, store:Vector3f):Vector3f
		{
			_temp.x=(Math.random() * 2 - 1);
			_temp.y=(Math.random() * 2 - 1);
			_temp.z=(Math.random() * 2 - 1);
			_temp.normalizeLocal();

			store.x=_temp.x * _speed;
			store.y=_temp.y * _speed;
			store.z=_temp.z * _speed;

			return store;
		}
	}
}
