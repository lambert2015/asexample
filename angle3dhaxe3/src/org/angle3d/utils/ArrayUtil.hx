package org.angle3d.utils;

/**
 * ...
 * @author 
 */
class ArrayUtil
{

	public static inline function indexOf<T>(list:Array<T>, item:T):Int
	{
		#if flash
			return untyped list.indexOf(item);
		#else
			return Lambda.indexOf(list, item);
		#end
	}
	
}