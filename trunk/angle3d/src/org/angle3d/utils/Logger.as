package org.angle3d.utils
{
	public class Logger
	{
		public static function log(message : Object) : void
		{
			CF::DEBUG
			{
				trace(message);
			}
		}

		public static function warn(message : Object) : void
		{
			CF::DEBUG
			{
			}
		}
	}
}

