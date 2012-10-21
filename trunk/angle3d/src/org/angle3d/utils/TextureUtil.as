package org.angle3d.utils
{

	import flash.display.BitmapData;

	public class TextureUtil
	{
		private static var MAX_SIZE:int=2048;

		public static function isBitmapDataValid(bitmapData:BitmapData):Boolean
		{
			if (bitmapData == null)
				return true;

			return isDimensionValid(bitmapData.width) && isDimensionValid(bitmapData.height);
		}

		public static function isDimensionValid(d:int):Boolean
		{
			return d >= 2 && d <= MAX_SIZE && isPowerOfTwo(d);
		}

		public static function isPowerOfTwo(value:int):Boolean
		{
			return value != 0 ? ((value & -value) == value) : false;
		}

		public static function getBestPowerOf2(value:int):int
		{
			var p:int=1;

			while (p < value)
				p<<=1;

			if (p > MAX_SIZE)
				p=MAX_SIZE;

			return p;
		}
	}
}


