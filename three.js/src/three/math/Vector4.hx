package three.math;
import js.html.Float32Array;

/**
 * andy
 * @author 
 */

class Vector4 
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
	
	public function setTo(x:Float, y:Float, z:Float, w:Float):Vector4
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		return this;
	}
	
	public function copy(value:Vector4):Vector4
	{
		this.x = value.x;
		this.y = value.y;
		this.z = value.z;
		this.w = value.w;
		
		return this;
	}
	
	public function add(a:Vector4, b:Vector4):Vector4
	{
		this.x = a.x + b.x;
		this.y = a.y + b.y;
		this.z = a.z + b.z;
		this.w = a.w + b.w;
		return this;
	}
	
	public function addSelf(value:Vector4):Vector4
	{
		this.x += value.x;
		this.y += value.y;
		this.z += value.z;
		this.w += value.w;
		return this;
	}
	
	public function sub(a:Vector4, b:Vector4):Vector4
	{
		this.x = a.x - b.x;
		this.y = a.y - b.y;
		this.z = a.z - b.z;
		this.w = a.w - b.w;
		return this;
	}
	
	public function subSelf(value:Vector4):Vector4
	{
		this.x -= value.x;
		this.y -= value.y;
		this.z -= value.z;
		this.w -= value.w;
		return this;
	}
	
	public function multiplyScalar(value:Float):Vector4
	{
		this.x *= value;
		this.y *= value;
		this.z *= value;
		this.w *= value;
		return this;
	}
	
	public function divideScalar(value:Float):Vector4
	{
		if (value != 0)
		{
			this.x /= value;
			this.y /= value;
			this.z /= value;
			this.w /= value;
		}
		else
		{
			this.setTo(0, 0, 0, 1);
		}
		return this;
	}
	
	public function negate():Vector4
	{
		return multiplyScalar( -1);
	}
	
	public function dot(value:Vector4):Float
	{
		return this.x * value.x + this.y * value.y + this.z * value.z + this.w * value.w;
	}
	
	public var lengthSq(getLengthSq, never):Float;
	public function getLengthSq():Float
	{
		return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
	}
	
	public var length(getLength, never):Float;
	public function getLength():Float
	{
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	}
	
	public function setLength(value:Float):Vector4
	{
		return this.normalize().multiplyScalar(value);
	}

	public function normalize():Vector4
	{
		var lengthSquare:Float = this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
		if (lengthSquare != 0)
		{
			var len:Float = 1 / lengthSquare;
			this.x *= len;
			this.y *= len;
			this.z *= len;
			this.w *= len;
		}
		else
		{
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.w = 1;
		}
		
		return this;
	}
	
	public function lerpSelf(value:Vector4, interp:Float):Vector4
	{
		this.x += (value.x - this.x) * interp;
		this.y += (value.y - this.y) * interp;
		this.z += (value.z - this.z) * interp;
		this.w += (value.w - this.w) * interp;
		return this;
	}
	
	public function equals(value:Vector4):Bool
	{
		return value.x == this.x && value.y == this.y && this.z == value.z && this.w == value.w;
	}
	
	public function clone():Vector4
	{
		return new Vector4(this.x, this.y, this.z, this.w);
	}
	
	public function setAxisAngleFromQuaternion(q:Quaternion):Vector4
	{
		// http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle/index.htm

		// q is assumed to be normalized

		this.w = 2 * Math.acos(q.w);

		var s = Math.sqrt(1 - q.w * q.w);

		if (s < 0.0001) 
		{
			this.x = 1;
			this.y = 0;
			this.z = 0;
		} 
		else 
		{
			this.x = q.x / s;
			this.y = q.y / s;
			this.z = q.z / s;
		}
		return this;
	}
	
	public function setAxisAngleFromRotationMatrix(m:Matrix4):Vector4
	{
		// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle/index.htm

		// assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

		var angle:Float, x:Float, y:Float, z:Float; // variables for result
		var epsilon:Float = 0.01; // margin to allow for rounding errors
		var epsilon2:Float = 0.1; // margin to distinguish between 0 and 180 degrees

		var te:Float32Array = m.elements;
		var m11 = te[0], m12 = te[4], m13 = te[8]; 
		var m21 = te[1], m22 = te[5], m23 = te[9]; 
		var m31 = te[2], m32 = te[6], m33 = te[10];

		if ((Math.abs(m12 - m21) < epsilon ) && 
			(Math.abs(m13 - m31) < epsilon ) && 
			(Math.abs(m23 - m32) < epsilon )) 
		{

			// singularity found
			// first check for identity matrix which must have +1 for all terms
			// in leading diagonal and zero in other terms

			if ((Math.abs(m12 + m21) < epsilon2 ) && 
				(Math.abs(m13 + m31) < epsilon2 ) && 
				(Math.abs(m23 + m32) < epsilon2 ) && 
				(Math.abs(m11 + m22 + m33 - 3) < epsilon2 )) 
			{

				// this singularity is identity matrix so angle = 0

				this.setTo(1, 0, 0, 0);

				return this;
				// zero angle, arbitrary axis

			}

			// otherwise this singularity is angle = 180

			angle = Math.PI;

			var xx = (m11 + 1 ) / 2;
			var yy = (m22 + 1 ) / 2;
			var zz = (m33 + 1 ) / 2;
			var xy = (m12 + m21 ) / 4;
			var xz = (m13 + m31 ) / 4;
			var yz = (m23 + m32 ) / 4;

			// m11 is the largest diagonal term
			if ((xx > yy ) && (xx > zz )) 
			{
				if (xx < epsilon) 
				{
					x = 0;
					y = 0.707106781;
					z = 0.707106781;
				} 
				else 
				{
					x = Math.sqrt(xx);
					y = xy / x;
					z = xz / x;
				}

			} 
			// m22 is the largest diagonal term
			else if (yy > zz) 
			{
				if (yy < epsilon) 
				{
					x = 0.707106781;
					y = 0;
					z = 0.707106781;
				} 
				else 
				{
					y = Math.sqrt(yy);
					x = xy / y;
					z = yz / y;
				}

			} 
			// m33 is the largest diagonal term so base result on this
			else 
			{
				if (zz < epsilon) 
				{
					x = 0.707106781;
					y = 0.707106781;
					z = 0;
				} 
				else 
				{
					z = Math.sqrt(zz);
					x = xz / z;
					y = yz / z;
				}
			}

			this.setTo(x, y, z, angle);

			return this;
			// return 180 deg rotation
		}

		// as we have reached here there are no singularities so we can handle normally

		var s = Math.sqrt((m32 - m23 ) * (m32 - m23 ) + (m13 - m31 ) * (m13 - m31 ) + (m21 - m12 ) * (m21 - m12 ));
		// used to normalize

		if (Math.abs(s) < 0.001)
			s = 1;

		// prevent divide by zero, should not happen if matrix is orthogonal and should
		// be
		// caught by singularity test above, but I've left it in just in case

		this.x = (m32 - m23 ) / s;
		this.y = (m13 - m31 ) / s;
		this.z = (m21 - m12 ) / s;
		this.w = Math.acos((m11 + m22 + m33 - 1 ) / 2);

		return this;
	}
}