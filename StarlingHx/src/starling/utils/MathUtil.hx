package starling.utils;

/**
 * ...
 * @author 
 */
class MathUtil
{

	/** Converts an angle from degrees into radians. */
    public static inline function deg2rad(deg:Float):Float
    {
        return deg / 180.0 * Math.PI;   
    }
	
	/** Returns the next power of two that is equal to or bigger than the specified number. */
    public static function getNextPowerOfTwo(number:Int):Int
    {
        if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
            return number;
        else
        {
            var result:int = 1;
            while (result < number) result <<= 1;
            return result;
        }
    }
	
}