package org.angle3d.bounding
{
	import org.angle3d.math.Vector3f;

	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Plane;
	import org.angle3d.math.PlaneSide;
	import org.angle3d.math.Ray;
	import org.angle3d.math.Transform;
	import org.angle3d.math.Triangle;

	/**
	 * <code>BoundingVolume</code> defines an public interface for dealing with
	 * containment of a collection of points.
	 *
	 */

	public class BoundingVolume implements Collidable
	{
		protected var checkPlane : int;

		public var center : Vector3f;

		public function BoundingVolume(center : Vector3f = null)
		{
			this.checkPlane = 0;
			this.center = new Vector3f();
			if (center != null)
			{
				this.center.copyFrom(center);
			}
		}

		/**
		 * Grabs the checkplane we should check first.
		 *
		 */
		public function getCheckPlane() : int
		{
			return checkPlane;
		}

		/**
		 * Sets the index of the plane that should be first checked during rendering.
		 *
		 * @param value
		 */
		public function setCheckPlane(value : int) : void
		{
			checkPlane = value;
		}

		/**
		 * getType returns the type of bounding volume this is.
		 */
		public function get type() : int
		{
			return BoundingVolumeType.NONE;
		}

		/**
		 *
		 * <code>transform</code> alters the location of the bounding volume by a
		 * rotation, translation and a scalar.
		 *
		 * @param trans
		 *            the transform to affect the bound.
		 * @return the new bounding volume.
		 */
		public function transform(trans : Transform, result : BoundingVolume = null) : BoundingVolume
		{
			return null;
		}

		public function transformByMatrix(trans : Matrix4f, result : BoundingVolume = null) : BoundingVolume
		{
			return null;
		}

		/**
		 *
		 * <code>whichSide</code> returns the side on which the bounding volume
		 * lies on a plane. Possible values are POSITIVE_SIDE, NEGATIVE_SIDE, and
		 * NO_SIDE.
		 *
		 * @param plane
		 *            the plane to check against this bounding volume.
		 * @return the side on which this bounding volume lies.
		 */
		public function whichSide(plane : Plane) : int
		{
			return PlaneSide.None;
		}

		/**
		 *
		 * <code>computeFromPoints</code> generates a bounding volume that
		 * encompasses a collection of points.
		 *
		 * @param points
		 *            the points to contain.
		 */
		public function computeFromPoints(points : Vector.<Number>) : void
		{

		}

		/**
		 * <code>merge</code> combines two bounding volumes into a single bounding
		 * volume that contains both this bounding volume and the parameter volume.
		 *
		 * @param volume
		 *            the volume to combine.
		 * @return the new merged bounding volume.
		 */
		public function merge(volume : BoundingVolume) : BoundingVolume
		{
			return null;
		}

		/**
		 * <code>mergeBy</code> combines two bounding volumes into a single
		 * bounding volume that contains both this bounding volume and the parameter
		 * volume. The result is stored locally.
		 *
		 * @param volume
		 *            the volume to combine.
		 * @return this
		 */
		public function mergeLocal(volume : BoundingVolume) : void
		{

		}

		/**
		 * <code>clone</code> creates a new BoundingVolume object containing the
		 * same data as this one.
		 *
		 * @param store
		 *            where to store the cloned information. if null or wrong public class,
		 *            a new store is created.
		 * @return the new BoundingVolume
		 */
		public function clone(result : BoundingVolume = null) : BoundingVolume
		{
			if (result == null)
			{
				result = new BoundingVolume();
			}

			result.setCenter(this.center);

			return result;
		}

		public function copyFrom(volume : BoundingVolume) : void
		{

		}

		public function getCenter() : Vector3f
		{
			return center;
		}

		public function setCenter(newCenter : Vector3f) : void
		{
			center.copyFrom(newCenter);
		}

		/**
		 * Find the distance from the center of this Bounding Volume to the given
		 * point.
		 *
		 * @param point
		 *            The point to get the distance to
		 * @return distance
		 */
		public function distanceTo(t : Vector3f) : Number
		{
			return center.distance(t);
		}

		/**
		 * Find the squared distance from the center of this Bounding Volume to the
		 * given point.
		 *
		 * @param point
		 *            The point to get the distance to
		 * @return distance
		 */
		public function distanceSquaredTo(t : Vector3f) : Number
		{
			return center.distanceSquared(t);
		}

		/**
		 * Find the distance from the nearest edge of this Bounding Volume to the given
		 * point.
		 *
		 * @param point
		 *            The point to get the distance to
		 * @return distance
		 */
		public function distanceToEdge(point : Vector3f) : Number
		{
			return Number.NEGATIVE_INFINITY;
		}

		/**
		 * determines if this bounding volume and a second given volume are
		 * intersecting. Intersecting being: one volume contains another, one volume
		 * overlaps another or one volume touches another.
		 *
		 * @param bv
		 *            the second volume to test against.
		 * @return true if this volume intersects the given volume.
		 */
		public function intersects(bv : BoundingVolume) : Boolean
		{
			return false;
		}

		/**
		 * determines if a ray intersects this bounding volume.
		 *
		 * @param ray
		 *            the ray to test.
		 * @return true if this volume is intersected by a given ray.
		 */
		public function intersectsRay(ray : Ray) : Boolean
		{
			return false;
		}

		/**
		 * determines if this bounding volume and a given bounding sphere are
		 * intersecting.
		 *
		 * @param bs
		 *            the bounding sphere to test against.
		 * @return true if this volume intersects the given bounding sphere.
		 */
		public function intersectsSphere(bs : BoundingSphere) : Boolean
		{
			return false;
		}

		/**
		 * determines if this bounding volume and a given bounding box are
		 * intersecting.
		 *
		 * @param bb
		 *            the bounding box to test against.
		 * @return true if this volume intersects the given bounding box.
		 */
		public function intersectsBoundingBox(bb : BoundingBox) : Boolean
		{
			return false;
		}

		public function intersectsTriangle(tri : Triangle) : Boolean
		{
			return false;
		}

		/**
		 *
		 * determines if a given point is contained within this bounding volume.
		 * If the point is on the edge of the bounding volume, this method will
		 * return false. Use intersects(Vector3f) to check for edge intersection.
		 *
		 * @param point
		 *            the point to check
		 * @return true if the point lies within this bounding volume.
		 */
		public function contains(point : Vector3f) : Boolean
		{
			return false;
		}

		/**
		 * Determines if a given point intersects (touches or is inside) this bounding volume.
		 * @param point the point to check
		 * @return true if the point lies within this bounding volume.
		 */
		public function intersectsPoint(point : Vector3f) : Boolean
		{
			return false;
		}

		public function getVolume() : Number
		{
			return 0;
		}

		public function collideWith(other : Collidable, results : CollisionResults) : int
		{
			return -1;
		}
	}
}

