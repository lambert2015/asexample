package org.angle3d.math
{

	/**
	 * <code>Vector2f</code> defines a Vector for a two float value vector.
	 *
	 */
	public class Vector2f
	{
		public static const ZERO : Vector2f = new Vector2f(0, 0);
		public static const UNIT : Vector2f = new Vector2f(1, 1);

		/**
		 * the x value of the vector.
		 */
		public var x : Number;
		/**
		 * the y value of the vector.
		 */
		public var y : Number;

		/**
		 * Creates a Vector2 with the given initial x and y values.
		 *
		 * @param x
		 *            The x value of this Vector2.
		 * @param y
		 *            The y value of this Vector2.
		 */
		public function Vector2f(x : Number = 0, y : Number = 0)
		{
			this.x = x;
			this.y = y;
		}

		[Inline]
		public final function setTo(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
		}

		[Inline]
		public final function copyFrom(other : Vector2f) : void
		{
			this.x = other.x;
			this.y = other.y;
		}

		[Inline]
		public final function add(vec : Vector2f) : Vector2f
		{
			return new Vector2f(x + vec.x, y + vec.y);
		}

		[Inline]
		public final function addLocal(vec : Vector2f) : void
		{
			x += vec.x;
			y += vec.y;
		}

		/**
		 * <code>subtract</code> subtracts the values of a given vector from those
		 * of this vector creating a new vector object. If the provided vector is
		 * null, an exception is thrown.
		 *
		 * @param vec
		 *            the vector to subtract from this vector.
		 * @return the result vector.
		 */
		[Inline]
		public final function subtract(vec : Vector2f, result : Vector2f = null) : Vector2f
		{
			if (result == null)
			{
				result = new Vector2f();
			}
			result.x = x - vec.x;
			result.y = y - vec.y;
			return result;
		}

		[Inline]
		public final function subtractLocal(vec : Vector2f) : void
		{
			x -= vec.x;
			y -= vec.y;
		}

		/**
		 * <code>dot</code> calculates the dot product of this vector with a
		 * provided vector. If the provided vector is null, 0 is returned.
		 *
		 * @param vec
		 *            the vector to dot with this vector.
		 * @return the resultant dot product of this vector and a given vector.
		 */
		[Inline]
		public final function dot(vec : Vector2f) : Number
		{
			return x * vec.x + y * vec.y;
		}

		/**
		 * <code>cross</code> calculates the cross product of this vector with a
		 * parameter vector v.
		 *
		 * @param v
		 *            the vector to take the cross product of with this.
		 * @return the cross product vector.
		 */
		[Inline]
		public final function cross(v : Vector2f) : Vector2f
		{
			return new Vector2f(0, determinant(v));
		}

		[Inline]
		public final function determinant(v : Vector2f) : Number
		{
			return (x * v.y) - (y * v.x);
		}

		[Inline]
		public final function lerp(v1 : Vector2f, v2 : Vector2f, interp : Number) : void
		{
			var t : Number = 1 - interp;
			this.x = t * v1.x + interp * v2.x;
			this.y = t * v1.y + interp * v2.y;
		}

		/**
		 * Check a vector... if it is null or its floats are NaN or infinite, return
		 * false. Else return true.
		 *
		 * @param vector
		 *            the vector to check
		 * @return true or false as stated above.
		 */
		public static function isValidVector(vector : Vector2f) : Boolean
		{
			if (vector == null)
				return false;

			if (isNaN(vector.x) || isNaN(vector.y))
				return false;

			if (!isFinite(vector.x) || !isFinite(vector.y))
				return false;

			return true;
		}

		/**
		 * <code>length</code> calculates the magnitude of this vector.
		 *
		 * @return the length or magnitude of the vector.
		 */
		[Inline]
		public final function get length() : Number
		{
			return Math.sqrt(x * x + y * y);
		}

		/**
		 * <code>lengthSquared</code> calculates the squared value of the
		 * magnitude of the vector.
		 *
		 * @return the magnitude squared of the vector.
		 */
		[Inline]
		public final function get lengthSquared() : Number
		{
			return x * x + y * y;
		}

		/**
		 * <code>distanceSquared</code> calculates the distance squared between
		 * this vector and vector v.
		 *
		 * @param v the second vector to determine the distance squared.
		 * @return the distance squared between the two vectors.
		 */
		[Inline]
		public final function distanceSquared(v : Vector2f) : Number
		{
			var dx : Number = x - v.x;
			var dy : Number = y - v.y;
			return (dx * dx + dy * dy);
		}

		/**
		 * <code>distance</code> calculates the distance between
		 * this vector and vector v.
		 *
		 * @param v the second vector to determine the distance.
		 * @return the distance between the two vectors.
		 */
		[Inline]
		public final function distance(v : Vector2f) : Number
		{
			return Math.sqrt(distanceSquared(v));
		}

		/**
		 * <code>scale</code> multiplies this vector by a scalar. The resultant
		 * vector is returned.
		 *
		 * @param scalar
		 *            the value to multiply this vector by.
		 * @return the new vector.
		 */
		public function scale(scalar : Number, result : Vector2f = null) : Vector2f
		{
			if (null == result)
			{
				result = new Vector2f();
			}
			result.x = x * scalar;
			result.y = y * scalar;
			return result;
		}

		/**
		 * <code>scaleBy</code> multiplies this vector by a scalar internally,
		 * and returns a handle to this vector for easy chaining of calls.
		 *
		 * @param scalar
		 *            the value to multiply this vector by.
		 * @return this
		 */
		[Inline]
		public final function scaleBy(scalar : Number) : void
		{
			x *= scalar;
			y *= scalar;
		}

		[Inline]
		public final function divide(scalar : Number) : Vector2f
		{
			return new Vector2f(x / scalar, y / scalar);
		}

		[Inline]
		public final function divideBy(scalar : Number) : void
		{
			x /= scalar;
			y /= scalar;
		}

		/**
		 * <code>negate</code> returns the negative of this vector. All values are
		 * negated and set to a new vector.
		 *
		 * @return the negated vector.
		 */
		[Inline]
		public final function negate() : Vector2f
		{
			return new Vector2f(-x, -y);
		}

		/**
		 * <code>negateLocal</code> negates the internal values of this vector.
		 *
		 * @return this.
		 */
		[Inline]
		public final function negateLocal() : void
		{
			x = -x;
			y = -y;
		}

		/**
		 * <code>normalize</code> returns the unit vector of this vector.
		 *
		 * @return unit vector of this vector.
		 */
		[Inline]
		public final function normalizeLocal() : void
		{
			var len : Number = length;
			if (len != 0)
			{
				len = 1 / len;
				x *= len;
				y *= len;
			}
		}

		public function getNormalize() : Vector2f
		{
			var result : Vector2f = clone();
			var d : Number = length;
			if (d != 0)
			{
				d = 1 / d;
				result.x = x * d;
				result.y = y * d;
			}
			return result;
		}

		/**
		 * <code>angleBetween</code> returns (in radians) the angle required to
		 * rotate a ray represented by this vector to lie colinear to a ray
		 * described by the given vector. It is assumed that both this vector and
		 * the given vector are unit vectors (iow, normalized).
		 *
		 * @param otherVector
		 *            the "destination" unit vector
		 * @return the angle in radians.
		 */
		[Inline]
		public final function angleBetween(other : Vector2f) : Number
		{
			var angle : Number = Math.atan2(other.y, other.x) - Math.atan2(y, x);
			return angle;
		}

		/**
		 * <code>getAngle</code> returns (in radians) the angle represented by
		 * this Vector2f as expressed by a conversion from rectangular coordinates
		 * to polar coordinates (r,&nbsp;<i>theta</i>).
		 *
		 * @return the angle in radians. [-pi, pi)
		 */
		[Inline]
		public final function getAngle() : Number
		{
			return Math.atan2(y, x);
		}

		public function rotateAroundOrigin(angle : Number, cw : Boolean = false) : void
		{
			if (cw)
				angle = -angle;

			var ang_cos : Number = Math.cos(angle);
			var ang_sin : Number = Math.sin(angle);

			var nx : Number = ang_cos * x - ang_sin * y;
			var ny : Number = ang_sin * x + ang_cos * y;

			x = nx;
			y = ny;
		}

		/**
		 * <code>zero</code> resets this vector's data to zero internally.
		 */
		[Inline]
		public final function zero() : void
		{
			x = y = 0;
		}

		[Inline]
		public final function clone() : Vector2f
		{
			return new Vector2f(x, y);
		}

		public function toVector(vec : Vector.<Number> = null) : Vector.<Number>
		{
			if (vec == null)
			{
				vec = new Vector.<Number>();
			}
			vec[0] = x;
			vec[1] = y;
			return vec;
		}

		/**
		 * <code>toString</code> returns the string representation of this vector
		 * object. The format of the string is such: com.jme.math.Vector2f
		 * [X=XX.XXXX, Y=YY.YYYY]
		 *
		 * @return the string representation of this vector.
		 */
		public function toString() : String
		{
			return "Vector2f(" + x + "," + y + ")";
		}
	}
}

