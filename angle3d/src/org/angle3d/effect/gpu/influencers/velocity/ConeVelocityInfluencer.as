package org.angle3d.effect.gpu.influencers.velocity
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Vector3f;

	public class ConeVelocityInfluencer extends AbstractInfluencer implements IVelocityInfluencer
	{
		private var _speed:Number;

		private var _temp:Vector3f;
		private var _variation:Number;

		public function ConeVelocityInfluencer(speed:Number)
		{
			_speed = speed;

			_temp = new Vector3f();
		}

		public function getVelocity(index:int, store:Vector3f):Vector3f
		{
			var degree1:Number = Math.random() * Math.PI * 2;
			var degree2:Number = Math.PI * 80 / 180 + Math.random() * Math.PI * 5 / 180;

			store.x = _speed * Math.sin(degree1) * Math.cos(degree2);
			store.y = _speed * Math.sin(degree2);
			store.z = _speed * Math.cos(degree1) * Math.cos(degree2);

			return store;
		}
	}
}
