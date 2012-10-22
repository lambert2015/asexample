package org.angle3d.math
{

	import org.angle3d.math.Vector3f;
	import org.angle3d.utils.TempVars;

	/**
	 * <code>Quaternion</code> defines a single example of a more general public class of
	 * hypercomplex numbers. Quaternions extends a rotation in three dimensions to a
	 * rotation in four dimensions. This avoids "gimbal lock" and allows for smooth
	 * continuous rotation.
	 *
	 * <code>Quaternion</code> is defined by four floating point numbers: {x y z
	 * w}.
	 *
	 */
	public class Quaternion
	{
		/**
		 * Represents the identity quaternion rotation (0, 0, 0, 1).
		 */
		public static const IDENTITY:Quaternion = new Quaternion();
		public static const ZERO:Quaternion = new Quaternion(0, 0, 0, 0);

		/**
		 * the x value of the vector.
		 */
		public var x:Number;

		/**
		 * the y value of the vector.
		 */
		public var y:Number;

		/**
		 * the z value of the vector.
		 */
		public var z:Number;

		/**
		 * the w value of the vector.
		 */
		public var w:Number;

		public function Quaternion(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 1)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}

		/**
		 * sets the data in a <code>Quaternion</code> object from the given list
		 * of parameters.
		 *
		 * @param x
		 *            the x value of the quaternion.
		 * @param y
		 *            the y value of the quaternion.
		 * @param z
		 *            the z value of the quaternion.
		 * @param w
		 *            the w value of the quaternion.
		 * @return this
		 */
		[Inline]
		public final function setTo(x:Number, y:Number, z:Number, w:Number):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}

		[Inline]
		public final function copyFrom(q:Quaternion):void
		{
			x = q.x;
			y = q.y;
			z = q.z;
			w = q.w;
		}

		[Inline]
		public final function clone():Quaternion
		{
			return new Quaternion(x, y, z, w);
		}

		/**
		 * builds a Quaternion from the Euler rotation
		 * angles (x,y,z) aka (pitch, yaw, rall)). Note that we are applying in order: roll, yaw, pitch but
		 * we've ordered them in x, y, and z for convenience.
		 * @param xAngle
		 *            the Euler pitch of rotation (in radians). (aka Attitude, often rot
		 *            around x)
		 * @param yAngle
		 *            the Euler yaw of rotation (in radians). (aka Heading, often
		 *            rot around y)
		 * @param zAngle
		 *            the Euler roll of rotation (in radians). (aka Bank, often
		 *            rot around z)
		 * @see <a href="http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/index.htm">http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/index.htm</a>
		 *
		 */
		public function fromAngles(xAngle:Number, yAngle:Number, zAngle:Number):void
		{
			var angle:Number;
			var sinY:Number, sinZ:Number, sinX:Number, cosY:Number, cosZ:Number, cosX:Number;

			angle = zAngle * 0.5;
			sinZ = Math.sin(angle);
			cosZ = Math.cos(angle);
			angle = yAngle * 0.5;
			sinY = Math.sin(angle);
			cosY = Math.cos(angle);
			angle = xAngle * 0.5;
			sinX = Math.sin(angle);
			cosX = Math.cos(angle);

			var cosYXcosZ:Number = cosY * cosZ;
			var sinYXsinZ:Number = sinY * sinZ;
			var cosYXsinZ:Number = cosY * sinZ;
			var sinYXcosZ:Number = sinY * cosZ;

			x = (cosYXcosZ * sinX + sinYXsinZ * cosX);
			y = (sinYXcosZ * cosX + cosYXsinZ * sinX);
			z = (cosYXsinZ * cosX - sinYXcosZ * sinX);
			w = (cosYXcosZ * cosX - sinYXsinZ * sinX);

			normalizeLocal();
		}

		[Inline]
		public final function makeIdentity():void
		{
			x = y = z = 0;
			w = 1;
		}

		/**
		 * @return true if this Quaternion is {0,0,0,1}
		 */
		[Inline]
		public final function isIdentity():Boolean
		{
			return (x == 0 && y == 0 && z == 0 && w == 1);
		}

		/**
		 * <code>toAngles</code> returns this quaternion converted to Euler
		 * rotation angles (yaw,roll,pitch).<br/>
		 * See http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/index.htm
		 *
		 * @param angles
		 *            the float[] in which the angles should be stored, or null if
		 *            you want a new float[] to be created
		 * @return the float[] in which the angles are stored.
		 */
		public function toAngle(result:Vector3f = null):Vector3f
		{
			if (result == null)
				result = new Vector3f();

			var sqw:Number = w * w;
			var sqx:Number = x * x;
			var sqy:Number = y * y;
			var sqz:Number = z * z;
			var unit:Number = sqx + sqy + sqz + sqw; // if normalized is one, otherwise
			// is correction factor
			var test:Number = x * y + z * w;
			if (test > 0.499 * unit) // singularity at north pole
			{
				result.y = 2 * Math.atan2(x, w);
				result.z = FastMath.HALF_PI;
				result.x = 0;
			}
			else if (test < -0.499 * unit) // singularity at south pole
			{
				result.y = -2 * Math.atan2(x, w);
				result.z = -FastMath.HALF_PI;
				result.x = 0;
			}
			else
			{
				result.y = Math.atan2(2 * y * w - 2 * x * z, sqx - sqy - sqz + sqw); // roll or heading 
				result.z = Math.asin(2 * test / unit); // pitch or attitude
				result.x = Math.atan2(2 * x * w - 2 * y * z, -sqx + sqy - sqz + sqw); // yaw or bank
			}
			return result;
		}

		/**
		 * <code>toAngles</code> returns this quaternion converted to Euler
		 * rotation angles (yaw,roll,pitch).<br/>
		 * See http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/index.htm
		 *
		 * @param angles
		 *            the float[] in which the angles should be stored, or null if
		 *            you want a new float[] to be created
		 * @return the float[] in which the angles are stored.
		 */
		public function toAngles(result:Vector.<Number> = null):Vector.<Number>
		{
			if (result == null)
				result = new Vector.<Number>();

			var sqw:Number = w * w;
			var sqx:Number = x * x;
			var sqy:Number = y * y;
			var sqz:Number = z * z;
			var unit:Number = sqx + sqy + sqz + sqw; // if normalized is one, otherwise
			// is correction factor
			var test:Number = x * y + z * w;
			if (test > 0.499 * unit) // singularity at north pole
			{
				result[1] = 2 * Math.atan2(x, w);
				result[2] = FastMath.HALF_PI;
				result[0] = 0;
			}
			else if (test < -0.499 * unit) // singularity at south pole
			{
				result[1] = -2 * Math.atan2(x, w);
				result[2] = -FastMath.HALF_PI;
				result[0] = 0;
			}
			else
			{
				result[1] = Math.atan2(2 * y * w - 2 * x * z, sqx - sqy - sqz + sqw); // roll or heading 
				result[2] = Math.asin(2 * test / unit); // pitch or attitude
				result[0] = Math.atan2(2 * x * w - 2 * y * z, -sqx + sqy - sqz + sqw); // yaw or bank
			}
			return result;
		}

		/**
		 *
		 * <code>fromRotationMatrix</code> generates a quaternion from a supplied
		 * matrix. This matrix is assumed to be a rotational matrix.
		 *
		 * @param matrix
		 *            the matrix that defines the rotation.
		 */
		public function fromMatrix3f(mat:Matrix3f):void
		{
			var s:Number;

			// Use the Graphics Gems code, from 
			// ftp://ftp.cis.upenn.edu/pub/graphics/shoemake/quatut.ps.Z
			// *NOT* the "Matrix and Quaternions FAQ", which has errors!

			// the trace is the sum of the diagonal elements; see
			// http://mathworld.wolfram.com/MatrixTrace.html
			var t:Number = mat.m00 + mat.m11 + mat.m22;

			// we protect the division by s by ensuring that s>=1
			if (t >= 0) // |w| >= .5
			{
				s = Math.sqrt(t + 1); // |s|>=1 ...
				w = 0.5 * s;
				s = 0.5 / s; // so this division isn't bad
				x = (mat.m21 - mat.m12) * s;
				y = (mat.m02 - mat.m20) * s;
				z = (mat.m10 - mat.m01) * s;
			}
			else if ((mat.m00 > mat.m11) && (mat.m00 > mat.m22))
			{
				s = Math.sqrt(1.0 + mat.m00 - mat.m11 - mat.m22); // |s|>=1
				x = s * 0.5; // |x| >= .5
				s = 0.5 / s;
				y = (mat.m10 + mat.m01) * s;
				z = (mat.m02 + mat.m20) * s;
				w = (mat.m21 - mat.m12) * s;
			}
			else if (mat.m11 > mat.m22)
			{
				s = Math.sqrt(1.0 + mat.m11 - mat.m00 - mat.m22); // |s|>=1
				y = s * 0.5; // |y| >= .5
				s = 0.5 / s;
				x = (mat.m10 + mat.m01) * s;
				z = (mat.m21 + mat.m12) * s;
				w = (mat.m02 - mat.m20) * s;
			}
			else
			{
				s = Math.sqrt(1.0 + mat.m22 - mat.m00 - mat.m11); // |s|>=1
				z = s * 0.5; // |z| >= .5
				s = 0.5 / s;
				x = (mat.m02 + mat.m20) * s;
				y = (mat.m21 + mat.m12) * s;
				w = (mat.m10 - mat.m01) * s;
			}
		}

		public function fromMatrix4f(mat:Matrix4f):void
		{
			var s:Number;

			// Use the Graphics Gems code, from 
			// ftp://ftp.cis.upenn.edu/pub/graphics/shoemake/quatut.ps.Z
			// *NOT* the "Matrix and Quaternions FAQ", which has errors!

			// the trace is the sum of the diagonal elements; see
			// http://mathworld.wolfram.com/MatrixTrace.html
			var t:Number = mat.m00 + mat.m11 + mat.m22;

			// we protect the division by s by ensuring that s>=1
			if (t >= 0) // |w| >= .5
			{
				s = Math.sqrt(t + 1); // |s|>=1 ...
				w = 0.5 * s;
				s = 0.5 / s; // so this division isn't bad
				x = (mat.m21 - mat.m12) * s;
				y = (mat.m02 - mat.m20) * s;
				z = (mat.m10 - mat.m01) * s;
			}
			else if ((mat.m00 > mat.m11) && (mat.m00 > mat.m22))
			{
				s = Math.sqrt(1.0 + mat.m00 - mat.m11 - mat.m22); // |s|>=1
				x = s * 0.5; // |x| >= .5
				s = 0.5 / s;
				y = (mat.m10 + mat.m01) * s;
				z = (mat.m02 + mat.m20) * s;
				w = (mat.m21 - mat.m12) * s;
			}
			else if (mat.m11 > mat.m22)
			{
				s = Math.sqrt(1.0 + mat.m11 - mat.m00 - mat.m22); // |s|>=1
				y = s * 0.5; // |y| >= .5
				s = 0.5 / s;
				x = (mat.m10 + mat.m01) * s;
				z = (mat.m21 + mat.m12) * s;
				w = (mat.m02 - mat.m20) * s;
			}
			else
			{
				s = Math.sqrt(1.0 + mat.m22 - mat.m00 - mat.m11); // |s|>=1
				z = s * 0.5; // |z| >= .5
				s = 0.5 / s;
				x = (mat.m02 + mat.m20) * s;
				y = (mat.m21 + mat.m12) * s;
				w = (mat.m10 - mat.m01) * s;
			}
		}

		/**
		 * converts this quaternion to a rotational
		 * matrix. The result is stored in result.
		 *
		 * @param result
		 *            The Matrix3f to store the result in.
		 * @return the rotation matrix representation of this quaternion.
		 */
		public function toMatrix3f(result:Matrix3f = null):Matrix3f
		{
			if (result == null)
				result = new Matrix3f();

			var norm:Number = x * x + y * y + z * z + w * w;

			// we explicitly test norm against one here, saving a division
			// at the cost of a test and branch.  Is it worth it?
			var s:Number = (norm == 1) ? 2 : ((norm > 0) ? 2 / norm : 0);

			// compute xs/ys/zs first to save 6 multiplications, since xs/ys/zs
			// will be used 2-4 times each.
			var xs:Number = x * s;
			var ys:Number = y * s;
			var zs:Number = z * s;
			var xx:Number = x * xs;
			var xy:Number = x * ys;
			var xz:Number = x * zs;
			var xw:Number = w * xs;
			var yy:Number = y * ys;
			var yz:Number = y * zs;
			var yw:Number = w * ys;
			var zz:Number = z * zs;
			var zw:Number = w * zs;

			// using s=2/norm (instead of 1/norm) saves 9 multiplications by 2 here
			result.m00 = 1 - (yy + zz);
			result.m01 = (xy - zw);
			result.m02 = (xz + yw);
			result.m10 = (xy + zw);
			result.m11 = 1 - (xx + zz);
			result.m12 = (yz - xw);
			result.m20 = (xz - yw);
			result.m21 = (yz + xw);
			result.m22 = 1 - (xx + yy);

			return result;
		}

		public function toMatrix4f(result:Matrix4f = null):Matrix4f
		{
			if (result == null)
				result = new Matrix4f();

			var norm:Number = x * x + y * y + z * z + w * w;
			// we explicitly test norm against one here, saving a division
			// at the cost of a test and branch.  Is it worth it?
			var s:Number = (norm == 1) ? 2 : ((norm > 0) ? 2 / norm : 0);

			// compute xs/ys/zs first to save 6 multiplications, since xs/ys/zs
			// will be used 2-4 times each.
			var xs:Number = x * s;
			var ys:Number = y * s;
			var zs:Number = z * s;
			var xx:Number = x * xs;
			var xy:Number = x * ys;
			var xz:Number = x * zs;
			var xw:Number = w * xs;
			var yy:Number = y * ys;
			var yz:Number = y * zs;
			var yw:Number = w * ys;
			var zz:Number = z * zs;
			var zw:Number = w * zs;

			// using s=2/norm (instead of 1/norm) saves 9 multiplications by 2 here
			result.m00 = 1 - (yy + zz);
			result.m01 = (xy - zw);
			result.m02 = (xz + yw);
			result.m10 = (xy + zw);
			result.m11 = 1 - (xx + zz);
			result.m12 = (yz - xw);
			result.m20 = (xz - yw);
			result.m21 = (yz + xw);
			result.m22 = 1 - (xx + yy);

			return result;
		}

		/**
		 * <code>getRotationColumn</code> returns one of three columns specified
		 * by the parameter. This column is returned as a <code>Vector3f</code>
		 * object.  The value is retrieved as if this quaternion was first normalized.
		 *
		 * @param i
		 *            the column to retrieve. Must be between 0 and 2.
		 * @param store
		 *            the vector object to store the result in. if null, a new one
		 *            is created.
		 * @return the column specified by the index.
		 */
		public function getRotationColumn(i:int, result:Vector3f = null):Vector3f
		{
			if (result == null)
				result = new Vector3f();

			var norm:Number = x * x + y * y + z * z + w * w;
			if (norm != 1.0)
			{
				norm = 1 / Math.sqrt(norm);
			}

			var xx:Number = x * x * norm;
			var xy:Number = x * y * norm;
			var xz:Number = x * z * norm;
			var xw:Number = x * w * norm;
			var yy:Number = y * y * norm;
			var yz:Number = y * z * norm;
			var yw:Number = y * w * norm;
			var zz:Number = z * z * norm;
			var zw:Number = z * w * norm;

			switch (i)
			{
				case 0:
					result.x = 1 - 2 * (yy + zz);
					result.y = 2 * (xy + zw);
					result.z = 2 * (xz - yw);
					break;
				case 1:
					result.x = 2 * (xy - zw);
					result.y = 1 - 2 * (xx + zz);
					result.z = 2 * (yz + xw);
					break;
				case 2:
					result.x = 2 * (xz + yw);
					result.y = 2 * (yz - xw);
					result.z = 1 - 2 * (xx + yy);
					break;
				default:
					throw new Error("Invalid column index. " + i);
					break;
			}

			return result;
		}

		/**
		 * sets this quaternion to the values
		 * specified by an angle and a normalized axis of rotation.
		 *
		 * @param angle
		 *            the angle to rotate (in radians).
		 * @param axis
		 *            the axis of rotation (already normalized).
		 */
		public function fromAngleAxis(angle:Number, axis:Vector3f):void
		{
			if (axis.x == 0 && axis.y == 0 && axis.z == 0)
			{
				makeIdentity();
			}
			else
			{
				var halfAngle:Number = 0.5 * angle;
				var sinAngle:Number = Math.sin(halfAngle);
				x = sinAngle * axis.x;
				y = sinAngle * axis.y;
				z = sinAngle * axis.z;
				w = Math.cos(halfAngle);
			}
		}

		/**
		 * <code>toAngleAxis</code> sets a given angle and axis to that
		 * represented by the current quaternion. The values are stored as
		 * following: The axis is provided as a parameter and built by the method,
		 * the angle is returned as a float.
		 *
		 * @param axisStore
		 *            the object we'll store the computed axis in.
		 * @return the angle of rotation in radians.
		 */
		public function toAngleAxis(result:Vector3f = null):Number
		{
			var sqrLength:Number = x * x + y * y + z * z;
			var angle:Number;
			if (sqrLength == 0.0)
			{
				angle = 0;
				if (result != null)
				{
					result.x = 1.0;
					result.y = 0.0;
					result.z = 0.0;
				}
			}
			else
			{
				angle = 2.0 * Math.acos(w);
				if (result != null)
				{
					var invLength:Number = 1.0 / Math.sqrt(sqrLength);
					result.x = x * invLength;
					result.y = y * invLength;
					result.z = z * invLength;
				}
			}
			return angle;
		}

		/**
		 * sets this quaternion's value as an interpolation
		 * between two other quaternions.
		 *
		 * @param q1
		 *            the first quaternion.
		 * @param q2
		 *            the second quaternion.
		 * @param t
		 *            the amount to interpolate between the two quaternions.
		 */
		/**
		 * A general equation for 'slerping' unit vectors in N dimensions is:
		 * (sin((1-t)a)v1+sin(ta)v2)/sin(a)
		 * Where v1 and v2 are the vectors you're interpolating, 'a' is the angle between them,
		 * and t is the parametric value.
		 * You'll notice that the equation fails when the angle is 0 or pi. If near 0,
		 * the vectors are presumably close enough that lerp or nlerp will give acceptable results.
		 * If near pi, there isn't a unique solution, and you have a special case to consider.
		 * We can use the same equation for unit-length quaternions if we consider them as points
		 * on the 4d unit hypersphere. An adjustment that is often made is to negate one of the
		 * quaternions if the dot product between them is negative.
		 * This is because q and -q represent the same rotation,
		 * and if q1.q2 < 0, negating one of them will cause slerp to take a shorter path,
		 * which is usually desirable. (Note that this also avoids the special case of q1 = -q2.)
		 * Here's an implementation:
		 * template <class T> Quaternion<T> Quaternion<T>::Slerp(const Quaternion<T>& q1, const Quaternion<T>& q2, T t, T epsilon)
		 * {
		 *     if (t <= (T)0.0)
		 *         return q1;
		 *     if (t >= (T)1.0)
		 *        return q2;
		 *
		 *     Quaternion<T> q3 = q2;
		 *     T c = q1.Dot(q3);
		 *
		 *     if (c < (T)0.0)
		 *     {
		 *         q3 = -q3;
		 *         c = -c;
		 *     }
		 *
		 *     if (c > (T)1.0 - epsilon)
		 *         return Normalize(Lerp(q1, q3, t)); // Lerp() = q1 + t * (q2 - q1)
		 *
		 *     T a = Math<T>::ACos©; // ACos() clamps input to [-1, 1]
		 *     return (Math<T>::Sin(((T)1.0 - t) * a) * q1 + Math<T>::Sin(t * a) * q3) / Math<T>::Sin(a);
		 * }
		 *
		 */
		public function slerp(q1:Quaternion, q2:Quaternion, interp:Number, epsilon:Number = 0.05):void
		{
			if (interp <= 0 || q1.equals(q2))
			{
				copyFrom(q1);
				return;
			}
			else if (interp >= 1)
			{
				copyFrom(q2);
				return;
			}


			var q1x:Number = q1.x, q1y:Number = q1.y, q1z:Number = q1.z, q1w:Number = q1.w;
			var q2x:Number = q2.x, q2y:Number = q2.y, q2z:Number = q2.z, q2w:Number = q2.w;

			//var result : Number = q1.dot(q2);
			var result:Number = q1x * q2x + q1y * q2y + q1z * q2z + q1w * q2w;
			if (result < 0.0)
			{
				// Negate the second quaternion and the result of the dot product
				q2x = -q2x;
				q2y = -q2y;
				q2z = -q2z;
				q2w = -q2w;
				result = -result;
			}

			// Set the first and second scale for the interpolation
			var scale0:Number = 1 - interp;
			var scale1:Number = interp;

			// Check if the angle between the 2 quaternions was big enough to
			// warrant such calculations
			if (result < 1.0 - epsilon) // Get the angle between the 2 quaternions,
			{
				// and then store the sin() of that angle
				var theta:Number = Math.acos(result);
				var invSinTheta:Number = 1.0 / Math.sin(theta);

				var interpTheta:Number = interp * theta;

				// Calculate the scale for q1 and q2, according to the angle and
				// it's sine value
				scale0 = Math.sin(theta - interpTheta) * invSinTheta;
				scale1 = Math.sin(interpTheta) * invSinTheta;
			}

			// Calculate the x, y, z and w values for the quaternion by using a special
			// form of linear interpolation for quaternions.
			this.x = (scale0 * q1x) + (scale1 * q2x);
			this.y = (scale0 * q1y) + (scale1 * q2y);
			this.z = (scale0 * q1z) + (scale1 * q2z);
			this.w = (scale0 * q1w) + (scale1 * q2w);
		}

		/**
		 * Sets the values of this quaternion to the nlerp from itself to q2 by blend.
		 * @param q1
		 * @param q2
		 * @param blend
		 */
		public function nlerp(q1:Quaternion, q2:Quaternion, blend:Number):void
		{
			var blendI:Number = 1.0 - blend;
			if (q1.dot(q2) < 0.0)
			{
				blend = -blend;
			}

			x = blendI * q1.x + blend * q2.x;
			y = blendI * q1.y + blend * q2.y;
			z = blendI * q1.z + blend * q2.z;
			w = blendI * q1.w + blend * q2.w;

			normalizeLocal();
		}

		/**
		 * <code>add</code> adds the values of this quaternion to those of the
		 * parameter quaternion. The result is returned as a new quaternion.
		 *
		 * @param q
		 *            the quaternion to add to this.
		 * @return the new quaternion.
		 */
		[Inline]
		public final function add(q:Quaternion):Quaternion
		{
			return new Quaternion(x + q.x, y + q.y, z + q.z, w + q.w);
		}

		/**
		 * <code>add</code> adds the values of this quaternion to those of the
		 * parameter quaternion. The result is stored in this Quaternion.
		 *
		 * @param q
		 *            the quaternion to add to this.
		 * @return This Quaternion after addition.
		 */
		[Inline]
		public final function addLocal(q:Quaternion):void
		{
			this.x += q.x;
			this.y += q.y;
			this.z += q.z;
			this.w += q.w;
		}

		/**
		 * <code>subtract</code> subtracts the values of the parameter quaternion
		 * from those of this quaternion. The result is returned as a new
		 * quaternion.
		 *
		 * @param q
		 *            the quaternion to subtract from this.
		 * @return the new quaternion.
		 */
		[Inline]
		public final function subtract(q:Quaternion):Quaternion
		{
			return new Quaternion(x - q.x, y - q.y, z - q.z, w - q.w);
		}

		/**
		 * <code>subtract</code> subtracts the values of the parameter quaternion
		 * from those of this quaternion. The result is stored in this Quaternion.
		 *
		 * @param q
		 *            the quaternion to subtract from this.
		 * @return This Quaternion after subtraction.
		 */
		[Inline]
		public final function subtractLocal(q:Quaternion):void
		{
			this.x -= q.x;
			this.y -= q.y;
			this.z -= q.z;
			this.w -= q.w;
		}

		/**
		 * <code>mult</code> multiplies this quaternion by a parameter quaternion.
		 * The result is returned as a new quaternion. It should be noted that
		 * quaternion multiplication is not commutative so q * p != p * q.
		 *
		 * @param q   the quaternion to multiply this quaternion by.
		 * @param res the quaternion to store the result in.
		 * @return the new quaternion.
		 */
		/**
		 * 注意：四元数相乘不符合乘法交换律  q * p != p * q
		 */
		public function multiply(q:Quaternion, result:Quaternion = null):Quaternion
		{
			if (result == null)
			{
				result = new Quaternion();
			}

			var tw:Number = w, tx:Number = x, ty:Number = y, tz:Number = z;
			var qw:Number = q.w, qx:Number = q.x, qy:Number = q.y, qz:Number = q.z;

			result.x = tx * qw + ty * qz - tz * qy + tw * qx;
			result.y = -tx * qz + ty * qw + tz * qx + tw * qy;
			result.z = tx * qy - ty * qx + tz * qw + tw * qz;
			result.w = -tx * qx - ty * qy - tz * qz + tw * qw;
			return result;
		}

		public function multiplyLocal(q:Quaternion):void
		{
			var tw:Number = w, tx:Number = x, ty:Number = y, tz:Number = z;
			var qw:Number = q.w, qx:Number = q.x, qy:Number = q.y, qz:Number = q.z;

			x = tx * qw + ty * qz - tz * qy + tw * qx;
			y = -tx * qz + ty * qw + tz * qx + tw * qy;
			z = tx * qy - ty * qx + tz * qw + tw * qz;
			w = -tx * qx - ty * qy - tz * qz + tw * qw;
		}

		/**
		 * <code>apply</code> multiplies this quaternion by a parameter matrix
		 * internally.
		 *
		 * @param matrix
		 *            the matrix to apply to this quaternion.
		 */
		public function apply(matrix:Matrix3f):void
		{
			var oldX:Number = x, oldY:Number = y, oldZ:Number = z, oldW:Number = w;
			fromMatrix3f(matrix);
			var tempX:Number = x, tempY:Number = y, tempZ:Number = z, tempW:Number = w;

			x = oldX * tempW + oldY * tempZ - oldZ * tempY + oldW * tempX;
			y = -oldX * tempZ + oldY * tempW + oldZ * tempX + oldW * tempY;
			z = oldX * tempY - oldY * tempX + oldZ * tempW + oldW * tempZ;
			w = -oldX * tempX - oldY * tempY - oldZ * tempZ + oldW * tempW;
		}

		/**
		 *
		 * <code>fromAxes</code> creates a <code>Quaternion</code> that
		 * represents the coordinate system defined by three axes. These axes are
		 * assumed to be orthogonal and no error checking is applied. Thus, the user
		 * must insure that the three axes being provided indeed represents a proper
		 * right handed coordinate system.
		 *
		 * @param xAxis vector representing the x-axis of the coordinate system.
		 * @param yAxis vector representing the y-axis of the coordinate system.
		 * @param zAxis vector representing the z-axis of the coordinate system.
		 */
		public function fromAxes(xAxis:Vector3f, yAxis:Vector3f, zAxis:Vector3f):void
		{
			var m:Matrix3f = new Matrix3f();
			m.m00 = xAxis.x; 
			m.m01 = yAxis.x; 
			m.m02 = zAxis.x; 
			m.m10 = xAxis.y; 
			m.m11 = yAxis.y; 
			m.m12 = zAxis.y; 
			m.m20 = xAxis.z; 
			m.m21 = yAxis.z; 
			m.m22 = zAxis.z;
			fromMatrix3f(m);
		}

		/**
		 *
		 * <code>toAxes</code> takes in an array of three vectors. Each vector
		 * corresponds to an axis of the coordinate system defined by the quaternion
		 * rotation.
		 *
		 * @param axis
		 *            the array of vectors to be filled.
		 */
		public function toAxes(axis:Vector.<Vector3f>):void
		{
			var tempMat:Matrix3f = toMatrix3f();
			axis[0] = tempMat.copyColumnTo(0, axis[0]);
			axis[1] = tempMat.copyColumnTo(1, axis[1]);
			axis[2] = tempMat.copyColumnTo(2, axis[2]);
		}

		/**
		 * <code>mult</code> multiplies this quaternion by a parameter vector. The
		 * result is stored in the supplied vector
		 *
		 * @param v
		 *            the vector to multiply this quaternion by.
		 * @return v
		 */
		/**
		 * nVidia SDK implementation
		 * Vector3 uv, uuv;
		 * Vector3 qvec(x, y, z);
		 * uv = qvec.crossProduct(v);
		 * uuv = qvec.crossProduct(uv);
		 * uv *= (2.0f * w);
		 * uuv *= 2.0f;
		 * return v + uv + uuv;
		 */
		public function multiplyVector(v:Vector3f, result:Vector3f = null):Vector3f
		{
			if (result == null)
				result = new Vector3f();

			var vx:Number = v.x, vy:Number = v.y, vz:Number = v.z;

			var xx:Number = x * x;
			var yy:Number = y * y;
			var zz:Number = z * z;
			var ww:Number = w * w;

			var x2:Number = x * 2;
			var y2:Number = y * 2;
			var z2:Number = z * 2;
			var w2:Number = w * 2;

			var tempX:Number, tempY:Number;
			tempX = ww * vx + y2 * w * vz - z2 * w * vy + xx * vx + y2 * x * vy + z2 * x * vz - zz * vx - yy * vx;
			tempY = x2 * y * vx + yy * vy + z2 * y * vz + w2 * z * vx - zz * vy + ww * vy - x2 * w * vz - xx * vy;
			result.z = x2 * z * vx + y2 * z * vy + zz * vz - w2 * y * vx - yy * vz + w2 * x * vy - xx * vz + ww * vz;
			result.x = tempX;
			result.y = tempY;

			return result;
		}

		//TODO 优化
		public function multVecLocal(vec:Vector3f):void
		{
			var vx:Number = vec.x, vy:Number = vec.y, vz:Number = vec.z;

			var xx:Number = x * x;
			var yy:Number = y * y;
			var zz:Number = z * z;
			var ww:Number = w * w;

			var x2:Number = x * 2;
			var y2:Number = y * 2;
			var z2:Number = z * 2;
			var w2:Number = w * 2;

			var tempX:Number, tempY:Number;
			tempX = ww * vx + y2 * w * vz - z2 * w * vy + xx * vx + y2 * x * vy + z2 * x * vz - zz * vx - yy * vx;
			tempY = x2 * y * vx + yy * vy + z2 * y * vz + w2 * z * vx - zz * vy + ww * vy - x2 * w * vz - xx * vy;
			vec.z = x2 * z * vx + y2 * z * vy + zz * vz - w2 * y * vx - yy * vz + w2 * x * vy - xx * vz + ww * vz;
			vec.x = tempX;
			vec.y = tempY;
		}

		/**
		 * <code>mult</code> multiplies this quaternion by a parameter scalar. The
		 * result is returned as a new quaternion.
		 *
		 * @param scalar
		 *            the quaternion to multiply this quaternion by.
		 * @return the new quaternion.
		 */
		public function scale(value:Number):Quaternion
		{
			return new Quaternion(value * x, value * y, value * z, value * w);
		}

		/**
		 * <code>mult</code> multiplies this quaternion by a parameter scalar. The
		 * result is stored locally.
		 *
		 * @param scalar
		 *            the quaternion to multiply this quaternion by.
		 * @return this.
		 */
		[Inline]
		public final function scaleLocal(value:Number):void
		{
			x *= value;
			y *= value;
			z *= value;
			w *= value;
		}

		/**
		 * <code>dot</code> calculates and returns the dot product of this
		 * quaternion with that of the parameter quaternion.
		 *
		 * @param q
		 *            the quaternion to calculate the dot product of.
		 * @return the dot product of this and the parameter quaternion.
		 */
		[Inline]
		public final function dot(q:Quaternion):Number
		{
			return x * q.x + y * q.y + z * q.z + w * q.w;
		}

		/**
		 * <code>norm</code> returns the norm of this quaternion. This is the dot
		 * product of this quaternion with itself.
		 *
		 * @return the norm of the quaternion.
		 */
		[Inline]
		public final function getNorm():Number
		{
			return x * x + y * y + z * z + w * w;
		}

		/**
		 * <code>normalize</code> normalizes the current <code>Quaternion</code>
		 */
		public function normalizeLocal():Quaternion
		{
			var norm:Number = x * x + y * y + z * z + w * w;
			if (norm == 0)
			{
				x = y = z = w = 0.0;
			}
			else
			{
				norm = 1 / Math.sqrt(norm);
				x *= norm;
				y *= norm;
				z *= norm;
				w *= norm;
			}

			return this;
		}

		[Inline]
		public final function zero():void
		{
			x = y = z = w = 0;
		}

		/**
		 * <code>inverse</code> returns the inverse of this quaternion as a new
		 * quaternion. If this quaternion does not have an inverse (if its normal is
		 * 0 or less), then null is returned.
		 *
		 * @return the inverse of this quaternion or null if the inverse does not
		 *         exist.
		 */
		public function inverse():Quaternion
		{
			var norm:Number = x * x + y * y + z * z + w * w;
			if (norm > 0.0)
			{
				var invNorm:Number = 1.0 / norm;
				return new Quaternion(-x * invNorm, -y * invNorm, -z * invNorm, w * invNorm);
			}
			// return an invalid result to flag the error
			return null;
		}

		/**
		 * 假设已经归一化
		 */
		[Inline]
		public final function unitInverse():Quaternion
		{
			return new Quaternion(-x, -y, -z, w);
		}

		/**
		 * <code>inverse</code> calculates the inverse of this quaternion and
		 * returns this quaternion after it is calculated. If this quaternion does
		 * not have an inverse (if it's norma is 0 or less), nothing happens
		 *
		 * @return the inverse of this quaternion
		 */
		public function inverseLocal():void
		{
			var norm:Number = x * x + y * y + z * z + w * w;
			if (norm > 0.0)
			{
				norm = 1.0 / norm;
				x *= -norm;
				y *= -norm;
				z *= -norm;
				w *= norm;
			}
		}

		/**
		 * 假设已经归一化
		 */
		[Inline]
		public final function uintInverseLocal():void
		{
			x = -x;
			y = -y;
			z = -z;
		}

		/**
		 * <code>negate</code> inverts the values of the quaternion.
		 *
		 */
		[Inline]
		public final function negate():void
		{
			x *= -1;
			y *= -1;
			z *= -1;
			w *= -1;
		}

		/**
		 * <code>lookAt</code> is a convienence method for auto-setting the
		 * quaternion based on a direction and an up vector. It computes
		 * the rotation to transform the z-axis to point into 'direction'
		 * and the y-axis to 'up'.
		 *
		 * @param direction
		 *            where to look at in terms of local coordinates
		 * @param up
		 *            a vector indicating the local up direction.
		 *            (typically {0, 1, 0} in jME.)
		 */
		public function lookAt(direction:Vector3f, up:Vector3f):void
		{
			var tVars:TempVars = TempVars.getTempVars();

			tVars.vect3.copyFrom(direction).normalizeLocal();
			tVars.vect1.copyFrom(up).crossLocal(direction).normalizeLocal();
			tVars.vect2.copyFrom(direction).crossLocal(tVars.vect1).normalizeLocal();
			fromAxes(tVars.vect1, tVars.vect2, tVars.vect3);

			tVars.release();

			//var v1:Vector3f = direction.clone().normalizeLocal();
			//var v2:Vector3f = up.cross(direction).normalizeLocal();
			//var v3:Vector3f = direction.cross(v2).normalizeLocal();
			//
			//fromAxes(v2, v3, v1);
		}

		public function equals(other:Quaternion):Boolean
		{
			return x == other.x && y == other.y && z == other.z && w == other.w;
		}

		public function toString():String
		{
			return "Quaternion(" + x + ", " + y + ", " + z + ", " + w + ")";
		}
	}
}

