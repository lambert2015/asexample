package org.angle3d.effect.gpu.influencers.position
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Vector3f;

	/**
	 * 粒子随机分配在一个球体内
	 * edge为true时，粒子都在球体表面上
	 * random为true时，随机分配位置,否则均匀分配--->如何均匀分配呢
	 */
	public class CirclePositionInfluencer extends AbstractInfluencer implements IPositionInfluencer
	{
		private var _center:Vector3f;
		private var _radius:Number;
		private var _startAngle:Number;

		public function CirclePositionInfluencer(center:Vector3f, radius:Number, startAngle:Number)
		{
			_center = center;
			_radius = radius;
			_startAngle = startAngle;
		}

		public function getPosition(index:int, store:Vector3f):Vector3f
		{
			var _perAngle:Number = Math.PI * 2 / _generator.perSecondParticleCount;
			
			index = index % _generator.perSecondParticleCount;

			store.x = _center.x + Math.sin(index * _perAngle) * _radius;
			store.y = _center.y;
			store.z = _center.z + Math.cos(index * _perAngle) * _radius;

			return store;
		}
	}
}
