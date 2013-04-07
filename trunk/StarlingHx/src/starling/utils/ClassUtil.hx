package starling.utils;

/**
 * ...
 * @author 
 */
class ClassUtil
{

	public static inline function getQualifiedClassName(c:Class<Dynamic>):String 
	{
		return untyped __global__["flash.utils.getQualifiedClassName"](c);
	}
	
}