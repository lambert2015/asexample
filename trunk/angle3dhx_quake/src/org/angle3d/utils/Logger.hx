package org.angle3d.utils;

import flash.Lib;

class Logger
{
	#if debug
	public static inline function log(message : Dynamic) : Void
	{
		Lib.trace(message);
	}
	#else
	public static inline function log(message : Dynamic) : Void
	{
	}
	#end
	
	public static function warn(message : Dynamic) : Void
	{
		Lib.trace(message);
	}
}
