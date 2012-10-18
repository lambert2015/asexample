package org.angle3d.utils
{

	public class Assert
	{

		public static function assert(condition:Boolean, info:String):void
		{
			CF::DEBUG
			{
				if (!condition)
					throw new Error(info);
			}
		}
	}
}

