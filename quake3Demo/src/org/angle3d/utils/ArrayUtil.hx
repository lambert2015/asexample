package org.angle3d.utils;

/**
 * ...
 * @author andy
 */
class ArrayUtil 
{
	
	inline static public function indexOf<T>(array:Array<T>, item:T):Int
	{
		return untyped array.indexOf(item);
	}
	
	inline static public function contain<T>(array:Array<T>, item:T):Bool
	{
		var index:Int = indexOf(array, item);
		
		return index != -1;
	}
	
	inline static public function clear<T>(array:Array<T>):Void
	{
		untyped array.length = 0;
	}
	
}