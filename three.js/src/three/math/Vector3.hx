package three.math;

/**
 * andy
 * @author 
 */

class Vector3 
{
	public static inline var X_AXIS:Vector3 = new Vector3(1, 0, 0);
	public static inline var Y_AXIS:Vector3 = new Vector3(0, 1, 0);
	public static inline var Z_AXIS:Vector3 = new Vector3(0, 0, 1);
	
	public var x:Float;
	
	public var y:Float;
	
	public var z:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) 
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public function setTo(x:Float, y:Float, z:Float):Vector3
	{
		this.x = x;
		this.y = y;
		this.z = z;
		return this;
	}
	
	public function copy(value:Vector3):Vector3
	{
		this.x = value.x;
		this.y = value.y;
		this.z = value.z;
		
		return this;
	}
	
	public function add(a:Vector3, b:Vector3):Vector3
	{
		this.x = a.x + b.x;
		this.y = a.y + b.y;
		this.z = a.z + b.z;
		return this;
	}
	
	public function addSelf(value:Vector3):Vector3
	{
		this.x += value.x;
		this.y += value.y;
		this.z += value.z;
		return this;
	}
	
	public function sub(a:Vector3, b:Vector3):Vector3
	{
		this.x = a.x - b.x;
		this.y = a.y - b.y;
		this.z = a.z - b.z;
		return this;
	}
	
	public function subSelf(value:Vector3):Vector3
	{
		this.x -= value.x;
		this.y -= value.y;
		this.z -= value.z;
		return this;
	}
	
	public function multiply(a:Vector3,b:Vector3):Vector3
	{
		this.x = a.x * b.x;
		this.y = a.y * b.y;
		this.z = a.z * b.z;
		return this;
	}
	
	public function multiplySelf(value:Vector3):Vector3
	{
		this.x *= value.x;
		this.y *= value.y;
		this.z *= value.z;
		return this;
	}
	
	public function multiplyScalar(value:Float):Vector3
	{
		this.x *= value;
		this.y *= value;
		this.z *= value;
		return this;
	}
	
	public function divideScalar(value:Float):Vector3
	{
		if (value != 0)
		{
			this.x /= value;
			this.y /= value;
			this.z /= value;
		}
		else
		{
			this.setTo(0, 0, 0);
		}
		return this;
	}
	
	public function negate():Vector3
	{
		return multiplyScalar( -1);
	}
	
	public function dot(value:Vector3):Float
	{
		return this.x * value.x + this.y * value.y + this.z * value.z;
	}
	
	public var lengthSq(getLengthSq, never):Float;
	public function getLengthSq():Float
	{
		return this.x * this.x + this.y * this.y + this.z * this.z;
	}
	
	public var length(get, never):Float;
	private function get_length():Float
	{
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	
	private function setLength(value:Float):Vector3
	{
		return this.normalize().multiplyScalar(value);
	}
	
	public function lengthManhattan():Float
	{
		return Math.abs(this.x) + Math.abs(this.y) + Math.abs(this.z);
	}
	
	public function normalize():Vector3
	{
		var lengthSquare:Float = this.x * this.x + this.y * this.y + this.z * this.z;
		if (lengthSquare != 0)
		{
			var len:Float = 1 / lengthSquare;
			this.x *= len;
			this.y *= len;
			this.z *= len;
		}
		else
		{
			this.x = 0;
			this.y = 0;
			this.z = 0;
		}
		
		return this;
	}
	
	public function cross(a:Vector3, b:Vector3):Vector3
	{
		this.x = a.y * b.z - a.z * b.y;
		this.y = a.z * b.x - a.x * b.z;
		this.z = a.x * b.y - a.y * b.x;
		
		return this;
	}
	
	public function crossSelf(b:Vector3):Vector3
	{
		var sx:Float = this.x, sy:Float = this.y, sz:Float = this.z;
		
		this.x = sy * b.z - sz * b.y;
		this.y = sz * b.x - sx * b.z;
		this.z = sx * b.y - sy * b.x;
		
		return this;
	}
	
	public function distanceToSquared(value:Vector3):Float
	{
		var dx:Float = this.x - value.x, dy:Float = this.y - value.y, dz:Float = this.z - value.z;
		
		return dx * dx + dy * dy + dz * dz;
	}
	
	public function distanceTo(value:Vector3):Float
	{
		var dx:Float = this.x - value.x, dy:Float = this.y - value.y, dz:Float = this.z - value.z;
		
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}
	
	public function lerpSelf(value:Vector3, interp:Float):Vector3
	{
		this.x += (value.x - this.x) * interp;
		this.y += (value.y - this.y) * interp;
		this.z += (value.z - this.z) * interp;
		return this;
	}
	
	public function getPositionFromMatrix(m:Matrix4):Vector3 
	{
		this.x = m.elements[12];
		this.y = m.elements[13];
		this.z = m.elements[14];

		return this;
	}

	public function setEulerFromRotationMatrix(m:Matrix4, order:EulerOrder):Vector3
	{
		// assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)
		// clamp, to handle numerical problems

		var te = m.elements;
		var m11 = te[0], m12 = te[4], m13 = te[8];
		var m21 = te[1], m22 = te[5], m23 = te[9];
		var m31 = te[2], m32 = te[6], m33 = te[10];

		if (order == null || order == EulerOrder.XYZ) {

			this.y = Math.asin(MathUtil.clamp(m13, -1, 1));

			if (Math.abs(m13) < 0.99999) {

				this.x = Math.atan2(-m23, m33);
				this.z = Math.atan2(-m12, m11);

			} else {

				this.x = Math.atan2(m21, m22);
				this.z = 0;

			}

		} else if (order == EulerOrder.YXZ) {

			this.x = Math.asin(-MathUtil.clamp(m23,-1,1));

			if (Math.abs(m23) < 0.99999) {

				this.y = Math.atan2(m13, m33);
				this.z = Math.atan2(m21, m22);

			} else {

				this.y = Math.atan2(-m31, m11);
				this.z = 0;

			}

		} else if (order == EulerOrder.ZXY) {

			this.x = Math.asin(MathUtil.clamp(m32,-1,1));

			if (Math.abs(m32) < 0.99999) {

				this.y = Math.atan2(-m31, m33);
				this.z = Math.atan2(-m12, m22);

			} else {

				this.y = 0;
				this.z = Math.atan2(m13, m11);

			}

		} else if (order == EulerOrder.ZYX) {

			this.y = Math.asin(-MathUtil.clamp(m31,-1,1));

			if (Math.abs(m31) < 0.99999) {

				this.x = Math.atan2(m32, m33);
				this.z = Math.atan2(m21, m11);

			} else {

				this.x = 0;
				this.z = Math.atan2(-m12, m22);

			}

		} else if (order == EulerOrder.YZX) {

			this.z = Math.asin(MathUtil.clamp(m21,-1,1));

			if (Math.abs(m21) < 0.99999) {

				this.x = Math.atan2(-m23, m22);
				this.y = Math.atan2(-m31, m11);

			} else {

				this.x = 0;
				this.y = Math.atan2(m31, m33);

			}

		} else if (order == EulerOrder.XZY) {

			this.z = Math.asin(-MathUtil.clamp(m12,-1,1));

			if (Math.abs(m12) < 0.99999) {

				this.x = Math.atan2(m32, m22);
				this.y = Math.atan2(m13, m11);

			} else {

				this.x = Math.atan2(-m13, m33);
				this.y = 0;

			}

		}

		return this;
	}

	public function setEulerFromQuaternion(q:Quaternion, order:EulerOrder):Vector3
	{

		// q is assumed to be normalized

		// http://www.mathworks.com/matlabcentral/fileexchange/20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/content/SpinCalc.m

		var sqx = q.x * q.x;
		var sqy = q.y * q.y;
		var sqz = q.z * q.z;
		var sqw = q.w * q.w;

		if (order == null || order == EulerOrder.XYZ) {

			this.x = Math.atan2(2 * (q.x * q.w - q.y * q.z ), (sqw - sqx - sqy + sqz ));
			this.y = Math.asin(MathUtil.clamp(2 * (q.x * q.z + q.y * q.w ),-1,1));
			this.z = Math.atan2(2 * (q.z * q.w - q.x * q.y ), (sqw + sqx - sqy - sqz ));

		} else if (order == EulerOrder.YXZ) {

			this.x = Math.asin(MathUtil.clamp(2 * (q.x * q.w - q.y * q.z ),-1,1));
			this.y = Math.atan2(2 * (q.x * q.z + q.y * q.w ), (sqw - sqx - sqy + sqz ));
			this.z = Math.atan2(2 * (q.x * q.y + q.z * q.w ), (sqw - sqx + sqy - sqz ));

		} else if (order == EulerOrder.ZXY) {

			this.x = Math.asin(MathUtil.clamp(2 * (q.x * q.w + q.y * q.z ),-1,1));
			this.y = Math.atan2(2 * (q.y * q.w - q.z * q.x ), (sqw - sqx - sqy + sqz ));
			this.z = Math.atan2(2 * (q.z * q.w - q.x * q.y ), (sqw - sqx + sqy - sqz ));

		} else if (order == EulerOrder.ZYX) {

			this.x = Math.atan2(2 * (q.x * q.w + q.z * q.y ), (sqw - sqx - sqy + sqz ));
			this.y = Math.asin(MathUtil.clamp(2 * (q.y * q.w - q.x * q.z ),-1,1));
			this.z = Math.atan2(2 * (q.x * q.y + q.z * q.w ), (sqw + sqx - sqy - sqz ));

		} else if (order == EulerOrder.YZX) {

			this.x = Math.atan2(2 * (q.x * q.w - q.z * q.y ), (sqw - sqx + sqy - sqz ));
			this.y = Math.atan2(2 * (q.y * q.w - q.x * q.z ), (sqw + sqx - sqy - sqz ));
			this.z = Math.asin(MathUtil.clamp(2 * (q.x * q.y + q.z * q.w ),-1,1));

		} else if (order == EulerOrder.XZY) {

			this.x = Math.atan2(2 * (q.x * q.w + q.y * q.z ), (sqw - sqx + sqy - sqz ));
			this.y = Math.atan2(2 * (q.x * q.z + q.y * q.w ), (sqw + sqx - sqy - sqz ));
			this.z = Math.asin(MathUtil.clamp(2 * (q.z * q.w - q.x * q.y ),-1,1));

		}
		return this;
	}

	public function getScaleFromMatrix(m:Matrix4):Vector3
	{
		var sx = this.setTo(m.elements[0], m.elements[1], m.elements[2]).length;
		var sy = this.setTo(m.elements[4], m.elements[5], m.elements[6]).length;
		var sz = this.setTo(m.elements[8], m.elements[9], m.elements[10]).length;

		this.x = sx;
		this.y = sy;
		this.z = sz;

		return this;
	}
	
	public function equals(value:Vector3):Bool
	{
		return value.x == this.x && value.y == this.y && this.z == value.z;
	}
	
	public function isZero():Bool
	{
		return this.lengthSq < 0.0001;
	}
	
	public function clone():Vector3
	{
		return new Vector3(this.x, this.y, this.z);
	}
}