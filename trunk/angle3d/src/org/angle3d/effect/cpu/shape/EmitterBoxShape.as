package org.angle3d.effect.cpu.shape
{
	import flash.geom.Vector3D;
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class EmitterBoxShape implements EmitterShape
	{
		private var _min:Vector3f;
		private var _max:Vector3f;
		private var _size:Vector3f;

		public function EmitterBoxShape(min:Vector3f, max:Vector3f)
		{
			_min=min.clone();
			_max=max.clone();
			_size=max.subtract(min);
		}

		public function getRandomPoint(store:Vector3f):void
		{
			store.x=_min.x + _size.x * Math.random();
			store.y=_min.y + _size.y * Math.random();
			store.z=_min.z + _size.z * Math.random();
		}

		public function getRandomPointAndNormal(store:Vector3f, normal:Vector3f):void
		{
			store.x=_min.x + _size.x * Math.random();
			store.y=_min.y + _size.y * Math.random();
			store.z=_min.z + _size.z * Math.random();
		}

		public function clone():EmitterShape
		{
			return new EmitterBoxShape(_min, _max);
		}
	}
}

