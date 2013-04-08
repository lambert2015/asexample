package three.core;
import haxe.ds.StringMap;
using three.utils.ArrayUtil;
/**
 * ...
 * @author ...
 */
class EventDispatcher
{
	public var listeners:StringMap<Dynamic>;

	public function new() 
	{
		listeners = new StringMap<Dynamic>();
	}
	
	public function addEventListener(type:String, listener:Dynamic):Void
	{
		var list:Array<Dynamic>;
		if (!listeners.exists(type))
		{
			list = [];
			listeners.set(type, list);
		}
		else
		{
			list = listeners.get(type);
		}
		
		if (list.indexOf(listener) == -1)
		{
			list.push(listener);
		}
	}
	
	public function removeEventListener(type:String, listener:Dynamic):Void
	{
		var list:Array<Dynamic> = listeners.get(type);
		list.remove(listener);
	}
	
	public function dispatchEvent(event:Dynamic):Void
	{
		var listenerArray:Array<Dynamic> = listeners.get(event.type);
		if ( listenerArray != null ) 
		{
			event.target = this;

			for ( i in 0...listenerArray.length) 
			{
				untyped listenerArray[i].call(this, event);
			}
		} 
	}
	
}