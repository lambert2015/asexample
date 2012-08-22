package three.math;

/**
 * andy
 * @author 
 */

class Vector3 
{
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
	
	public function lengthSq():Float
	{
		return this.x * this.x + this.y * this.y + this.z * this.z;
	}
	
	public function length():Float
	{
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
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
	
	public function setLength(value:Float):Vector3
	{
		return this.normalize().multiplyScalar(value);
	}
	
	public function lerpSelf(value:Vector3, interp:Float):Vector3
	{
		this.x += (value.x - this.x) * interp;
		this.y += (value.y - this.y) * interp;
		this.z += (value.z - this.z) * interp;
		return this;
	}
	
	public function equals(value:Vector3):Bool
	{
		return value.x == this.x && value.y == this.y && this.z == value.z;
	}
	
	public function isZero():Bool
	{
		return this.lengthSq() < 0.0001;
	}
	
	public function clone():Vector3
	{
		return  new Vector3(this.x, this.y, this.z);
	}
}