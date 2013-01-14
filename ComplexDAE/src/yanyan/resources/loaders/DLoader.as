package yanyan.resources.loaders
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	import yanyan.resources.loaders.BaseLoader;
	
	/**
	 * 可视化对象加载器，采用Loader加载 
	 * 
	 * @author harry
	 * @date 11.15 2012
	 * 
	 */
	public class DLoader extends BaseLoader
	{
		public function DLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected var mInstanceLoader:Loader = null;
		override public function loadAsset(path:String):void
		{
			mInstanceLoader = new Loader();
			mLoader = mInstanceLoader;
			
			mInstanceLoader.load( new URLRequest(path) );
			addLoaderEventHandler( mInstanceLoader.contentLoaderInfo );
			
			super.loadAsset(path);
		}
		
		override protected function onLoadComplete(event:Event):void
		{
			mLoaderContent = mInstanceLoader.content;
			
			super.onLoadComplete(event);
		}
	}
}