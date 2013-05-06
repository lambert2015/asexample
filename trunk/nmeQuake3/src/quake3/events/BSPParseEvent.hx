package quake3.events;
import nme.events.Event;
import nme.events.ProgressEvent;

class BSPParseEvent extends Event
{
	public static inline var PROGRESS:String = "progress";
	
	public static inline var COMPLETE:String = "complete";
	
	public static inline var ERROR:String = "error";
	
    private var info:String;
	
	public function new(type:String,info:String) 
	{
		super(type);
		this.info = info;
	}
	
	public function getInfo():String
	{
		return this.info;
	}
	
	override public function clone():Event
	{
		return new BSPParseEvent(type, info);
	}
	
}