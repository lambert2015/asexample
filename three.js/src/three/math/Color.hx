package three.math;

/**
 * ...
 * @author 
 */

class Color 
{
	public var a:Float;
	public var r:Float;
	public var g:Float;
	public var b:Float;

	public function new(value:Int=0xFF000000) 
	{
		setRGBA(value);
	}
	
	public function setHSV(h:Float, s:Float, v:Float):Color
	{
		var f:Float, p:Float, q:Float, t:Float;
		
		if (v == 0)
		{
			this.r = this.g = this.b = 0;
		}
		else
		{
			var i:Int = Math.floor(h * 6);
			f = (h * 6) - i;
			p = v * (1 - s);
			q = v * (1 - (s * f));
			t = v * (1 - (s * (1 - f)));
			
			if (i == 0)
			{
				this.r = v;
				this.g = t;
				this.b = p;
			}
			else if (i == 1)
			{
				this.r = q;
				this.g = v;
				this.b = p;
			}
			else if ( i == 2)
			{
				this.r = p;
				this.g = v;
				this.b = t;
			}
			else if ( i == 3)
			{
				this.r = p;
				this.g = q;
				this.b = v;
			}
			else if ( i == 4)
			{
				this.r = t;
				this.g = p;
				this.b = v;
			}
			else if (i == 5)
			{
				this.r = v;
				this.g = p;
				this.b = q;
			}
		}
		
		return this;
	}
	
	public function setTo(r:Float, g:Float, b:Float, a:Float = 1.0):Color
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
		return this;
	}
	
	public function lerpSelf(color:Color, interp:Float):Color
	{
		this.r += (color.r - this.r) * interp;
		this.g += (color.g - this.g) * interp;
		this.b += (color.b - this.b) * interp;
		this.a += (color.a - this.a) * interp;
		return this;
	}
	
	public function copy(value:Color):Color
	{
		this.r = value.r;
		this.g = value.g;
		this.b = value.b;
		this.a = value.a;
		return this;
	}
	
	public function clone():Color
	{
		var result:Color = new Color();
		result.copy(this);
		return result;
	}
	
	public var rgb(getRGB, setRGB):Int;
	public function getRGB():Int
	{
		return Math.floor(this.r * 255) << 16 | Math.floor(this.g * 255) << 8 | Math.floor(this.b * 255);
	}
	
	public function setRGB(value:Int):Int
	{
		var invert:Float = 1.0 / 255;
		r = (value >> 16 & 0xFF) * invert;
		g = (value >> 8 & 0xFF) * invert;
		b = (value & 0xFF) * invert;
		return value;
	}
	
	public var rgba(getRGBA, setRGBA):Int;
	public function getRGBA():Int
	{
		return Math.floor(this.a * 255) << 24 | Math.floor(this.r * 255) << 16 | 
		Math.floor(this.g * 255) << 8 | Math.floor(this.b * 255);
	}
	
	public function setRGBA(value:Int):Int
	{
		var invert:Float = 1.0 / 255;
		a = (value >> 24 & 0xFF) * invert;
		r = (value >> 16 & 0xFF) * invert;
		g = (value >> 8 & 0xFF) * invert;
		b = (value & 0xFF) * invert;
		return value;
	}
	
}