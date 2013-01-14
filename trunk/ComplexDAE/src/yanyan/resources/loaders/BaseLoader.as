package yanyan.resources.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import yanyan.resources.events.AssetLoadEvent;
	import yanyan.resources.AssetLoaderManager;
	
	/**
	 * 各种Loader的基类
	 *  
	 * @author harry
	 * @date 11.15 2012
	 * 
	 */
	public class BaseLoader extends EventDispatcher
	{
		protected var mLoader:Object = null;
		protected var mLoaderContent:Object = null;
		protected var mFilePath:String = '';
		
		
		public function BaseLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public function get loader():Object
		{
			return mLoader;
		}
		
		public function get loaderContent():Object
		{
			return mLoaderContent;
		}
		
		public function get filePath():String
		{
			return mFilePath;
		}
		
		public function loadAsset(path:String):void
		{
			mFilePath = path;
		}
		
		protected function addLoaderEventHandler(loader:EventDispatcher):void
		{
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityErrorHandler);
		}
		
		protected function removeLoaderEventHandler(loader:EventDispatcher):void
		{
			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOErrorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityErrorHandler);		
		}
		
		protected function onLoadComplete(event:Event):void
		{
			notifyLoaderEvent(AssetLoadEvent.LOAD_COMPLETE);
			
			// remove listener
			if( mLoader )
				removeLoaderEventHandler(loader as EventDispatcher);
		}
		
		protected function onLoadIOErrorHandler(event:IOErrorEvent):void
		{
			trace("$error: load asset ioError! path=", mFilePath);
			
			notifyLoaderEvent(AssetLoadEvent.LOAD_FAILED, 'ioError');
			
			// remove listener
			if( mLoader )
				removeLoaderEventHandler(loader as EventDispatcher);
		}
		
		protected function onLoadSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			notifyLoaderEvent(AssetLoadEvent.LOAD_FAILED, 'securityError');
			
			// remove listener
			if( mLoader )
				removeLoaderEventHandler(loader as EventDispatcher);
		}
		
		
		public function notifyLoaderEvent(type:String, failCause:String=null):void
		{
			var event:AssetLoadEvent = new AssetLoadEvent(type);
			event.assetPath = filePath;
			var data:Object = {};
			if( type == AssetLoadEvent.LOAD_COMPLETE )
			{
				data['data'] = mLoaderContent;
				event.result = data;
			}
			else
			{
				data['detail'] = failCause;
				event.fault = data;
			}
			
			dispatchEvent( event );
		}
		
	}
}