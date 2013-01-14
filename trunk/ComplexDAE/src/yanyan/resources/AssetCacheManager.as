package yanyan.resources
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 资源内存缓存管理，同一对象使用共享内存
	 *  
	 * @author harry
	 * @date 11.18 2012
	 * 
	 */
	public class AssetCacheManager extends EventDispatcher
	{
		public static var mInstance:AssetCacheManager = null;
		
		public static function get instance():AssetCacheManager
		{
			if( !mInstance )
				mInstance = new AssetCacheManager(new SingleInstance);
			
			return mInstance;
		}
		
		public function AssetCacheManager(vo:SingleInstance)
		{
			if( !vo )
				throw new Error('$error: in single mode.');
			
			arrayAssetCacheMap[BITMAP_CACHE] = new Dictionary();
			arrayAssetCacheMap[TEXTURE_CACHE] = new Dictionary();
		}
		
		
		
		
		/*
		 * asset cache data struction 
		 * 
		 */
		protected var BITMAP_CACHE:uint = 1;
		protected var TEXTURE_CACHE:uint = 2;
		protected var arrayAssetCacheMap:Array = [];
		protected function checkAssetCache(type:uint, key:String):Boolean
		{
			var dict:Dictionary = arrayAssetCacheMap[type];
			
			return dict[key];
		}
		
		protected function pushAssetCache(type:uint, key:String, data:Object):void
		{
			var dict:Dictionary = arrayAssetCacheMap[type];
			dict[key] = data;
		}
		
		protected function shiftAssetCache(type:uint, key:String):void
		{
			var dict:Dictionary = arrayAssetCacheMap[type];
			if( key )
			{
				dict[key] = null;
				delete dict[key];
			}
			else
			{
				for(var p:String in dict)
				{
					dict[p] = null;
					delete dict[p];
				}
			}
		}
		
		protected function getAssetCache(type:uint, key:String):Object
		{
			var dict:Dictionary = arrayAssetCacheMap[type];
			return dict[key];
		}
		
		
		
		
		
		/*
		 * Bitmap asset cache 
		 * 
		 */
		public function hasBitmapCache(key:String):Boolean
		{
			return checkAssetCache(BITMAP_CACHE, key);
		}
		
		public function addBitmapCache(key:String, bit:BitmapData):void
		{
			pushAssetCache(BITMAP_CACHE, key, bit);
		}
		
		public function getBitmapCache(key:String):BitmapData
		{
			return getAssetCache(BITMAP_CACHE, key) as BitmapData;
		}
		
		public function clearBitmapCache(key:String=null):void
		{
			shiftAssetCache(BITMAP_CACHE, key);
		}
		
		
		
		/*
		 * Texture cache 
		 * 
		 * 
		 */
		public function hasTextureCache(key:String):Boolean
		{
			return checkAssetCache(TEXTURE_CACHE, key);
		}
		
		public function addTextureCache(key:String, tex:Texture):void
		{
			pushAssetCache(TEXTURE_CACHE, key, tex);
		}
		
		public function getTextureCache(key:String):Texture
		{
			return getAssetCache(TEXTURE_CACHE, key) as Texture;
		}
		
		public function clearTextureCache(key:String=null):void
		{
			shiftAssetCache(TEXTURE_CACHE, key);
		}
		
		
		
		
	}
}
class SingleInstance
{
	// ...
}