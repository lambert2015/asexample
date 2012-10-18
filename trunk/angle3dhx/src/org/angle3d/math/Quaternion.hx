package org.angle3d.math;
import flash.errors.Error;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.utils.TempVars;

/**
 * <code>Quaternion</code> defines a single example of a more general class of
 * hypercomplex numbers. Quaternions extends a rotation in three dimensions to a
 * rotation in four dimensions. This avoids "gimbal lock" and allows for smooth
 * continuous rotation.
 * 
 * <code>Quaternion</code> is defined by four floating point numbers: {x y z
 * w}.
 * 
 * @author Mark Powell
 * @author Joshua Slack
 */
class Quaternion 
{
	/**
     * Represents the identity quaternion rotation (0, 0, 0, 1).
     */
    public static inline var IDENTITY:Quaternion = new Quaternion();
    public static inline var ZERO:Quaternion = new Quaternion(0, 0, 0, 0);
	
	/**
     * the x value of the vector.
     */
    public var x:Float;
	
	/**
     * the y value of the vector.
     */
	public var y:Float;
	
	/**
     * the z value of the vector.
     */
    public var z:Float;
	
	/**
     * the w value of the vector.
     */
	public var w:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1) 
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
	public function setTo(x:Float, y:Float, z:Float, w:Float):Void
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public inline function copyFrom(q:Quaternion):Void
	{
		x = q.x;
		y = q.y;
		z = q.z;
		w = q.w;
	}
	
	public function clone():Quaternion
	{
		return new Quaternion(x, y, z, w);
	}
	
	/**
     * <code>fromAngles</code> builds a Quaternion from the Euler rotation
     * angles (y,r,p). Note that we are applying in order: roll, pitch, yaw but
     * we've ordered them in x, y, and z for convenience.
     * See: http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/index.htm
     * 
     * @param yaw
     *            the Euler yaw of rotation (in radians). (aka Bank, often rot
     *            around x)
     * @param roll
     *            the Euler roll of rotation (in radians). (aka Heading, often
     *            rot around y)
     * @param pitch
     *            the Euler pitch of rotation (in radians). (aka Attitude, often
     *            rot around z)
     */
	public function fromAngles(yaw:Float,roll:Float,pitch:Float):Void
	{
		var angle:Float;
        var sinRoll:Float, sinPitch:Float, sinYaw:Float, cosRoll:Float; 
		var cosPitch:Float, cosYaw:Float;
        angle = pitch * 0.5;
        sinPitch = Math.sin(angle);
        cosPitch = Math.cos(angle);
        angle = roll * 0.5;
        sinRoll = Math.sin(angle);
        cosRoll = Math.cos(angle);
        angle = yaw * 0.5;
        sinYaw = Math.sin(angle);
        cosYaw = Math.cos(angle);

        // variables used to reduce multiplication calls.
        var cosRollXcosPitch:Float = cosRoll * cosPitch;
        var sinRollXsinPitch:Float = sinRoll * sinPitch;
        var cosRollXsinPitch:Float = cosRoll * sinPitch;
        var sinRollXcosPitch:Float = sinRoll * cosPitch;

        w = (cosRollXcosPitch * cosYaw - sinRollXsinPitch * sinYaw);
        x = (cosRollXcosPitch * sinYaw + sinRollXsinPitch * cosYaw);
        y = (sinRollXcosPitch * cosYaw + cosRollXsinPitch * sinYaw);
        z = (cosRollXsinPitch * cosYaw - sinRollXcosPitch * sinYaw);
	}
	
	
	public function fromAngleList(arr:Array<Float>):Void
	{
		fromAngles(arr[0], arr[1], arr[2]);
	}
	
	public function loadIdentity():Void
	{
		x = y = z = 0;
		w = 1;
	}
	
	/**
     * @return true if this Quaternion is {0,0,0,1}
     */
    public function isIdentity():Bool
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
		if (result == null) result = new Vector3f();
		
		var sqw:Float = w * w;
        var sqx:Float = x * x;
        var sqy:Float = y * y;
        var sqz:Float = z * z;
        var unit:Float = sqx + sqy + sqz + sqw; // if normalized is one, otherwise
        // is correction factor
        var test:Float = x * y + z * w;
        if (test > 0.499 * unit) // singularity at north pole
		{ 
            result.y = 2 * Math.atan2(x, w);
            result.z = FastMath.HALF_PI;
            result.x = 0;
        } 
		else if (test < -0.499 * unit)  // singularity at south pole
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
	public function toAngles(result:Array<Float> = null):Array<Float>
	{
		if (result == null) result = new Array<Float>();
		
		var sqw:Float = w * w;
        var sqx:Float = x * x;
        var sqy:Float = y * y;
        var sqz:Float = z * z;
        var unit:Float = sqx + sqy + sqz + sqw; // if normalized is one, otherwise
        // is correction factor
        var test:Float = x * y + z * w;
        if (test > 0.499 * unit) // singularity at north pole
		{ 
            result[1] = 2 * Math.atan2(x, w);
            result[2] = FastMath.HALF_PI;
            result[0] = 0;
        } 
		else if (test < -0.499 * unit)  // singularity at south pole
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
	public function fromRotationMatrix(mat:Matrix3f):Void
	{
		// Use the Graphics Gems code, from 
        // ftp://ftp.cis.upenn.edu/pub/graphics/shoemake/quatut.ps.Z
        // *NOT* the "Matrix and Quaternions FAQ", which has errors!

        // the trace is the sum of the diagonal elements; see
        // http://mathworld.wolfram.com/MatrixTrace.html
        var t:Float = mat.m00 + mat.m11 + mat.m22;

        // we protect the division by s by ensuring that s>=1
        if (t >= 0)  // |w| >= .5
		{ 
            var s:Float = Math.sqrt(t + 1); // |s|>=1 ...
            w = 0.5 * s;
            s = 0.5 / s;                 // so this division isn't bad
            x = (mat.m21 - mat.m12) * s;
            y = (mat.m02 - mat.m20) * s;
            z = (mat.m10 - mat.m01) * s;
        } 
		else if ((mat.m00 > mat.m11) && (mat.m00 > mat.m22)) 
		{
            var s:Float = Math.sqrt(1.0 + mat.m00 - mat.m11 - mat.m22); // |s|>=1
            x = s * 0.5; // |x| >= .5
            s = 0.5 / s;
            y = (mat.m10 + mat.m01) * s;
            z = (mat.m02 + mat.m20) * s;
            w = (mat.m21 - mat.m12) * s;
        } 
		else if (mat.m11 > mat.m22) 
		{
            var s:Float = Math.sqrt(1.0 + mat.m11 - mat.m00 - mat.m22); // |s|>=1
            y = s * 0.5; // |y| >= .5
            s = 0.5 / s;
            x = (mat.m10 + mat.m01) * s;
            z = (mat.m21 + mat.m12) * s;
            w = (mat.m02 - mat.m20) * s;
        } 
		else 
		{
            var s:Float = Math.sqrt(1.0 + mat.m22 - mat.m00 - mat.m11); // |s|>=1
            z = s * 0.5; // |z| >= .5
            s = 0.5 / s;
            x = (mat.m02 + mat.m20) * s;
            y = (mat.m21 + mat.m12) * s;
            w = (mat.m10 - mat.m01) * s;
        }
	}
	
	/**
     * <code>toRotationMatrix</code> converts this quaternion to a rotational
     * matrix. The result is stored in result.
     * 
     * @param result
     *            The Matrix3f to store the result in.
     * @return the rotation matrix representation of this quaternion.
     */
	public function toRotationMatrix3f(result:Matrix3f = null):Matrix3f
	{
		if (result == null) result = new Matrix3f();
		
		var norm:Float = getNorm();
        // we explicitly test norm against one here, saving a division
        // at the cost of a test and branch.  Is it worth it?
        var s:Float = (norm == 1) ? 2 : ((norm > 0) ? 2 / norm : 0);

        // compute xs/ys/zs first to save 6 multiplications, since xs/ys/zs
        // will be used 2-4 times each.
        var xs:Float = x * s;
        var ys:Float = y * s;
        var zs:Float = z * s;
        var xx:Float = x * xs;
        var xy:Float = x * ys;
        var xz:Float = x * zs;
        var xw:Float = w * xs;
        var yy:Float = y * ys;
        var yz:Float = y * zs;
        var yw:Float = w * ys;
        var zz:Float = z * zs;
        var zw:Float = w * zs;

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
	
	public function toRotationMatrix4f(result:Matrix4f = null):Matrix4f
	{
		if (result == null) result = new Matrix4f();
		
		var norm:Float = getNorm();
        // we explicitly test norm against one here, saving a division
        // at the cost of a test and branch.  Is it worth it?
        var s:Float = (norm == 1) ? 2 : ((norm > 0) ? 2 / norm : 0);

        // compute xs/ys/zs first to save 6 multiplications, since xs/ys/zs
        // will be used 2-4 times each.
        var xs:Float = x * s;
        var ys:Float = y * s;
        var zs:Float = z * s;
        var xx:Float = x * xs;
        var xy:Float = x * ys;
        var xz:Float = x * zs;
        var xw:Float = w * xs;
        var yy:Float = y * ys;
        var yz:Float = y * zs;
        var yw:Float = w * ys;
        var zz:Float = z * zs;
        var zw:Float = w * zs;

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
	public function getRotationColumn(i:Int, result:Vector3f = null):Vector3f
	{
		if (result == null) result = new Vector3f();
		
		var norm:Float = getNorm();
        if (norm != 1.0) {
            norm = 1/Math.sqrt(norm);
        }

        var xx:Float = x * x * norm;
        var xy:Float = x * y * norm;
        var xz:Float = x * z * norm;
        var xw:Float = x * w * norm;
        var yy:Float = y * y * norm;
        var yz:Float = y * z * norm;
        var yw:Float = y * w * norm;
        var zz:Float = z * z * norm;
        var zw:Float = z * w * norm;

        switch (i) {
            case 0:
                result.x = 1 - 2 * (yy + zz);
                result.y = 2 * (xy + zw);
                result.z = 2 * (xz - yw);
            case 1:
                result.x = 2 * (xy - zw);
                result.y = 1 - 2 * (xx + zz);
                result.z = 2 * (yz + xw);
            case 2:
                result.x = 2 * (xz + yw);
                result.y = 2 * (yz - xw);
                result.z = 1 - 2 * (xx + yy);
            default:
                throw new Error("Invalid column index. " + i);
        }

        return result;
	}
	
	/**
     * <code>fromAngleAxis</code> sets this quaternion to the values specified
     * by an angle and an axis of rotation. This method creates an object, so
     * use fromAngleNormalAxis if your axis is already normalized.
     *
     * @param angle
     *            the angle to rotate (in radians).
     * @param axis
     *            the axis of rotation.
     * @return this quaternion
     */
	public function fromAngleAxis(angle:Float, axis:Vector3f):Void
	{
		var normAxis:Vector3f = axis.clone().normalizeLocal();
		fromAngleNormalAxis(angle, normAxis);
	}
	
	/**
     * <code>fromAngleNormalAxis</code> sets this quaternion to the values
     * specified by an angle and a normalized axis of rotation.
     *
     * @param angle
     *            the angle to rotate (in radians).
     * @param axis
     *            the axis of rotation (already normalized).
     */
	public function fromAngleNormalAxis(angle:Float, axis:Vector3f):Void
	{
		if (axis.x == 0 && axis.y == 0 && axis.z == 0)
		{
			loadIdentity();
		}
		else
		{
			var halfAngle:Float = 0.5 * angle;
			var sin:Float = Math.sin(halfAngle);
			w = Math.cos(halfAngle);
			x = sin * axis.x;
			y = sin * axis.y;
			z = sin * axis.z;
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
	public function toAngleAxis(result:Vector3f = null):Float
	{
		var sqrLength:Float = x * x + y * y + z * z;
		var angle:Float;
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
			angle = (2.0 * Math.acos(w));
            if (result != null) 
			{
                var invLength:Float = (1.0 / Math.sqrt(sqrLength));
                result.x = x * invLength;
                result.y = y * invLength;
                result.z = z * invLength;
            }
		}
		return angle;
	}
	
	/**
     * <code>slerp</code> sets this quaternion's value as an interpolation
     * between two other quaternions.
     *
     * @param q1
     *            the first quaternion.
     * @param q2
     *            the second quaternion.
     * @param t
     *            the amount to interpolate between the two quaternions.
     */
	public function slerp2(q1:Quaternion, q2:Quaternion, t:Float):Void
	{
		// Create a local quaternion to store the interpolated quaternion
        if (q1.x == q2.x && q1.y == q2.y && q1.z == q2.z && q1.w == q2.w) 
		{
            copyFrom(q1);
            return;
        }
		
		var result:Float = (q1.x * q2.x) + (q1.y * q2.y) + (q1.z * q2.z)
                + (q1.w * q2.w);

        if (result < 0.0) 
		{
            // Negate the second quaternion and the result of the dot product
            q2.x = -q2.x;
            q2.y = -q2.y;
            q2.z = -q2.z;
            q2.w = -q2.w;
            result = -result;
        }

        // Set the first and second scale for the interpolation
        var scale0:Float = 1 - t;
        var scale1:Float = t;

        // Check if the angle between the 2 quaternions was big enough to
        // warrant such calculations
        if ((1 - result) > 0.1)  // Get the angle between the 2 quaternions,
		{
            // and then store the sin() of that angle
            var theta:Float = Math.acos(result);
            var invSinTheta:Float = 1 / Math.sin(theta);

            // Calculate the scale for q1 and q2, according to the angle and
            // it's sine value
            scale0 = Math.sin((1 - t) * theta) * invSinTheta;
            scale1 = Math.sin((t * theta)) * invSinTheta;
        }

        // Calculate the x, y, z and w values for the quaternion by using a
        // special
        // form of linear interpolation for quaternions.
        this.x = (scale0 * q1.x) + (scale1 * q2.x);
        this.y = (scale0 * q1.y) + (scale1 * q2.y);
        this.z = (scale0 * q1.z) + (scale1 * q2.z);
        this.w = (scale0 * q1.w) + (scale1 * q2.w);
	}
	
	/**
     * Sets the values of this quaternion to the slerp from itself to q2 by
     * t
     *
     * @param q2
     *            Final interpolation value
     * @param t
     *            The amount diffrence
     */
	public function slerp(q2:Quaternion, t:Float):Void
	{
		// Create a local quaternion to store the interpolated quaternion
        if (x == q2.x && y == q2.y && z == q2.z && w == q2.w) 
		{
            return;
        }
		
		var result:Float = (x * q2.x) + (y * q2.y) + (z * q2.z) + (w * q2.w);

        if (result < 0.0) 
		{
            // Negate the second quaternion and the result of the dot product
            q2.x = -q2.x;
            q2.y = -q2.y;
            q2.z = -q2.z;
            q2.w = -q2.w;
            result = -result;
        }

        // Set the first and second scale for the interpolation
        var scale0:Float = 1 - t;
        var scale1:Float = t;

        // Check if the angle between the 2 quaternions was big enough to
        // warrant such calculations
        if ((1 - result) > 0.1)  // Get the angle between the 2 quaternions,
		{
            // and then store the sin() of that angle
            var theta:Float = Math.acos(result);
            var invSinTheta:Float = 1 / Math.sin(theta);

            // Calculate the scale for q1 and q2, according to the angle and
            // it's sine value
            scale0 = Math.sin((1 - t) * theta) * invSinTheta;
            scale1 = Math.sin((t * theta)) * invSinTheta;
        }

        // Calculate the x, y, z and w values for the quaternion by using a
        // special
        // form of linear interpolation for quaternions.
        this.x = (scale0 * x) + (scale1 * q2.x);
        this.y = (scale0 * y) + (scale1 * q2.y);
        this.z = (scale0 * z) + (scale1 * q2.z);
        this.w = (scale0 * w) + (scale1 * q2.w);
	}
	
	/**
     * Sets the values of this quaternion to the nlerp from itself to q2 by blend.
     * @param q2
     * @param blend
     */
	public function nlerp(q2:Quaternion, blend:Float):Void
	{
		var dot:Float = dotProduct(q2);
        var blendI:Float = 1.0 - blend;
        if (dot < 0.0) 
		{
            x = blendI * x - blend * q2.x;
            y = blendI * y - blend * q2.y;
            z = blendI * z - blend * q2.z;
            w = blendI * w - blend * q2.w;
        } 
		else 
		{
            x = blendI * x + blend * q2.x;
            y = blendI * y + blend * q2.y;
            z = blendI * z + blend * q2.z;
            w = blendI * w + blend * q2.w;
        }
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
	public function add(q:Quaternion):Quaternion
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
	public function addLocal(q:Quaternion):Void
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
	public function subtract(q:Quaternion):Quaternion
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
	public function subtractLocal(q:Quaternion):Void
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
     * It IS safe for q and res to be the same object.
     * It IS safe for this and res to be the same object.
     *
     * @param q
     *            the quaternion to multiply this quaternion by.
     * @param res
     *            the quaternion to store the result in.
     * @return the new quaternion.
     */
	public function multiply(q:Quaternion, result:Quaternion = null):Quaternion
	{
		if (result == null) 
		{
            result = new Quaternion();
        }
		
		var tw:Float = w, tx:Float = x, ty:Float = y, tz:Float = z;
		var qw:Float = q.w, qx:Float = q.x, qy:Float = q.y, qz:Float = q.z;
        result.x =  tx * qw + ty * qz - tz * qy + tw * qx;
        result.y = -tx * qz + ty * qw + tz * qx + tw * qy;
        result.z =  tx * qy - ty * qx + tz * qw + tw * qz;
        result.w = -tx * qx - ty * qy - tz * qz + tw * qw;
        return result;
	}
	
	public function multiplyLocal(q:Quaternion):Void
	{
		multiply(q, this);
	}
	
	/**
     * <code>apply</code> multiplies this quaternion by a parameter matrix
     * internally.
     *
     * @param matrix
     *            the matrix to apply to this quaternion.
     */
	public function apply(matrix:Matrix3f):Void
	{
		var oldX:Float = x, oldY:Float = y, oldZ:Float = z, oldW:Float = w;
        fromRotationMatrix(matrix);
        var tempX:Float = x, tempY:Float = y, tempZ:Float = z, tempW:Float = w;

        x =  oldX * tempW + oldY * tempZ - oldZ * tempY + oldW * tempX;
        y = -oldX * tempZ + oldY * tempW + oldZ * tempX + oldW * tempY;
        z =  oldX * tempY - oldY * tempX + oldZ * tempW + oldW * tempZ;
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
	public function fromAxes(xAxis:Vector3f,yAxis:Vector3f,zAxis:Vector3f):Void
	{
		var m:Matrix3f = new Matrix3f([xAxis.x, yAxis.x, zAxis.x, 
		                                              xAxis.y, yAxis.y, zAxis.y, 
		                                              xAxis.z, yAxis.z, zAxis.z]);
		fromRotationMatrix(m);
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
	public function toAxes(axis:Vector<Vector3f>):Void
	{
		var tempMat:Matrix3f = toRotationMatrix3f();
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
	public function multiplyVector(v:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null) result = new Vector3f();
		
		if (v.x == 0 && v.y == 0 && v.z == 0)
		{
			result.setTo(0, 0, 0);
		}
		else
		{
			var vx:Float = v.x, vy:Float = v.y, vz:Float = v.z;
			var tempX:Float, tempY:Float;
        	tempX = w * w * vx + 2 * y * w * vz - 2 * z * w * vy + x * x * vx
                  + 2 * y * x * vy + 2 * z * x * vz - z * z * vx - y * y * vx;
        	tempY = 2 * x * y * vx + y * y * vy + 2 * z * y * vz + 2 * w * z * vx - 
			        z * z * vy + w * w * vy - 2 * x * w * vz - x * x* vy;
        	result.z = 2 * x * z * vx + 2 * y * z * vy + z * z * vz - 2 * w * y * vx - 
			           y * y * vz + 2 * w * x * vy - x * x * vz + w * w * vz;
        	result.x = tempX;
        	result.y = tempY;
		}
        return result;
	}
	
	public function multVecLocal(v:Vector3f):Void
	{
		multiplyVector(v, v);
	}
	
	/**
     * <code>mult</code> multiplies this quaternion by a parameter scalar. The
     * result is returned as a new quaternion.
     *
     * @param scalar
     *            the quaternion to multiply this quaternion by.
     * @return the new quaternion.
     */
	public function scale(value:Float):Quaternion
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
	public function scaleBy(value:Float):Void
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
	public function dotProduct(q:Quaternion):Float
	{
		return x * q.x + y * q.y + z * q.z + w * q.w;
	}
	
	/**
     * <code>norm</code> returns the norm of this quaternion. This is the dot
     * product of this quaternion with itself.
     *
     * @return the norm of the quaternion.
     */
	public function getNorm():Float
	{
		return x * x + y * y + z * z + w * w;
	}
	
	/**
     * <code>normalize</code> normalizes the current <code>Quaternion</code>
     */
    public function normalizeLocal():Quaternion
	{
		var norm:Float = getNorm();
		if (norm == 0)
		{
			zero();
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
	
	public function zero():Void
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
		var norm:Float = getNorm();
		if (norm > 0.0)
		{
			var invNorm:Float = 1.0 / norm;
			return new Quaternion( -x * invNorm, -y * invNorm, -z * invNorm, w * invNorm);
		}
		 // return an invalid result to flag the error
        return null;
	}
	
	/**
     * <code>inverse</code> calculates the inverse of this quaternion and
     * returns this quaternion after it is calculated. If this quaternion does
     * not have an inverse (if it's norma is 0 or less), nothing happens
     *
     * @return the inverse of this quaternion
     */
	public function inverseLocal():Void
	{
		var norm:Float = getNorm();
		if (norm > 0.0)
		{
			norm = 1.0 / norm;
            x *= -norm;
            y *= -norm;
            z *= -norm;
            w *=  norm;
		}
	}
	
	/**
     * <code>negate</code> inverts the values of the quaternion.
     *
     */
	public function negate():Void
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
	public function lookAt(direction:Vector3f, up:Vector3f):Void
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
	
	public function toString():String 
	{
        return "Quaternion(" + x + ", " + y + ", " + z + ", " + w + ")";
    }
}