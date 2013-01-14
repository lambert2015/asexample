package yanyan.resources.events
{
	import flash.events.Event;
	
	public class AssetLoadEvent extends Event
	{
		// event type define
		public static const LOAD_COMPLETE:String = 'complete';
		public static const LOAD_FAILED:String = 'failed';
		
		public var assetPath:String = '';
		public var result:Object = null;
		public var fault:Object = null;
		
		public function AssetLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}