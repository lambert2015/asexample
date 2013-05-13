package ;
import flash.display.Sprite;

/**
 * ...
 * @author 
 */
class StringUtil
{

	public static inline function connect(a:String,b:String,c:Sprite):String 
	{
		return a + b;
	}
	
	public inline function log(s:String):Void
	{
		#if debug
		trace(s);
		#end
	}
	
}