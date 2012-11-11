package org.angle3d.collision
{
	import org.angle3d.math.Triangle;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.mesh.Mesh;

	/**
	 * A <code>CollisionResult</code> represents a single collision instance
	 * between two {@link Collidable}. A collision check can result in many
	 * collision instances (places where collision has occured).
	 *
	 * @author Kirill Vainer
	 */
	public class CollisionResult
	{
		public var geometry:Geometry;
		public var contactPoint:Vector3f;
		public var contactNormal:Vector3f;
		public var distance:Number;
		public var triangleIndex:int;

		public function CollisionResult()
		{

		}

		public function getTriangle(store:Triangle = null):Triangle
		{
			if (store == null)
			{
				store = new Triangle();
			}

			var m:Mesh = geometry.getMesh();
			m.getTriangle(triangleIndex, store);
			store.calculateCenter();
			store.calculateNormal();
			return store;
		}

		public function compareTo(other:CollisionResult):int
		{
			return distance - other.distance;
		}

		public function equals(other:CollisionResult):Boolean
		{
			return this.compareTo(other) == 0;
		}
	}
}

