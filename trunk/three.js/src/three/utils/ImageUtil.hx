package three.utils;
import js.Dom;
/**
 * ...
 * @author 
 */

class ImageUtil 
{
	public static inline function createImage():Image
	{
		return untyped __js__("new Image()");
	}
	
}