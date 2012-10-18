package org.angle3d.math
{
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class AbstractTriangle implements Collidable
	{

		public function AbstractTriangle()
		{

		}

		public function getPoint(i:int):Vector3f
		{
			return null;
		}

		public function setPoint(i:int, point:Vector3f):void
		{

		}


		public function getPoint1():Vector3f
		{
			return null;
		}

		public function getPoint2():Vector3f
		{
			return null;
		}

		public function getPoint3():Vector3f
		{
			return null;
		}

		public function setPoints(p1:Vector3f, p2:Vector3f, p3:Vector3f):void
		{

		}

		public function collideWith(other:Collidable, results:CollisionResults):int
		{
			return other.collideWith(this, results);
		}
	}
}

