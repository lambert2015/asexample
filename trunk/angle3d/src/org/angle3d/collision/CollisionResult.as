package org.angle3d.collision
{
	import org.angle3d.math.Triangle;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class CollisionResult
	{
		public var distance:Number;

		private var geometry:Geometry;
		private var contactPoint:Vector3f;
		private var contactNormal:Vector3f;

		private var triangleIndex:int;

		public function CollisionResult()
		{

		}

		public function setContactPointAndDistance(contactPoint:Vector3f, distance:Number):void
		{
			this.contactPoint = contactPoint;
			this.distance = distance;
		}

		public function setGeometry(geom:Geometry):void
		{
			this.geometry = geom;
		}

		public function setContactNormal(norm:Vector3f):void
		{
			this.contactNormal = norm;
		}

		public function setContactPoint(point:Vector3f):void
		{
			this.contactPoint = point;
		}

		public function setTriangleIndex(index:int):void
		{
			this.triangleIndex = index;
		}

		public function getTriangle(store:Triangle = null):Triangle
		{
			if (store == null)
			{
				store = new Triangle();
			}

//			var m:Mesh = geometry.getMesh();
//			m.getTriangle(triangleIndex, store);
			store.calculateCenter();
			store.calculateNormal();
			return store;
		}

		public function getContactPoint():Vector3f
		{
			return contactPoint;
		}

		public function getContactNormal():Vector3f
		{
			return contactNormal;
		}

		public function getGeometry():Geometry
		{
			return geometry;
		}

		public function getTriangleIndex():int
		{
			return triangleIndex;
		}
	}
}

