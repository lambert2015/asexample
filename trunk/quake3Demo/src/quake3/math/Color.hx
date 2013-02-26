package quake3.math;
@:final class Color
{
	public var a : Float ;
	public var r : Float ;
	public var g : Float ;
	public var b : Float ;

	public function new(r : Float = 0, g : Float = 0, b : Float = 0, a : Float = 1)
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
	
	public inline function setRGBA(r : Float, g : Float, b : Float, a : Float=1) : Void
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
	
	public inline function getColor() : UInt
	{
		return(Std.int(a*255) <<24 | Std.int(r*255) <<16 | Std.int(g*255) <<8 | Std.int(b*255));
	}
	
	public inline function setColor(color : UInt) : Void
	{
		a = (color >> 24 & 0xFF) / 255;
		r = (color>> 16 & 0xFF) / 255;
		g = (color>> 8 & 0xFF) / 255;
		b = (color & 0xFF) / 255;
	}
	
	public inline function clone() : Color
	{
		return new Color(r, g, b, a);
	}
	
	public inline function copy(other : Color) : Void
	{
		r = other.r;
		g = other.g;
		b = other.b;
		a = other.a;
	}
	
	public inline function getInterpolated(other : Color, d : Float) : Color
	{
		if(d <0) d = 0;
		if(d> 1) d = 1;
		var inv : Float = 1 - d;
		var c : Color = new Color();
		c.a =(a * d + inv * other.a);
		c.r =(r * d + inv * other.r);
		c.g =(g * d + inv * other.g);
		c.b =(b * d + inv * other.b);
		return c;
	}
	
	public function toString() : String
	{
		return "[Color(" + r + "," + g + "," + b + "," + a + ")]";
	}
}
