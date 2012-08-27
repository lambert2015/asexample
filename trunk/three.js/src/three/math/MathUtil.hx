package three.math;

/**
 * ...
 * @author andy
 */

class MathUtil 
{
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
}