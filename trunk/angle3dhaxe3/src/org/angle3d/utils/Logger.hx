package org.angle3d.utils;

class Logger
{
	public static inline function log(message:Dynamic):Void
	{
		#if debug
			trace(message);
		#end
	}

	public static inline function warn(message:Dynamic):Void
	{
		#if debug
			trace(message);
		#end
	}
}

