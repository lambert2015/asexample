package org.angle3d.math
{
	import org.angle3d.math.Vector3f;

	/**
	 * <code>Triangle</code> defines a object for containing triangle information.
	 * The triangle is defined by a collection of three <code>Vector3f</code>
	 * objects.
	 *
	 * @author Mark Powell
	 * @author Joshua Slack
	 */
	public class Triangle extends AbstractTriangle
	{
		private var pointA:Vector3f;
		private var pointB:Vector3f;
		private var pointC:Vector3f;

		private var center:Vector3f;
		private var normal:Vector3f;

		private var projection:Number;
		private var index:int;

		public function Triangle(p1:Vector3f = null, p2:Vector3f = null, p3:Vector3f = null)
		{
			super();

			pointA = new Vector3f();
			pointB = new Vector3f();
			pointC = new Vector3f();

			if (p1 != null && p2 != null && p3 != null)
			{
				pointA.copyFrom(p1);
				pointB.copyFrom(p2);
				pointC.copyFrom(p3);
			}
		}

		override public function getPoint(i:int):Vector3f
		{
			switch (i)
			{
				case 0:
					return pointA;
				case 1:
					return pointB;
				case 2:
					return pointC;
				default:
					return null;
			}
		}

		override public function getPoint1():Vector3f
		{
			return pointA;
		}

		override public function getPoint2():Vector3f
		{
			return pointB;
		}

		override public function getPoint3():Vector3f
		{
			return pointC;
		}

		/**
		 *
		 * <code>set</code> sets one of the triangles points to that specified as
		 * a parameter.
		 * @param i the index to place the point.
		 * @param point the point to set.
		 */
		override public function setPoint(i:int, point:Vector3f):void
		{
			switch (i)
			{
				case 0:
					pointA.copyFrom(point);
					break;
				case 1:
					pointB.copyFrom(point);
					break;
				case 2:
					pointC.copyFrom(point);
					break;
			}
		}

		override public function setPoints(p1:Vector3f, p2:Vector3f, p3:Vector3f):void
		{
			pointA.copyFrom(p1);
			pointB.copyFrom(p2);
			pointC.copyFrom(p3);
		}

		/**
		 * calculateCenter finds the average point of the triangle.
		 *
		 */
		public function calculateCenter():void
		{
			if (center == null)
			{
				center = pointA.clone();
			}
			else
			{
				center.copyFrom(pointA);
			}

			center.addLocal(pointB);
			center.addLocal(pointC);
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
				normal = pointB.clone();
			}
			else
			{
				normal.copyFrom(pointB);
			}
			normal.subtractLocal(pointA);
			normal.crossLocal(pointC.subtract(pointA));
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
			this.pointA.copyFrom(tri.pointA);
			this.pointB.copyFrom(tri.pointB);
			this.pointC.copyFrom(tri.pointC);
		}

		public function clone():Triangle
		{
			return new Triangle(pointA, pointB, pointC);
		}
	}
}

