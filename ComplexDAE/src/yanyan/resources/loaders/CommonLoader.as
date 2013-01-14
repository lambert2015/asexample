package yanyan.resources.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	/**
	 * 通用的loader，采用URLStream加载 
	 * 
	 * @author harry
	 * @date 11.15 2012
	 * 
	 */
	public class CommonLoader extends BaseLoader
	{
		public function CommonLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected var mInstanceLoader:URLStream = null;
		override public function loadAsset(path:String):void
		{
			mInstanceLoader = new URLStream();
			mLoader = mInstanceLoader;
			
			mInstanceLoader.load( new URLRequest(path) );
			addLoaderEventHandler( mInstanceLoader );
			
			super.loadAsset(path);
		}
		
		override protected function onLoadComplete(event:Event):void
		{
			mLoaderContent = mInstanceLoader;
			
			super.onLoadComplete(event);
		}
		
	}
}