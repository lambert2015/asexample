package yanyan.resources.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 数据加载器，采用URLLoader加载 
	 * 
	 * @author harry
	 * @date 11.15 2012
	 * 
	 */
	public class BLoader extends BaseLoader
	{
		public function BLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected var mInstanceLoader:URLLoader = null;
		override public function loadAsset(path:String):void
		{
			mInstanceLoader = new URLLoader();
			mLoader = mInstanceLoader;
			
			mInstanceLoader.load( new URLRequest(path) );
			addLoaderEventHandler( mInstanceLoader );
			
			super.loadAsset(path);
		}
		
		override protected function onLoadComplete(event:Event):void
		{
			mLoaderContent = mInstanceLoader.data;
			
			super.onLoadComplete(event);
		}
	}
}