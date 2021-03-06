﻿package org.angle3d.math
{
	import org.angle3d.math.Vector3f;

	/**
	 * <code>Plane</code> defines a plane where Normal dot (x,y,z) = Constant.
	 * This provides methods for calculating a "distance" of a point from this
	 * plane. The distance is pseudo due to the fact that it can be negative if the
	 * point is on the non-normal side of the plane.
	 *
	 * @author Mark Powell
	 * @author Joshua Slack
	 */
	public class Plane
	{
		/**
		 * Vector normal to the plane.
		 */
		public var normal:Vector3f;

		/**
		 * Constant of the plane. See formula in public class definition.
		 */
		public var constant:Number;

		/**
		 * Constructor instantiates a new <code>Plane</code> object. The normal
		 * and constant values are set at creation.
		 *
		 * @param normal
		 *            the normal of the plane.
		 * @param constant
		 *            the constant of the plane.
		 */
		public function Plane(normal:Vector3f = null, constant:Number = 0.)
		{
			this.normal = new Vector3f();
			if (normal != null)
			{
				this.normal.copyFrom(normal);
			}
			this.constant = constant;
		}

		/**
		 * <code>setNormal</code> sets the normal of the plane.
		 *
		 * @param normal
		 *            the new normal of the plane.
		 */
		public function setNormal(normal:Vector3f):void
		{
			this.normal.copyFrom(normal);
		}


		/**
		 * <code>setConstant</code> sets the constant value that helps define the
		 * plane.
		 *
		 * @param constant
		 *            the new constant value.
		 */
		public function setConstant(constant:Number):void
		{
			this.constant = constant;
		}

		public function getClosestPoint(point:Vector3f, result:Vector3f = null):Vector3f
		{
			if (result == null)
			{
				result = new Vector3f();
			}
			var t:Number = (constant - normal.dot(point)) / normal.dot(normal);
			result.copyFrom(normal);
			result.scaleAdd(t, point);
			return result;
		}

		public function reflect(point:Vector3f, result:Vector3f = null):Vector3f
		{
			if (result == null)
			{
				result = new Vector3f();
			}

			var d:Number = pseudoDistance(point);
			result.copyFrom(normal);
			result.negate();
			result.scaleAdd(d * 2.0, point);
			return result;
		}

		/**
		* <code>pseudoDistance</code> calculates the distance from this plane to
		* a provided point. If the point is on the negative side of the plane the
		* distance returned is negative, otherwise it is positive. If the point is
		* on the plane, it is zero.
		*
		* @param point
		*            the point to check.
		* @return the signed distance from the plane to a point.
		*/
		public function pseudoDistance(point:Vector3f):Number
		{
			return normal.dot(point) - constant;
		}

		/**
		 * <code>whichSide</code> returns the side at which a point lies on the
		 * plane. The positive values returned are: NEGATIVE_SIDE, POSITIVE_SIDE and
		 * NO_SIDE.
		 *
		 * @param point
		 *            the point to check.
		 * @return the side at which the point lies.
		 */
		public function whichSide(point:Vector3f):int
		{
			var dis:Number = pseudoDistance(point);
			if (dis < 0)
			{
				return PlaneSide.Negative;
			}
			else if (dis > 0)
			{
				return PlaneSide.Positive;
			}
			else
			{
				return PlaneSide.None;
			}
		}

		public function isOnPlane(point:Vector3f):Boolean
		{
			var dist:Number = pseudoDistance(point);
			if (dist < FastMath.FLT_EPSILON && dist > -FastMath.FLT_EPSILON)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		/**
		 * Initialize this plane using the three points of the given triangle.
		 *
		 * @param t
		 *            the triangle
		 */
		public function setTriangle(t:AbstractTriangle):void
		{
			setPoints(t.getPoint1(), t.getPoint2(), t.getPoint3());
		}

		/**
		 * Initialize the Plane using the given 3 points as coplanar.
		 *
		 * @param v1
		 *            the first point
		 * @param v2
		 *            the second point
		 * @param v3
		 *            the third point
		 */
		public function setPoints(v1:Vector3f, v2:Vector3f, v3:Vector3f):void
		{
			normal.copyFrom(v2);
			normal.subtractLocal(v1);

			normal = normal.cross(v3.subtract(v1));
			normal.normalizeLocal();

			constant = normal.dot(v1);
		}

		/**
		 * Initialize this plane using a point of origin and a normal.
		 *
		 * @param origin
		 * @param normal
		 */
		public function setOriginNormal(origin:Vector3f, normal:Vector3f):void
		{
			this.normal.copyFrom(normal);
			this.constant = normal.dot(origin);
		}

		/**
		 * <code>toString</code> returns a string thta represents the string
		 * representation of this plane. It represents the normal as a
		 * <code>Vector3f</code> object, so the format is the following:
		 * com.jme.math.Plane [Normal: org.jme.math.Vector3f [X=XX.XXXX, Y=YY.YYYY,
		 * Z=ZZ.ZZZZ] - Constant: CC.CCCCC]
		 *
		 * @return the string representation of this plane.
		 */
		public function toString():String
		{
			return "Plane[Normal: " + normal + " - Constant: " + constant + "]";
		}

		public function copyFrom(other:Plane):void
		{
			this.normal.copyFrom(other.normal);
			this.constant = other.constant;
		}

		public function clone():Plane
		{
			return new Plane(this.normal, this.constant);
		}
	}
}


