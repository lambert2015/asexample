package org.angle3d.effect.cpu.shape
{
	import flash.geom.Vector3D;
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */
	public class EmitterPointShape implements EmitterShape
	{
		private var _point:Vector3f;

		public function EmitterPointShape(vector:Vector3f=null)
		{
			_point=new Vector3f(0, 0, 0);

			if (vector != null)
				_point.copyFrom(vector);
		}

		public function getPoint():Vector3f
		{
			return _point;
		}

		public function setPoint(point:Vector3f):void
		{
			_point.copyFrom(point);
		}

		public function getRandomPoint(store:Vector3f):void
		{
			store.copyFrom(_point);
		}

		public function getRandomPointAndNormal(store:Vector3f, normal:Vector3f):void
		{
			store.copyFrom(_point);
		}

		public function clone():EmitterShape
		{
			return new EmitterPointShape(_point);
		}
	}
}

