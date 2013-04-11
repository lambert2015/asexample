package three.utils;
import js.html.ImageElement;
/**
 * ...
 * @author 
 */

class ImageUtil 
{
	public static inline function createImage():ImageElement
	{
		return untyped __js__("new Image()");
	}
	
}