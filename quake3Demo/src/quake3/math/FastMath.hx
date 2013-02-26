package quake3.math;
class FastMath
{
	public static var PI : Float = Math.PI;
	public static var HALF_PI : Float = PI * 0.5;
	public static var TWO_PI : Float = PI * 2.0;
	public static var RADTODEG : Float = 180 / PI;
	public static var DEGTORAD : Float = PI / 180;
	public static var ROUNDING_ERROR : Float = 0.0001;
	
	public static var MAX_VALUE : Float = untyped __global__["Number"].MAX_VALUE;
	public static var MIN_VALUE : Float = untyped __global__["Number"].MIN_VALUE;
	public static var NaN : Float = untyped __global__["NaN"];


	public static inline function equals(a : Float, b : Float) : Bool
	{
		return(a + ROUNDING_ERROR> b) &&(a - ROUNDING_ERROR <b);
	}

	public static inline function uint(value : Dynamic) : UInt
	{
		return untyped __global__["uint"](value);
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
	
	public static inline function fabs(x : Float) : Float
	{
		return(x < 0) ? - x : x;
	}
	
	public static inline function abs(x : Int) : Int
	{
		return(x < 0) ? - x : x;
	}
	
	public static inline function fmin(a : Float, b : Float) : Float
	{
		return(a <b) ? a : b;
	}
	
	public static inline function fmax(a : Float, b : Float) : Float
	{
		return(a> b) ? a : b;
	}
	
	public static inline function min(a : Int, b : Int) : Int
	{
		return(a <b) ? a : b;
	}
	public static inline function max(a : Int, b : Int) : Int
	{
		return(a> b) ? a : b;
	}
	
	//test 100000 times,this take 13ms,and Math.floor take 22ms
	public static inline function floor(d : Float) : Int
	{
		if (d < 0.0)
		{
			var f : Int = Std.int(d);
			if(f != d) f -= 1;
			return f;
		} 
		else 
		{
			return Std.int(d);
		}
	}
	
	/**
	 * This method produces identical results to Math.ceil() for all normal input values
	 *(one which fall inside the allowed range of the int type).
	 */
	public static inline function ceil(d : Float) : Int
	{
		if (d > 0.0)
		{
			var f : Int = Std.int(d);
			if(f != d) f += 1;
			return f;
		} else{
			return Std.int(d);
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
	* This method calculates a fast approximation to the arctan function.  It differs from
	* the true value by no more than 0.005 for any input value.
	* <p>
	* I found this formula on an internet discussion board post by Ranko Bojanic.  The reference
	* cited in that post was
	* <p>
	* Approximation Theory(C. Hastings, Jr., Note 143, Math. Tables Aids. Comp 6, 68(1953))
	*/
	public static inline function atan(d : Float) : Float
	{
		if(d>= 1.0)
		{
			return(0.5 * PI - d /(d * d + 0.28));
		} 
		else if(d <= - 1.0)
		{
			return( - 0.5 * PI - d /(d * d + 0.28));
		} 
		else
		{
			return(d /(1.0 + 0.28 * d * d));
		}
	}
}
