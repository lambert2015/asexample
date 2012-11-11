package org.angle3d.math
{

	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResult;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.Vector3f;
	import org.angle3d.utils.Assert;


	/**
	 * <code>Ray</code> defines a line segment which has an origin and a direction.
	 * That is, a point and an infinite ray is cast from this point. The ray is
	 * defined by the following equation: R(t) = origin + t*direction for t >= 0.
	 *
	 * @author Mark Powell
	 * @author Joshua Slack
	 */

	public class Ray implements Collidable
	{

		/** The ray's begining point. */
		public var origin:Vector3f;
		/** The direction of the ray. */
		public var direction:Vector3f;

		public var limit:Number;

		/**
		 * Constructor instantiates a new <code>Ray</code> object. The origin and
		 * direction are given.
		 * @param origin the origin of the ray.
		 * @param direction the direction the ray travels in.
		 */
		public function Ray(origin:Vector3f = null, direction:Vector3f = null)
		{
			limit = Number.POSITIVE_INFINITY;

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
		}

		/**
		 * <code>intersectWhere</code> determines if the Ray intersects a triangle
		 * defined by the specified points and if so it stores the point of
		 * intersection in the given loc vector.
		 *
		 * @param v0
		 *            first point of the triangle.
		 * @param v1
		 *            second point of the triangle.
		 * @param v2
		 *            third point of the triangle.
		 * @param loc
		 *            storage vector to save the collision point in (if the ray
		 *            collides)  if null, only boolean is calculated.
		 * @return true if the ray collides.
		 */
		public function intersectWhere(v0:Vector3f, v1:Vector3f, v2:Vector3f, loc:Vector3f):Boolean
		{
			return intersects(v0, v1, v2, loc, false, false);
		}

		/**
		 * <code>intersectWherePlanar</code> determines if the Ray intersects a
		 * triangle defined by the specified points and if so it stores the point of
		 * intersection in the given loc vector as t, u, v where t is the distance
		 * from the origin to the point of intersection and u,v is the intersection
		 * point in terms of the triangle plane.
		 *
		 * @param v0
		 *            first point of the triangle.
		 * @param v1
		 *            second point of the triangle.
		 * @param v2
		 *            third point of the triangle.
		 * @param loc
		 *            storage vector to save the collision point in (if the ray
		 *            collides) as t, u, v
		 * @return true if the ray collides.
		 */
		public function intersectWherePlanar(v0:Vector3f, v1:Vector3f, v2:Vector3f, loc:Vector3f):Boolean
		{
			return intersects(v0, v1, v2, loc, true, false);
		}

		/**
		 * <code>intersects</code> does the actual intersection work.
		 *
		 * @param v0
		 *            first point of the triangle.
		 * @param v1
		 *            second point of the triangle.
		 * @param v2
		 *            third point of the triangle.
		 * @param store
		 *            storage vector - if null, no intersection is calc'd
		 * @param doPlanar
		 *            true if we are calcing planar results.
		 * @param quad
		 * @return true if ray intersects triangle
		 */
		public function intersects(v0:Vector3f, v1:Vector3f, v2:Vector3f, result:Vector3f, doPlanar:Boolean, quad:Boolean):Boolean
		{
			var diff:Vector3f = origin.subtract(v0);
			var edge1:Vector3f = v1.subtract(v0);
			var edge2:Vector3f = v2.subtract(v0);
			var norm:Vector3f = edge1.cross(edge2);

			var dirDotNorm:Number = direction.dot(norm);
			var sign:Number;
			if (dirDotNorm > FastMath.FLT_EPSILON)
			{
				sign = 1;
			}
			else if (dirDotNorm < -FastMath.FLT_EPSILON)
			{
				sign = -1;
				dirDotNorm = -dirDotNorm;
			}
			else
			{
				// ray and triangle/quad are parallel
				return false;
			}

			edge2 = diff.cross(edge2);
			var dirDotDiffxEdge2:Number = sign * direction.dot(edge2);
			if (dirDotDiffxEdge2 >= 0.0)
			{
				edge1.crossLocal(diff);
				var dirDotEdge1xDiff:Number = sign * direction.dot(edge1);

				if (dirDotEdge1xDiff >= 0.0)
				{
					if (!quad ? dirDotDiffxEdge2 + dirDotEdge1xDiff <= dirDotNorm : dirDotEdge1xDiff <= dirDotNorm)
					{
						var diffDotNorm:Number = -sign * diff.dot(norm);
						if (diffDotNorm >= 0.0)
						{
							// ray intersects triangle
							// if storage vector is null, just return true,
							if (result == null)
								return true;

							// else fill in.
							var inv:Number = 1 / dirDotNorm;
							var t:Number = diffDotNorm * inv;
							if (!doPlanar)
							{
								result.copyFrom(origin);
								result.x += direction.x * t;
								result.y += direction.y * t;
								result.z += direction.z * t;
							}
							else
							{
								// these weights can be used to determine
								// interpolated values, such as texture coord.
								// eg. texcoord s,t at intersection point:
								// s = w0*s0 + w1*s1 + w2*s2;
								// t = w0*t0 + w1*t1 + w2*t2;
								var w1:Number = dirDotDiffxEdge2 * inv;
								var w2:Number = dirDotEdge1xDiff * inv;
								//float w0 = 1.0f - w1 - w2;
								result.setTo(t, w1, w2);
							}
							return true;
						}
					}
				}
			}
			return false;
		}

		public function intersects2(v0:Vector3f, v1:Vector3f, v2:Vector3f):Number
		{
			var edge1X:Number = v1.x - v0.x;
			var edge1Y:Number = v1.y - v0.y;
			var edge1Z:Number = v1.z - v0.z;

			var edge2X:Number = v2.x - v0.x;
			var edge2Y:Number = v2.y - v0.y;
			var edge2Z:Number = v2.z - v0.z;

			var normX:Number = ((edge1Y * edge2Z) - (edge1Z * edge2Y));
			var normY:Number = ((edge1Z * edge2X) - (edge1X * edge2Z));
			var normZ:Number = ((edge1X * edge2Y) - (edge1Y * edge2X));

			var dirDotNorm:Number = direction.x * normX + direction.y * normY + direction.z * normZ;

			var diffX:Number = origin.x - v0.x;
			var diffY:Number = origin.y - v0.y;
			var diffZ:Number = origin.z - v0.z;

			var sign:Number;
			if (dirDotNorm > FastMath.FLT_EPSILON)
			{
				sign = 1;
			}
			else if (dirDotNorm < -FastMath.FLT_EPSILON)
			{
				sign = -1;
				dirDotNorm = -dirDotNorm;
			}
			else
			{
				// ray and triangle/quad are parallel
				return Number.POSITIVE_INFINITY;
			}

			var diffEdge2X:Number = ((diffY * edge2Z) - (diffZ * edge2Y));
			var diffEdge2Y:Number = ((diffZ * edge2X) - (diffX * edge2Z));
			var diffEdge2Z:Number = ((diffX * edge2Y) - (diffY * edge2X));

			var dirDotDiffxEdge2:Number = sign * (direction.x * diffEdge2X + direction.y * diffEdge2Y + direction.z * diffEdge2Z);

			if (dirDotDiffxEdge2 >= 0.0)
			{
				diffEdge2X = ((edge1Y * diffZ) - (edge1Z * diffY));
				diffEdge2Y = ((edge1Z * diffX) - (edge1X * diffZ));
				diffEdge2Z = ((edge1X * diffY) - (edge1Y * diffX));

				var dirDotEdge1xDiff:Number = sign * (direction.x * diffEdge2X + direction.y * diffEdge2Y + direction.z * diffEdge2Z);

				if (dirDotEdge1xDiff >= 0.0)
				{
					if (dirDotDiffxEdge2 + dirDotEdge1xDiff <= dirDotNorm)
					{
						var diffDotNorm:Number = -sign * (diffX * normX + diffY * normY + diffZ * normZ);
						if (diffDotNorm >= 0.0)
						{
							// ray intersects triangle
							// fill in.
							var inv:Number = 1 / dirDotNorm;
							var t:Number = diffDotNorm * inv;
							return t;
						}
					}
				}
			}

			return Number.POSITIVE_INFINITY;
		}

		/**
		 * <code>intersectWherePlanar</code> determines if the Ray intersects a
		 * quad defined by the specified points and if so it stores the point of
		 * intersection in the given loc vector as t, u, v where t is the distance
		 * from the origin to the point of intersection and u,v is the intersection
		 * point in terms of the quad plane.
		 * One edge of the quad is [v0,v1], another one [v0,v2]. The behaviour thus is like
		 * {@link #intersectWherePlanar(Vector3f, Vector3f, Vector3f, Vector3f)} except for
		 * the extended area, which is equivalent to the union of the triangles [v0,v1,v2]
		 * and [-v0+v1+v2,v1,v2].
		 *
		 * @param v0
		 *            top left point of the quad.
		 * @param v1
		 *            top right point of the quad.
		 * @param v2
		 *            bottom left point of the quad.
		 * @param loc
		 *            storage vector to save the collision point in (if the ray
		 *            collides) as t, u, v
		 * @return true if the ray collides with the quad.
		 */
		public function intersectWherePlanarQuad(v0:Vector3f, v1:Vector3f, v2:Vector3f, loc:Vector3f):Boolean
		{
			return intersects(v0, v1, v2, loc, true, true);
		}

		/**
		 *
		 * @param p
		 * @param loc
		 * @return true if the ray collides with the given Plane
		 */
		public function intersectsWherePlane(p:Plane, loc:Vector3f):Boolean
		{
			var denominator:Number = p.normal.dot(direction);

			if (denominator > -FastMath.FLT_EPSILON && denominator < FastMath.FLT_EPSILON)
				return false; // coplanar

			var numerator:Number = -(p.normal.dot(origin) - p.constant);
			var ratio:Number = numerator / denominator;

			if (ratio < FastMath.FLT_EPSILON)
				return false; // intersects behind origin

			loc.copyFrom(direction);
			loc.scaleAdd(ratio, origin);
			return true;
		}

		public function collideWith(other:Collidable, results:CollisionResults):int
		{
			if (other is BoundingVolume)
			{
				var bv:BoundingVolume = (other as BoundingVolume);
				return bv.collideWith(this, results);
			}
			else if (other is AbstractTriangle)
			{
				var tri:AbstractTriangle = (other as AbstractTriangle);
				var d:Number = intersects2(tri.getPoint1(), tri.getPoint2(), tri.getPoint3());
				if (isFinite(d) || isNaN(d))
					return 0;

				var point:Vector3f = direction.clone();
				point.scaleAdd(d, origin);

				var cr:CollisionResult = new CollisionResult();
				cr.contactPoint = point;
				cr.distance = d;
				results.addCollision(cr);

				return 1;
			}
			else
			{
				CF::DEBUG
				{
					Assert.assert(false, "Unsupported Collision Object");
				}
				return -1;
			}
		}

		public function distanceSquared(point:Vector3f):Number
		{
			var tempVb:Vector3f = new Vector3f();
			var tempVa:Vector3f = point.subtract(origin);
			var rayParam:Number = direction.dot(tempVa);
			if (rayParam > 0)
			{
				tempVb.copyFrom(direction);
				tempVb.scaleAdd(rayParam, origin);
			}
			else
			{
				tempVb.copyFrom(origin);
				rayParam = 0.0;
			}

			tempVa = tempVb.subtract(point);

			return tempVa.lengthSquared;
		}

		/**
		 *
		 * <code>getOrigin</code> retrieves the origin point of the ray.
		 *
		 * @return the origin of the ray.
		 */
		public function getOrigin():Vector3f
		{
			return origin;
		}

		/**
		 *
		 * <code>setOrigin</code> sets the origin of the ray.
		 * @param origin the origin of the ray.
		 */
		public function setOrigin(origin:Vector3f):void
		{
			this.origin.copyFrom(origin);
		}

		/**
		 * <code>getLimit</code> returns the limit or the ray, aka the length.
		 * If the limit is not infinity, then this ray is a line with length <code>
		 * limit</code>.
		 * @return
		 */
		public function getLimit():Number
		{
			return limit;
		}

		/**
		 * <code>setLimit</code> sets the limit of the ray.
		 * @param limit the limit of the ray.
		 * @see Ray#getLimit()
		 */
		public function setLimit(limit:Number):void
		{
			this.limit = limit;
		}

		/**
		 *
		 * <code>getDirection</code> retrieves the direction vector of the ray.
		 * @return the direction of the ray.
		 */
		public function getDirection():Vector3f
		{
			return direction;
		}

		/**
		 *
		 * <code>setDirection</code> sets the direction vector of the ray.
		 * @param direction the direction of the ray.
		 */
		public function setDirection(direction:Vector3f):void
		{
			this.direction.copyFrom(direction);
		}

		public function copyFrom(source:Ray):void
		{
			origin.copyFrom(source.origin);
			direction.copyFrom(source.direction);
		}

		public function clone():Ray
		{
			return new Ray(origin, direction);
		}
	}
}
