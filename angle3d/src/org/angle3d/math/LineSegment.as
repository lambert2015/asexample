package org.angle3d.math
{

	/**
	 * <p>LineSegment represents a segment in the space. This is a portion of a Line
	 * that has a limited start and end points.</p>
	 * <p>A LineSegment is defined by an origin, a direction and an extent (or length).
	 * Direction should be a normalized vector. It is not internally normalized.</p>
	 * <p>This public class provides methods to calculate distances between LineSegments, Rays and Vectors.
	 * It is also possible to retrieve both end points of the segment {@link LineSegment#getPositiveEnd(Vector3f)}
	 * and {@link LineSegment#getNegativeEnd(Vector3f)}. There are also methods to check whether
	 * a point is within the segment bounds.</p>
	 *
	 * @see Ray
	 * @author Mark Powell
	 * @author Joshua Slack
	 */
	public class LineSegment
	{
		/**
		 * the origin of the line
		 */
		public var origin:Vector3f;

		/**
		 * the direction of the line
		 */
		public var direction:Vector3f;

		/**
		 * the direction of the line
		 */
		public var extent:Number;

		public function LineSegment(origin:Vector3f = null, direction:Vector3f = null, extent:Number = 1.0)
		{
			this.origin = new Vector3f();
			this.direction = new Vector3f();

			if (origin != null)
			{
				this.origin.copyFrom(origin);
			}

			if (direction != null)
			{
				this.direction.copyFrom(direction);
			}

			this.extent = extent;
		}

		/**
		 * <p>Creates a new LineSegment with a given origin and end. This constructor will calculate the
		 * center, the direction and the extent.</p>
		 */
		public function setStartEnd(start:Vector3f, end:Vector3f):void
		{
			this.origin.x = (start.x + end.x) * 0.5;
			this.origin.y = (start.y + end.y) * 0.5;
			this.origin.z = (start.z + end.z) * 0.5;

			end.subtract(start, this.direction);

			this.extent = direction.length * 0.5;

			this.direction.normalizeLocal();
		}

		public function copyFrom(ls:LineSegment):void
		{
			this.origin.copyFrom(ls.origin);
			this.direction.copyFrom(ls.direction);
			this.extent = ls.extent;
		}

		public function distanceSquared(point:Vector3f):Number
		{
			var compVec1:Vector3f = new Vector3f();

			point.subtract(origin, compVec1);
			var segmentParameter:Number = direction.dot(compVec1);

			if (-extent < segmentParameter)
			{
				if (segmentParameter < extent)
				{
					direction.scale(segmentParameter, compVec1);
					origin.add(compVec1, compVec1);
				}
				else
				{
					direction.scale(extent, compVec1);
					origin.add(compVec1, compVec1);
				}
			}
			else
			{
				direction.scale(extent, compVec1);
				origin.subtract(compVec1, compVec1);
			}


			compVec1.subtractLocal(point);

			var len:Number = compVec1.lengthSquared;

			return len;
		}

		public function distance(point:Vector3f):Number
		{
			return Math.sqrt(distanceSquared(point));
		}

		// P+e*D
		public function getPositiveEnd(store:Vector3f = null):Vector3f
		{
			if (store == null)
			{
				store = new Vector3f();
			}

			direction.scale(extent, store);
			store.addLocal(origin);
			return store;
		}


		// P-e*D
		public function getNegativeEnd(store:Vector3f = null):Vector3f
		{
			if (store == null)
			{
				store = new Vector3f();
			}

			direction.scale(extent, store);
			origin.subtract(store, store);
			return store;
		}

		public function clone():LineSegment
		{
			return new LineSegment(this.origin, this.direction, this.extent);
		}

		/**
		 * <p>Evaluates whether a given point is contained within the axis aligned bounding box
		 * that contains this LineSegment.</p><p>This function accepts an error parameter, which
		 * is added to the extent of the bounding box.</p>
		 */
		public function isPointInsideBounds(point:Vector3f, error:Number = 0.0001):Boolean
		{
			if (FastMath.fabs(point.x - origin.x) > FastMath.fabs(direction.x * extent) + error)
			{
				return false;
			}
			if (FastMath.fabs(point.y - origin.y) > FastMath.fabs(direction.y * extent) + error)
			{
				return false;
			}
			if (FastMath.fabs(point.z - origin.z) > FastMath.fabs(direction.z * extent) + error)
			{
				return false;
			}

			return true;
		}
	}
}

