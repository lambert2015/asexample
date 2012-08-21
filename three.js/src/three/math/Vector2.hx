package three.math;

/**
 * andy
 * @author 
 */

class Vector2 
{
	public var x:Float;
	
	public var y:Float;

	public function new(x:Float = 0, y:Float = 0 ) 
	{
		this.x = x;
		this.y = y;
	}
	
	public function setTo(x:Float, y:Float):Vector2
	{
		this.x = x;
		this.y = y;
		return this;
	}
	
	public function copy(value:Vector2):Vector2
	{
		this.x = value.x;
		this.y = value.y;
		
		return this;
	}
	
	public function add(a:Vector2, b:Vector2):Vector2
	{
		this.x = a.x + b.x;
		this.y = a.y + b.y;
		return this;
	}
	
	public function addSelf(value:Vector2):Vector2
	{
		this.x += value.x;
		this.y += value.y;
		return this;
	}
	
	public function sub(a:Vector2, b:Vector2):Vector2
	{
		this.x = a.x - b.x;
		this.y = a.y - b.y;
		return this;
	}
	
	public function subSelf(value:Vector2):Vector2
	{
		this.x -= value.x;
		this.y -= value.y;
		return this;
	}
	
	public function multiplyScalar(value:Float):Vector2
	{
		this.x *= value;
		this.y *= value;
		return this;
	}
	
	public function divideScalar(value:Float):Vector2
	{
		if (value != 0)
		{
			this.x /= value;
			this.y /= value;
		}
		else
		{
			this.setTo(0, 0);
		}
		return this;
	}
	
	public function negate():Vector2
	{
		return multiplyScalar( -1);
	}
	
	public function dot(value:Vector2):Float
	{
		return this.x * value.x + this.y * value.y;
	}
	
	public function lengthSq():Float
	{
		return this.x * this.x + this.y * this.y;
	}
	
	public function length():Float
	{
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	
	public function normalize():Vector2
	{
		var lengthSquare:Float = this.x * this.x + this.y * this.y;
		if (lengthSquare != 0)
		{
			var len:Float = 1 / lengthSquare;
			this.x *= len;
			this.y *= len;
		}
		else
		{
			this.x = 0;
			this.y = 0;
		}
		
		return this;
	}
	
	public function distanceToSquared(value:Vector2):Float
	{
		var dx:Float = this.x - value.x, dy:Float = this.y - value.y;
		
		return dx * dx + dy * dy;
	}
	
	public function distanceTo(value:Vector2):Float
	{
		var dx:Float = this.x - value.x, dy:Float = this.y - value.y;
		
		return Math.sqrt(dx * dx + dy * dy);
	}
	
	public function setLength(value:Float):Vector2
	{
		return this.normalize().multiplyScalar(value);
	}
	
	public function lerpSelf(value:Vector2, interp:Float):Vector2
	{
		this.x += (value.x - this.x) * interp;
		this.y += (value.y - this.y) * interp;
		return this;
	}
	
	public function equals(value:Vector2):Bool
	{
		return value.x == this.x && value.y == this.y;
	}
	
	public function isZero():Bool
	{
		return this.lengthSq() < 0.0001;
	}
	
	public function clone():Vector2
	{
		return  new Vector2(this.x, this.y);
	}
}