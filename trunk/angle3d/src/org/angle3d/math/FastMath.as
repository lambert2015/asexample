package org.angle3d.math
{
	import org.angle3d.math.Vector3f;

	public class FastMath
	{
		public static const ONE_THIRD:Number = 1.0 / 3.0;
		public static const INVERT_255:Number = 1.0 / 255;
		public static const PI:Number = Math.PI;
		public static const INV_PI:Number = 1 / Math.PI;
		public static const HALF_PI:Number = PI * 0.5;
		public static const TWO_PI:Number = PI * 2.0;

		public static const RADTODEG:Number = 180 / PI;
		public static const DEGTORAD:Number = PI / 180;

		public static const ROUNDING_ERROR:Number = 0.0001;

		public static const FLT_EPSILON:Number = 1.1920928955078125E-7;

		/**
		 * A "close to zero" float epsilon value for use
		 */
		public static const ZERO_TOLERANCE:Number = 0.0001;

		[Inline]
		public static function nearEqual(a:Number, b:Number, roundError:Number = 0.0001):Boolean
		{
			return (a + roundError >= b) && (a - roundError <= b);
		}

		[Inline]
		public static function randomInt(min:int, max:int):int
		{
			return min + int((max - min + 1) * Math.random());
		}

		[Inline]
		public static function rangeRandom(min:Number, max:Number):Number
		{
			return min + (max - min) * Math.random();
		}

		[Inline]
		public static function signum(f:Number):Number
		{
			if (isNaN(f))
			{
				return NaN;
			}
			else if (f > 0)
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

		[Inline]
		public static function fclamp(value:Number, low:Number, high:Number):Number
		{
			if (value < low)
			{
				return low;
			}
			else if (value > high)
			{
				return high;
			}
			else
			{
				return value;
			}
		}

		[Inline]
		public static function clamp(value:int, low:int, high:int):int
		{
			if (value < low)
			{
				return low;
			}
			else if (value > high)
			{
				return high;
			}
			else
			{
				return value;
			}
		}

		[Inline]
		public static function abs(x:int):int
		{
			return (x < 0) ? -x : x;
		}

		[Inline]
		public static function fabs(x:Number):Number
		{
			return (x < 0) ? -x : x;
		}

		[Inline]
		public static function fmin(a:Number, b:Number):Number
		{
			return (a < b) ? a : b;
		}

		[Inline]
		public static function fmax(a:Number, b:Number):Number
		{
			return (a > b) ? a : b;
		}

		[Inline]
		public static function min(a:int, b:int):int
		{
			return (a < b) ? a : b;
		}

		[Inline]
		public static function max(a:int, b:int):int
		{
			return (a > b) ? a : b;
		}

		public static function getPowerOfTwo(value:int):int
		{
			var tmp:int = 1;
			while (tmp < value)
				tmp <<= 1;
			return tmp;
		}

		public static function log2(value:int):int
		{
			var result:int = -1;
			while (value > 0)
			{
				value >>= 1;
				result++;
			}
			return result;
		}

		/**
		* test 100000 times,this 4ms,and Math.pow 18ms
		* This method produces results which are nearly identical to Math.pow(), although the
		* last few digits may be different due to numerical error.  Unlike Math.pow(), this
		* method requires the exponent to be an integer.
		*/
		public static function pow(base:Number, exponent:int):Number
		{
			if (exponent < 0)
			{
				exponent = -exponent;
				base = 1.0 / base;
			}
			var result:Number = 1.0;
			while (exponent != 0)
			{
				if ((exponent & 1) == 1)
					result *= base;
				base *= base;
				exponent = exponent >> 1;
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
		public static function lerp(startValue:Number, endValue:Number, interp:Number):Number
		{
			if (interp <= 0)
			{
				return startValue;
			}
			else if (interp >= 1)
			{
				return endValue;
			}
			else
			{
				return startValue + (endValue - startValue) * interp;
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
		public static function lerpVector3(startValue:Vector3f, endValue:Vector3f, interp:Number, store:Vector3f = null):Vector3f
		{
			if (store == null)
			{
				store = new Vector3f();
			}
			store.x = lerp(startValue.x, endValue.x, interp);
			store.y = lerp(startValue.y, endValue.y, interp);
			store.z = lerp(startValue.z, endValue.z, interp);
			return store;
		}
	}
}


