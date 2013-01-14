package yanyan.resources
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import yanyan.resources.events.AssetLoadEvent;
	import yanyan.resources.loaders.BLoader;
	import yanyan.resources.loaders.BaseLoader;
	import yanyan.resources.loaders.CommonLoader;
	import yanyan.resources.loaders.DLoader;
	
	/**
	 * 资源加载管理器, 添加缓存管理，多监听器管理 
	 * 
	 * @author harry
	 * @date 11.15 2012
	 * 
	 */
	public class AssetLoaderManager extends EventDispatcher
	{
		// single instance
		public static var mInstance:AssetLoaderManager = null;
		
		// loader excuter
		public static const CLASS_LOAD_DISPLAYAVAILABLE:uint = 1;
		public static const CLASS_LOAD_DATAFORMAT:uint = 2;
		public static const CLASS_LOAD_BINARY:uint = 3;
		
		public static function get instance():AssetLoaderManager
		{
			if(!mInstance)
				mInstance = new AssetLoaderManager(new SingleInstance);
			
			return mInstance;
		}
		
		public function AssetLoaderManager(vo:SingleInstance)
		{
			if( !vo )
				throw new Error('error: in single mode.');
			
			// map class
			arrayClassFactory[CLASS_LOAD_DISPLAYAVAILABLE] = DLoader;
			arrayClassFactory[CLASS_LOAD_DATAFORMAT] = BLoader;
			arrayClassFactory[CLASS_LOAD_BINARY] = CommonLoader;
		}
		
		
		protected var mAssetLoaderMap:Array = [];// key-path, value-loader
		protected var mLoaderListenerMap:Array = [];// key-path, value-obj(c,f)
		protected var mCacheLoadedContent:Array = [];// key-path, value-content
		public function loadAsset(path:String, completeFun:Function, failedFun:Function=null, isUseCache:Boolean=true):void
		{
			var arrayMap:Array = null;
			var loader:BaseLoader = null;
			
			if( isUseCache )
			{
				if( mCacheLoadedContent[path] )
				{
					// has loader instance, Just notify listener
					notifyListener(completeFun, failedFun, {'data':mCacheLoadedContent[path]});
				}
				else if( mAssetLoaderMap[path] )
				{
					// just in loader stack, add listener to stack
					addListenersMap(path, completeFun, failedFun);
				}
				else
				{
					// get loader for excute
					loader = getLoaderExcuter(path);
					addListenersMap(path, completeFun, failedFun);
					
					// add loader listener
					addLoaderListener( loader );
					loader.loadAsset( path );
				}
			}
			else
			{
				// random it path
				var rndPath:String = path+'?'+Math.random().toString();
				loader = getLoaderExcuter(path);
				addListenersMap(rndPath, completeFun, failedFun);
				
				// add loader listener
				addLoaderListener( loader );
				loader.loadAsset( path );
			}
		}
		
		public const arrayDisplayAvailableExtensionName:Array = ['.swf','.jpg','.png','.jpeg'];
		public const arrayDataExtensionName:Array = ['txt','xml'];
		public var arrayClassFactory:Array = [];
		protected function getLoaderExcuter(p:String):BaseLoader
		{
			var loader:BaseLoader = null;
			var url:String = p.toLocaleLowerCase();
			var type:uint = 0;
			var index:uint=0, extensionName:String;
			
			index = arrayDisplayAvailableExtensionName.length;
			while(index)
			{
				extensionName = arrayDisplayAvailableExtensionName[index];
				if( url.indexOf(extensionName) != -1 )
				{
					type = 1;// Display Available
					break;
				}
				
				index--;
			}
			
			if( type == 0 )
			{
				index = arrayDataExtensionName.length;
				while(index)
				{
					extensionName = arrayDataExtensionName[index];
					if( url.indexOf(extensionName) != -1 )
					{
						type = 2;// Data format
						break;
					}
					
					index--;
				}
			}
			
			if( type == 0 )
				type = 3;
			
			var cl:Class = arrayClassFactory[type];
			loader = new cl;
			
			return loader;
		}
		
		protected function addListenersMap(path:String, c:Function, f:Function):void
		{
			var arrayMap:Array = mLoaderListenerMap[path];
			if( !arrayMap )
			{
				arrayMap = [];
				arrayMap.push( {'completeFun':c, 'failedFun':f} );
				mLoaderListenerMap[path] = arrayMap;
			}
			else
			{
				arrayMap.push( {'completeFun':c, 'failedFun':f} );
			}
		}
		
		protected function notifyListener(cComplete:Function, cFault:Function, result:Object):void
		{
			var completeResult:Object = result['result'];
			var faultResult:Object = result['fault'];
			
			if( completeResult && cComplete != null )
				cComplete.apply(null, [completeResult]);
			
			if( faultResult && cFault != null )
				cFault.apply(null, [cFault]);
		}
		
		protected function addLoaderListener(loader:EventDispatcher):void
		{
			loader.addEventListener(AssetLoadEvent.LOAD_COMPLETE, onLoadEventHandler);
			loader.addEventListener(AssetLoadEvent.LOAD_FAILED, onLoadEventHandler);
		}
		
		protected function removeLoaderListener(loader:EventDispatcher):void
		{
			loader.removeEventListener(AssetLoadEvent.LOAD_COMPLETE, onLoadEventHandler);
			loader.removeEventListener(AssetLoadEvent.LOAD_FAILED, onLoadEventHandler);
		}
		
		protected function onLoadEventHandler(evt:AssetLoadEvent):void
		{
			// notify listener
			var isLoadedComplete:Boolean = (evt.type == AssetLoadEvent.LOAD_COMPLETE);
			var temp:Array = mLoaderListenerMap[evt.assetPath];
			var key:String = isLoadedComplete ? 'completeFun':'failedFun';
			
			if( !temp || !temp.length )
				return;
			
			
			var data:Object = isLoadedComplete ? evt.result : evt.fault;// loader data struct
			var fun:Function = null, item:Object;
			while(temp.length)
			{
				item = temp.shift();
				fun = item[key];
				if( fun != null )
					fun.apply(null, [data]);
				
				// clear function reference
				item['completeFun'] = null;
				item['failedFun'] = null;
			}
			
			// cache result
			var cacheData:Object = mCacheLoadedContent[evt.assetPath];
			if( !cacheData )
				mCacheLoadedContent[evt.assetPath] = cacheData;
			else
			{
				// clear old data cache, if has
				if(isLoadedComplete)
				{
					cacheData.fault = null;
					cacheData.result = data;
				}
				else
				{
					cacheData.result = null;
					cacheData.fault = data;
				}
				
			}
			
		}
		
		
		
		
		
	}
}
class SingleInstance
{
	// ...
}