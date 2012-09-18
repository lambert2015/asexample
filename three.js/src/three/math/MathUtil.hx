package three.math;

/**
 * ...
 * @author andy
 */

class MathUtil 
{
	public static inline var LN2:Float = untyped Math.LN2;
	public static inline var RAD2DEG:Float = 180 / Math.PI;
	public static inline var DEG2RAD:Float = Math.PI / 180;
		
	public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return (value < min ) ? min : ((value > max ) ? max : value );
	}
	
	public static function mapLinear(x:Float, a1:Float, a2:Float, b1:Float, b2:Float):Float
	{
		return b1 + (x - a1 ) * (b2 - b1 ) / (a2 - a1 );
	}
	
	public static function randInt(low:Int, high:Int):Int
	{
		return low + Math.floor(Math.random() * (high - low + 1));
	}
	
	public static function randFloat(low:Float, high:Float):Float
	{
		return low + Math.random() * (high - low );
	}
	
	public static function sign(x:Float):Int
	{
		return (x < 0 ) ? -1 : ((x > 0 ) ? 1 : 0 );
	}
	
	public static inline function isPow2(n:Int):Bool
	{
		var l:Float = Math.log(n) / LN2;
		return Math.floor(l) == l;
	}
	
	public static inline function nearestPow2(n:Int):Int
	{
		var l:Float = Math.log(n) / LN2;
		return Std.int(Math.pow(2, Math.round(l)));
	}
	
	public static function isPowerOfTwo(value:Int):Bool 
	{
		return (value & (value - 1 ) ) == 0;
	}
	
	public static inline function rgb2hex(rgb:Array<Float>):Float
	{
		return (Std.int(rgb[0] * 255) << 16 ) + (Std.int(rgb[1] * 255) << 8 ) + Std.int(rgb[2]) * 255;
	}
}