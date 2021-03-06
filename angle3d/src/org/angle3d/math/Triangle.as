package org.angle3d.math
{
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.Vector3f;

	/**
	 * <code>Triangle</code> defines a object for containing triangle information.
	 * The triangle is defined by a collection of three <code>Vector3f</code>
	 * objects.
	 *
	 * @author Mark Powell
	 * @author Joshua Slack
	 */
	public class Triangle implements Collidable
	{
		public var point1:Vector3f;
		public var point2:Vector3f;
		public var point3:Vector3f;

		public var center:Vector3f;
		public var normal:Vector3f;

		public var projection:Number;
		public var index:int;

		public function Triangle(p1:Vector3f = null, p2:Vector3f = null, p3:Vector3f = null)
		{
			super();

			point1 = new Vector3f();
			point2 = new Vector3f();
			point3 = new Vector3f();

			if (p1 != null && p2 != null && p3 != null)
			{
				point1.copyFrom(p1);
				point2.copyFrom(p2);
				point3.copyFrom(p3);
			}
		}

		public function collideWith(other:Collidable, results:CollisionResults):int
		{
			return other.collideWith(this, results);
		}

		public function getPoint(i:int):Vector3f
		{
			switch (i)
			{
				case 0:
					return point1;
				case 1:
					return point2;
				case 2:
					return point3;
				default:
					return null;
			}
		}

		/**
		 *
		 * <code>set</code> sets one of the triangles points to that specified as
		 * a parameter.
		 * @param i the index to place the point.
		 * @param point the point to set.
		 */
		public function setPoint(i:int, point:Vector3f):void
		{
			switch (i)
			{
				case 0:
					point1.copyFrom(point);
					break;
				case 1:
					point2.copyFrom(point);
					break;
				case 2:
					point3.copyFrom(point);
					break;
			}
		}

		public function setPoints(p1:Vector3f, p2:Vector3f, p3:Vector3f):void
		{
			point1.copyFrom(p1);
			point2.copyFrom(p2);
			point3.copyFrom(p3);
		}

		/**
		 * calculateCenter finds the average point of the triangle.
		 *
		 */
		public function calculateCenter():void
		{
			if (center == null)
			{
				center = point1.clone();
			}
			else
			{
				center.copyFrom(point1);
			}

			center.addLocal(point2);
			center.addLocal(point3);
			center.scaleLocal(1 / 3);
		}

		/**
		 * calculateCenter finds the average point of the triangle.
		 *
		 */
		public function calculateNormal():void
		{
			if (normal == null)
			{
				normal = point2.clone();
			}
			else
			{
				normal.copyFrom(point2);
			}
			normal.subtractLocal(point1);
			normal.crossLocal(point3.subtract(point1));
			normal.normalizeLocal();
		}

		/**
		 * obtains the center point of this triangle (average of the three triangles)
		 * @return the center point.
		 */
		public function getCenter():Vector3f
		{
			if (center == null)
			{
				calculateCenter();
			}
			return center;
		}

		/**
		 * sets the center point of this triangle (average of the three triangles)
		 * @param center the center point.
		 */
		public function setCenter(center:Vector3f):void
		{
			this.center = center;
		}

		/**
		 * obtains the unit length normal vector of this triangle, if set or
		 * calculated
		 *
		 * @return the normal vector
		 */
		public function getNormal():Vector3f
		{
			if (normal == null)
			{
				calculateNormal();
			}
			return normal;
		}

		/**
		 * sets the normal vector of this triangle (to conform, must be unit length)
		 * @param normal the normal vector.
		 */
		public function setNormal(normal:Vector3f):void
		{
			this.normal = normal;
		}

		/**
		 * obtains the projection of the vertices relative to the line origin.
		 * @return the projection of the triangle.
		 */
		public function getProjection():Number
		{
			return this.projection;
		}

		/**
		 * sets the projection of the vertices relative to the line origin.
		 * @param projection the projection of the triangle.
		 */
		public function setProjection(projection:Number):void
		{
			this.projection = projection;
		}

		/**
		 * obtains an index that this triangle represents if it is contained in a OBBTree.
		 * @return the index in an OBBtree
		 */
		public function getIndex():int
		{
			return this.index;
		}

		/**
		 * sets an index that this triangle represents if it is contained in a OBBTree.
		 * @param index the index in an OBBtree
		 */
		public function setIndex(index:int):void
		{
			this.index = index;
		}

		public static function computeTriangleNormal(v1:Vector3f, v2:Vector3f, v3:Vector3f, store:Vector3f = null):Vector3f
		{
			if (store == null)
			{
				store = v2.clone();
			}
			else
			{
				store.copyFrom(v2);
			}

			store.subtractLocal(v1);
			store.crossLocal(v3.subtract(v1));
			store.normalizeLocal();

			return store;
		}

		public function copy(tri:Triangle):void
		{
			this.point1.copyFrom(tri.point1);
			this.point2.copyFrom(tri.point2);
			this.point3.copyFrom(tri.point3);
		}

		public function clone():Triangle
		{
			return new Triangle(point1, point2, point3);
		}
	}
}

