package quake3.events;

import nme.events.Event;

class QueueLoadEvent extends Event {
	public static inline var ITEM_COMPLETE : String = "itemComplete";
	public static inline var STOP : String = "stop";
	public static inline var COMPLETE : String = Event.COMPLETE;

	private var _data:Dynamic;
	public function new(type : String, data:Dynamic=null, bubbles : Bool = false, cancelable : Bool = false) {
		super(type, bubbles, cancelable);
		_data = data;
	}
	
	public function getData():Dynamic{
		return _data;
	}
}