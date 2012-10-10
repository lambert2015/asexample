package three.math;

/**
 * ...
 * @author andy
 */
import UserAgentContext;

class Quaternion 
{
	public var x:Float;
	
	public var y:Float;
	
	public var z:Float;
	
	public var w:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public function setTo(x:Float, y:Float, z:Float, w:Float):Quaternion
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		return this;
	}
	
	public function copy(value:Quaternion):Quaternion
	{
		this.x = value.x;
		this.y = value.y;
		this.z = value.z;
		this.w = value.w;
		
		return this;
	}
	
	public function setFromEuler(v:Vector3, order:EulerOrder):Quaternion
	{

		// http://www.mathworks.com/matlabcentral/fileexchange/
		// 	20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/
		//	content/SpinCalc.m

		var c1 = Math.cos(v.x / 2);
		var c2 = Math.cos(v.y / 2);
		var c3 = Math.cos(v.z / 2);
		var s1 = Math.sin(v.x / 2);
		var s2 = Math.sin(v.y / 2);
		var s3 = Math.sin(v.z / 2);

		if (order == null || order == EulerOrder.XYZ) 
		{
			this.x = s1 * c2 * c3 + c1 * s2 * s3;
			this.y = c1 * s2 * c3 - s1 * c2 * s3;
			this.z = c1 * c2 * s3 + s1 * s2 * c3;
			this.w = c1 * c2 * c3 - s1 * s2 * s3;
		} 
		else if (order == EulerOrder.YXZ) 
		{
			this.x = s1 * c2 * c3 + c1 * s2 * s3;
			this.y = c1 * s2 * c3 - s1 * c2 * s3;
			this.z = c1 * c2 * s3 - s1 * s2 * c3;
			this.w = c1 * c2 * c3 + s1 * s2 * s3;
		} 
		else if (order == EulerOrder.ZXY) 
		{
			this.x = s1 * c2 * c3 - c1 * s2 * s3;
			this.y = c1 * s2 * c3 + s1 * c2 * s3;
			this.z = c1 * c2 * s3 + s1 * s2 * c3;
			this.w = c1 * c2 * c3 - s1 * s2 * s3;
		}
		else if (order == EulerOrder.ZYX) 
		{
			this.x = s1 * c2 * c3 - c1 * s2 * s3;
			this.y = c1 * s2 * c3 + s1 * c2 * s3;
			this.z = c1 * c2 * s3 - s1 * s2 * c3;
			this.w = c1 * c2 * c3 + s1 * s2 * s3;
		} 
		else if (order == EulerOrder.YZX) 
		{
			this.x = s1 * c2 * c3 + c1 * s2 * s3;
			this.y = c1 * s2 * c3 + s1 * c2 * s3;
			this.z = c1 * c2 * s3 - s1 * s2 * c3;
			this.w = c1 * c2 * c3 - s1 * s2 * s3;
		} 
		else if (order == EulerOrder.XZY) 
		{
			this.x = s1 * c2 * c3 - c1 * s2 * s3;
			this.y = c1 * s2 * c3 - s1 * c2 * s3;
			this.z = c1 * c2 * s3 + s1 * s2 * c3;
			this.w = c1 * c2 * c3 + s1 * s2 * s3;
		}

		return this;

	}

	public function setFromAxisAngle(axis:Vector3, angle:Float):Quaternion 
	{

		// from
		// http://www.euclideanspace.com/maths/geometry/rotations/conversions/angleToQuaternion/index.htm
		// axis have to be normalized

		var halfAngle = angle / 2, s = Math.sin(halfAngle);

		this.x = axis.x * s;
		this.y = axis.y * s;
		this.z = axis.z * s;
		this.w = Math.cos(halfAngle);

		return this;

	}

	public function setFromRotationMatrix(m:Matrix4):Quaternion 
	{

		// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm

		// assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

		var te:Float32Array = m.elements; 
		var m11:Float = te[0], m12:Float = te[4], m13:Float = te[8];
		var m21:Float = te[1], m22:Float = te[5], m23:Float = te[9]; 
		var m31:Float = te[2], m32:Float = te[6], m33:Float = te[10]; 
		var tTrace:Float = m11 + m22 + m33, s:Float;

		if (tTrace > 0) 
		{
			s = 0.5 / Math.sqrt(tTrace + 1.0);

			this.w = 0.25 / s;
			this.x = (m32 - m23 ) * s;
			this.y = (m13 - m31 ) * s;
			this.z = (m21 - m12 ) * s;

		} 
		else if (m11 > m22 && m11 > m33) 
		{
			s = 2.0 * Math.sqrt(1.0 + m11 - m22 - m33);

			this.w = (m32 - m23 ) / s;
			this.x = 0.25 * s;
			this.y = (m12 + m21 ) / s;
			this.z = (m13 + m31 ) / s;

		} 
		else if (m22 > m33) 
		{
			s = 2.0 * Math.sqrt(1.0 + m22 - m11 - m33);

			this.w = (m13 - m31 ) / s;
			this.x = (m12 + m21 ) / s;
			this.y = 0.25 * s;
			this.z = (m23 + m32 ) / s;
		} 
		else 
		{
			s = 2.0 * Math.sqrt(1.0 + m33 - m11 - m22);

			this.w = (m21 - m12 ) / s;
			this.x = (m13 + m31 ) / s;
			this.y = (m23 + m32 ) / s;
			this.z = 0.25 * s;

		}

		return this;
	}

	public function calculateW():Quaternion 
	{
		this.w = -Math.sqrt(Math.abs(1.0 - this.x * this.x - this.y * this.y - this.z * this.z));

		return this;
	}

	public function inverse():Quaternion
	{
		this.x *= -1;
		this.y *= -1;
		this.z *= -1;

		return this;
	}

	public var length(getLength, never):Float;
	public function getLength():Float
	{
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	}

	public function normalize():Quaternion
	{
		var l = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);

		if (l == 0) 
		{
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.w = 0;
		} 
		else 
		{
			l = 1 / l;

			this.x = this.x * l;
			this.y = this.y * l;
			this.z = this.z * l;
			this.w = this.w * l;
		}

		return this;

	}

	public function multiply(a:Quaternion, b:Quaternion):Quaternion 
	{
		// from
		// http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/code/index.htm
		var qax = a.x, qay = a.y, qaz = a.z, qaw = a.w, qbx = b.x, qby = b.y, qbz = b.z, qbw = b.w;

		this.x = qax * qbw + qay * qbz - qaz * qby + qaw * qbx;
		this.y = -qax * qbz + qay * qbw + qaz * qbx + qaw * qby;
		this.z = qax * qby - qay * qbx + qaz * qbw + qaw * qbz;
		this.w = -qax * qbx - qay * qby - qaz * qbz + qaw * qbw;

		return this;
	}

	public function multiplySelf(b:Quaternion):Quaternion
	{
		var qax = this.x, qay = this.y, qaz = this.z, qaw = this.w, qbx = b.x, qby = b.y, qbz = b.z, qbw = b.w;

		this.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
		this.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
		this.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
		this.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;

		return this;
	}

	public function multiplyVector3(vector:Vector3, dest:Vector3):Vector3
	{
		if (dest == null) 
		{
			dest = vector;
		}

		var x = vector.x, y = vector.y, z = vector.z, qx = this.x, qy = this.y, qz = this.z, qw = this.w;

		// calculate quat * vector

		var ix = qw * x + qy * z - qz * y, iy = qw * y + qz * x - qx * z, iz = qw * z + qx * y - qy * x, iw = -qx * x - qy * y - qz * z;

		// calculate result * inverse quat

		dest.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
		dest.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
		dest.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;

		return dest;

	}

	public function slerpSelf(qb:Quaternion, t:Float):Quaternion
	{

		var x = this.x, y = this.y, z = this.z, w = this.w;

		// http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/

		var cosHalfTheta = w * qb.w + x * qb.x + y * qb.y + z * qb.z;

		if (cosHalfTheta < 0) 
		{
			this.w = -qb.w;
			this.x = -qb.x;
			this.y = -qb.y;
			this.z = -qb.z;

			cosHalfTheta = -cosHalfTheta;
		} 
		else 
		{
			this.copy(qb);
		}

		if (cosHalfTheta >= 1.0) 
		{
			this.w = w;
			this.x = x;
			this.y = y;
			this.z = z;

			return this;
		}

		var halfTheta = Math.acos(cosHalfTheta);
		var sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);

		if (Math.abs(sinHalfTheta) < 0.001)
		{
			this.w = 0.5 * (w + this.w );
			this.x = 0.5 * (x + this.x );
			this.y = 0.5 * (y + this.y );
			this.z = 0.5 * (z + this.z );

			return this;
		}

		var ratioA = Math.sin((1 - t ) * halfTheta) / sinHalfTheta, ratioB = Math.sin(t * halfTheta) / sinHalfTheta;

		this.w = (w * ratioA + this.w * ratioB );
		this.x = (x * ratioA + this.x * ratioB );
		this.y = (y * ratioA + this.y * ratioB );
		this.z = (z * ratioA + this.z * ratioB );

		return this;

	}

	public function clone():Quaternion
	{
		return new Quaternion(this.x, this.y, this.z, this.w);
	}
}