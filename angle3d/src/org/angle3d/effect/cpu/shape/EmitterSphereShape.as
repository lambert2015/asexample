package org.angle3d.effect.cpu.shape
{
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class EmitterSphereShape implements EmitterShape
	{
		private var _center:Vector3f;
		private var _radius:Number;
		private var _radiusSquared:Number;

		public function EmitterSphereShape(center:Vector3f, radius:Number)
		{
			_center=center.clone();
			_radius=radius;
			_radiusSquared=radius * radius;
		}

		public function getRandomPoint(store:Vector3f):void
		{
			do
			{
				store.x=(Math.random() * 2 - 1) * _radius;
				store.y=(Math.random() * 2 - 1) * _radius;
				store.z=(Math.random() * 2 - 1) * _radius;
			} while (store.distanceSquared(_center) > _radiusSquared);
		}

		public function getRandomPointAndNormal(store:Vector3f, normal:Vector3f):void
		{
			getRandomPoint(store);
		}

		public function clone():EmitterShape
		{
			return new EmitterSphereShape(_center, _radius);
		}
	}
}

