package org.angle3d.effect.gpu.influencers.position
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Vector3f;

	/**
	 * 粒子随机分配在一个球体内
	 * edge为true时，粒子都在球体表面上
	 * random为true时，随机分配位置,否则均匀分配--->如何均匀分配呢
	 */
	public class SpherePositionInfluencer extends AbstractInfluencer implements IPositionInfluencer
	{
		private var _center:Vector3f;
		private var _radius:Number;
		private var _radiusSquared:Number;
		private var _edge:Boolean;
		private var _random:Boolean;

		private var _randomPoint:Vector3f=new Vector3f();

		public function SpherePositionInfluencer(center:Vector3f, radius:Number, edge:Boolean=false, random:Boolean=true)
		{
			_center=center;
			_radius=radius;
			_radiusSquared=radius * radius;
			_edge=edge;
			_random=random;
		}

		public function getPosition(index:int, store:Vector3f):Vector3f
		{
			if (_edge)
			{
				_randomPoint.x=(Math.random() * 2 - 1);
				_randomPoint.y=(Math.random() * 2 - 1);
				_randomPoint.z=(Math.random() * 2 - 1);
				_randomPoint.normalizeLocal();

				store.x=_center.x + _randomPoint.x * _radius;
				store.y=_center.y + _randomPoint.y * _radius;
				store.z=_center.z + _randomPoint.z * _radius;
			}
			else
			{
				do
				{
					store.x=_center.x + (Math.random() * 2 - 1) * _radius;
					store.y=_center.y + (Math.random() * 2 - 1) * _radius;
					store.z=_center.z + (Math.random() * 2 - 1) * _radius;
				} while (store.distanceSquared(_center) > _radiusSquared);
			}

			return store;
		}
	}
}
