package org.angle3d.utils
{

	import flash.utils.getTimer;

	public class TimerUtil
	{
		/**
		 * 以秒为单位返回当前运行时间
		 * @return
		 */
		public static function getTimeInSeconds():Number
		{
			return getTimer() * 0.001;
		}
	}
}

