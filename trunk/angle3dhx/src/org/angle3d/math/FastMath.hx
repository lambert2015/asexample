package org.angle3d.math;
import org.angle3d.math.Vector3f;
import flash.Lib;

/**
 * <code>FastMath</code> provides 'fast' math approximations and float equivalents of Math
 * functions.  These are all used as static values and functions.
 *
 */
class FastMath
{
	public static inline var PI : Float = Math.PI;
	public static inline var INV_PI : Float = 1 / Math.PI;
	public static inline var HALF_PI : Float = PI * 0.5;
	public static inline var TWO_PI : Float = PI * 2.0;
	
	public static inline var RADTODEG : Float = 180 / PI;
	public static inline var DEGTORAD : Float = PI / 180;
	
	public static inline var ROUNDING_ERROR : Float = 0.0001;
	
	public static inline var ONE_THIRD = 1.0 / 3.0;
	
	public static inline var FLT_EPSILON: Float = 1.1920928955078125E-7;
	
	/** 
	 * A "close to zero" float epsilon value for use
	 */
	public static inline var ZERO_TOLERANCE: Float = 0.0001;
	
	public static inline var MAX_VALUE : Float = untyped __global__["Number"].MAX_VALUE;
	public static inline var MIN_VALUE : Float = untyped __global__["Number"].MIN_VALUE;

	public static inline function nearEqual(a : Float, b : Float,error:Float=0.0001) : Bool
	{
		return(a + ROUNDING_ERROR >= b) &&(a - ROUNDING_ERROR <= b);
	}
	
	public static inline function uint(value : Dynamic) : UInt
	{
		return untyped __global__["uint"](value);
	}
	
	public static inline function isNaN(value : Dynamic) : Bool
	{
		return untyped __global__["isNaN"](value);
	}
	
	public static inline function signum(f:Float):Float
	{
		if (Math.isNaN(f))
		{
			return Math.NaN;
		}
		else if(f > 0)
		{
			return 1;
		}
		else if (f < 0)
		{
			return -1;
		}
		else
		{
			return 0;
		}
	}
	
	public static inline function fclamp(value : Float, low : Float, high : Float) : Float
	{
		if(value < low)
		{
			return low;
		} 
		else if(value > high)
		{
			return high;
		} 
		else 
		{
			return value;
		}
	}
	
	public static inline function clamp(value : Int, low : Int, high : Int) : Int
	{
		if(value <low)
		{
			return low;
		} 
		else if(value > high)
		{
			return high;
		} 
		else 
		{
			return value;
		}
	}
	
	public static inline function abs(x : Int) : Int
	{
		return(x < 0) ? - x : x;
	}
	
	public static inline function fabs(x : Float) : Float
	{
		return(x < 0) ? -x : x;
	}
	
	public static inline function fmin(a : Float, b : Float) : Float
	{
		return(a < b) ? a : b;
	}
	
	public static inline function fmax(a : Float, b : Float) : Float
	{
		return(a > b) ? a : b;
	}
	
	public static inline function min(a : Int, b : Int) : Int
	{
		return(a < b) ? a : b;
	}
	
	public static inline function max(a : Int, b : Int) : Int
	{
		return(a > b) ? a : b;
	}
	
	//test 100000 times,this take 13ms,and Math.floor take 22ms
	public static inline function floor(x:Float) : Int
	{
		var f:Int = cast x;
		if (x < 0 && f != x) f--;
		return f;
	}
	
	/**
	 * This method produces identical results to Math.ceil() for all normal input values
	 *(one which fall inside the allowed range of the int type).
	 */
	public static inline function ceil(x:Float) : Int
	{
		var f:Int = cast x;
		if (x == f) return f;
		else
		{
			x += 1;
			var f:Int = cast x;
			if (x < 0 && f != x) f--;
			return f;
		}
	}
	
	/**
	 * This method produces identical results to Math.round() for all normal input values
	 *(one which fall inside the allowed range of the int type).
	 */
	public static inline function round(d : Float) : Int
	{
		return floor(d + 0.5);
	}
	
	public static inline function getPowerOfTwo(value:Int):Int
	{
		var tmp:Int = 1;
		while (tmp < value)
			tmp <<= 1;
		return tmp;
	}
	
	/**
	* test 100000 times,this 4ms,and Math.pow 18ms
	* This method produces results which are nearly identical to Math.pow(), although the
	* last few digits may be different due to numerical error.  Unlike Math.pow(), this
	* method requires the exponent to be an integer.
	*/
	public static inline function pow(base : Float, exponent : Int) : Float
	{
		if(exponent <0)
		{
			exponent = - exponent;
			base = 1.0 / base;
		}
		var result : Float = 1.0;
		while(exponent != 0)
		{
			if((exponent&1) == 1)
			result *= base;
			base *= base;
			exponent = exponent>> 1;
		}
		return result;
	}
	
	/**
     * Linear interpolation from startValue to endValue by the given percent.
     * Basically: ((1 - percent) * startValue) + (percent * endValue)
     * 
     * @param scale
     *            scale value to use. if 1, use endValue, if 0, use startValue.
     * @param startValue
     *            Begining value. 0% of f
     * @param endValue
     *            ending value. 100% of f
     * @return The interpolated value between startValue and endValue.
     */
    public static inline function interpolateLinear(scale:Float,startValue:Float,endValue:Float):Float
	{
        if (startValue == endValue || scale <= 0) 
		{
            return startValue;
        }
        else if (scale >= 1) 
		{
            return endValue;
        }
		else 
		{
			return startValue + (endValue-startValue) * scale;
		}
    }
	
	/**
     * Linear interpolation from startValue to endValue by the given percent.
     * Basically: ((1 - percent) * startValue) + (percent * endValue)
     *
     * @param scale
     *            scale value to use. if 1, use endValue, if 0, use startValue.
     * @param startValue
     *            Begining value. 0% of f
     * @param endValue
     *            ending value. 100% of f
     * @param store a vector3f to store the result
     * @return The interpolated value between startValue and endValue.
     */
    public static function interpolateLinearVector(scale:Float, startValue:Vector3f, endValue:Vector3f, store:Vector3f = null):Vector3f 
	{
        if (store == null) 
		{
            store = new Vector3f();
        }
        store.x = interpolateLinear(scale, startValue.x, endValue.x);
        store.y = interpolateLinear(scale, startValue.y, endValue.y);
        store.z = interpolateLinear(scale, startValue.z, endValue.z);
        return store;
    }
}
