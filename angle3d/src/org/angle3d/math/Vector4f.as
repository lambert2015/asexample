package org.angle3d.math
{
	import org.angle3d.math.Vector3f;


	/**
	 * <code>Vector4f</code> defines a Vector for a four float value tuple.
	 * <code>Vector4f</code> can represent any four dimensional value, such as a
	 * vertex, a normal, etc. Utility methods are also included to aid in
	 * mathematical calculations.
	 *
	 * @author Maarten Steur
	 */
	public class Vector4f
	{

		/**
		 * the x value of the vector.
		 */
		public var x : Number;

		/**
		 * the y value of the vector.
		 */
		public var y : Number;

		/**
		 * the z value of the vector.
		 */
		public var z : Number;

		/**
		 * the w value of the vector.
		 */
		public var w : Number;

		public function Vector4f(x : Number = 0, y : Number = 0, z : Number = 0, w : Number = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}

		[Inline]
		public final function copyFrom(other : Vector4f) : void
		{
			this.x = other.x;
			this.y = other.y;
			this.z = other.z;
			this.w = other.w;
		}

		/**
		 * <code>set</code> sets the x,y,z,w values of the vector based on passed
		 * parameters.
		 *
		 * @param x
		 *            the x value of the vector.
		 * @param y
		 *            the y value of the vector.
		 * @param z
		 *            the z value of the vector.
		 * @param w
		 *            the w value of the vector.
		 * @return this vector
		 */
		[Inline]
		public final function setTo(x : Number, y : Number, z : Number, w : Number) : void
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}

		/**
		 *
		 * <code>add</code> adds a provided vector to this vector creating a
		 * resultant vector which is returned. If the provided vector is null, null
		 * is returned.
		 *
		 * @param vec
		 *            the vector to add to this.
		 * @return the resultant vector.
		 */
		[Inline]
		public final function add(vec : Vector4f) : Vector4f
		{
			return new Vector4f(x + vec.x, y + vec.y, z + vec.z, w + vec.w);
		}

		[Inline]
		public final function addLocal(vec : Vector4f) : void
		{
			x += vec.x;
			y += vec.y;
			z += vec.z;
			w += vec.w;
		}

		/**
		 *
		 * <code>scaleAdd</code> multiplies this vector by a scalar then adds the
		 * given Vector3f.
		 *
		 * @param scalar
		 *            the value to multiply this vector by.
		 * @param add
		 *            the value to add
		 */
		[Inline]
		public final function scaleAdd(scalar : Number, add : Vector4f) : void
		{
			x = x * scalar + add.x;
			y = y * scalar + add.y;
			z = z * scalar + add.z;
			w = w * scalar + add.w;
		}

		/**
		 *
		 * <code>dot</code> calculates the dot product of this vector with a
		 * provided vector. If the provided vector is null, 0 is returned.
		 *
		 * @param vec
		 *            the vector to dot with this vector.
		 * @return the resultant dot product of this vector and a given vector.
		 */
		[Inline]
		public final function dot(vec : Vector4f) : Number
		{
			return x * vec.x + y * vec.y + z * vec.z + w * vec.w;
		}

		[Inline]
		public final function project(other : Vector4f) : Vector4f
		{
			var n : Number = this.dot(other);
			var d : Number = other.lengthSquared;
			var result : Vector4f = other.clone();
			result.normalize();
			result.scaleLocal(n / d);
			return result;
		}

		/**
		 * Returns true if this vector is a unit vector (length() ~= 1),
		 * returns false otherwise.
		 *
		 * @return true if this vector is a unit vector (length() ~= 1),
		 * or false otherwise.
		 */
		[Inline]
		public final function isUnitVector() : Boolean
		{
			var len : Number = length;
			return 0.99 < len && len < 1.01;
		}

		/**
		 * <code>length</code> calculates the magnitude of this vector.
		 *
		 * @return the length or magnitude of the vector.
		 */
		[Inline]
		public final function get length() : Number
		{
			return Math.sqrt(x * x + y * y + z * z + w * w);
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
			return x * x + y * y + z * z + w * w;
		}

		/**
		 * <code>distanceSquared</code> calculates the distance squared between
		 * this vector and vector v.
		 *
		 * @param v the second vector to determine the distance squared.
		 * @return the distance squared between the two vectors.
		 */
		[Inline]
		public final function distanceSquared(v : Vector4f) : Number
		{
			var dx : Number = x - v.x;
			var dy : Number = y - v.y;
			var dz : Number = z - v.z;
			var dw : Number = w - v.w;
			return (dx * dx + dy * dy + dz * dz + dw * dw);
		}

		/**
		 * <code>distance</code> calculates the distance between
		 * this vector and vector v.
		 *
		 * @param v the second vector to determine the distance.
		 * @return the distance between the two vectors.
		 */
		[Inline]
		public final function distance(v : Vector4f) : Number
		{
			return Math.sqrt(distanceSquared(v));
		}

		[Inline]
		public final function scale(scalar : Number) : Vector4f
		{
			return new Vector4f(x * scalar, y * scalar, z * scalar, w * scalar);
		}

		[Inline]
		public final function scaleLocal(scalar : Number) : void
		{
			x *= scalar;
			y *= scalar;
			z *= scalar;
			w *= scalar;
		}

		[Inline]
		public final function multiply(vec : Vector4f, result : Vector4f = null) : Vector4f
		{
			if (result == null)
			{
				result = new Vector4f();
			}
			result.x = x * vec.x;
			result.y = y * vec.y;
			result.z = z * vec.z;
			result.w = w * vec.w;
			return result;
		}

		[Inline]
		public final function multiplyLocal(vec : Vector4f) : void
		{
			x *= vec.x;
			y *= vec.y;
			z *= vec.z;
			w *= vec.w;
		}

		/**
		 *
		 * <code>negate</code> returns the negative of this vector. All values are
		 * negated and set to a new vector.
		 *
		 * @return the negated vector.
		 */
		[Inline]
		public final function negate() : Vector4f
		{
			return new Vector4f(-x, -y, -z, -w);
		}

		[Inline]
		public final function negateLocal() : void
		{
			x = -x;
			y = -y;
			z = -z;
			w = -w;
		}

		/**
		 *
		 * <code>subtract</code> subtracts the values of a given vector from those
		 * of this vector creating a new vector object. If the provided vector is
		 * null, null is returned.
		 *
		 * @param vec
		 *            the vector to subtract from this vector.
		 * @return the result vector.
		 */
		[Inline]
		public final function subtract(vec : Vector4f) : Vector4f
		{
			return new Vector4f(x - vec.x, y - vec.y, z - vec.z, w - vec.w);
		}

		[Inline]
		public final function decrementBy(vec : Vector4f) : void
		{
			x -= vec.x;
			y -= vec.y;
			z -= vec.z;
			w -= vec.w;
		}

		/**
		 * <code>normalize</code> returns the unit vector of this vector.
		 *
		 * @return unit vector of this vector.
		 */
		public function normalize() : void
		{
			var len : Number = x * x + y * y + z * z + w * w;
			if (len != 1 && len != 0)
			{
				len = 1.0 / Math.sqrt(len);
				x *= len;
				y *= len;
				z *= len;
				w *= len;
			}
		}

		/**
		 * <code>zero</code> resets this vector's data to zero internally.
		 */
		[Inline]
		public final function zero() : void
		{
			x = y = z = w = 0;
		}

		/**
		 * <code>angleBetween</code> returns (in radians) the angle between two vectors.
		 * It is assumed that both this vector and the given vector are unit vectors (iow, normalized).
		 *
		 * @param otherVector a unit vector to find the angle against
		 * @return the angle in radians.
		 */
		[Inline]
		public final function angleBetween(other : Vector4f) : Number
		{
			var dot : Number = this.dot(other);
			var angle : Number = Math.acos(dot);
			return angle;
		}

		[Inline]
		public final function lerp(v1 : Vector4f, v2 : Vector4f, interp : Number) : void
		{
			var t : Number = 1 - interp;
			this.x = t * v1.x + interp * v2.x;
			this.y = t * v1.y + interp * v2.y;
			this.z = t * v1.z + interp * v2.z;
			this.w = t * v1.w + interp * v2.w;
		}

		/**
		 * Check a vector... if it is null or its floats are NaN or infinite,
		 * return false.  Else return true.
		 * @param vector the vector to check
		 * @return true or false as stated above.
		 */
		public static function isValidVector(vector : Vector4f) : Boolean
		{
			if (vector == null)
				return false;

			if (isNaN(vector.x) || isNaN(vector.y) || isNaN(vector.z) || isNaN(vector.w))
				return false;

			if (!isFinite(vector.x) || !isFinite(vector.y) || !isFinite(vector.z) || !isFinite(vector.w))
				return false;

			return true;
		}

		[Inline]
		public final function clone() : Vector4f
		{
			return new Vector4f(x, y, z, w);
		}

		[Inline]
		public final function toVector(arr : Vector.<Number> = null) : Vector.<Number>
		{
			if (arr == null)
			{
				arr = new Vector.<Number>();
			}
			arr[0] = x;
			arr[1] = y;
			arr[2] = z;
			arr[3] = w;
			return arr;
		}

		[Inline]
		public final function toVector3f() : Vector3f
		{
			return new Vector3f(x, y, z);
		}

		public function toString() : String
		{
			return "Vector4f(" + x + ", " + y + ", " + z + ", " + w + ")";
		}
	}
}

