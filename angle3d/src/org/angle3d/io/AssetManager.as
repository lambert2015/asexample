package org.angle3d.io
{
	import flash.utils.Dictionary;

	import org.assetloader.AssetLoader;
	import org.assetloader.signals.LoaderSignal;

	//TODO 这里仅简单实现了，需要完整的重写
	public class AssetManager
	{
		private static var _instance:AssetManager;

		public static function getInstance():AssetManager
		{
			if (_instance == null)
				_instance = new AssetManager();
			return _instance;
		}

		private var mAssetCache:Dictionary;

		public function AssetManager()
		{
			mAssetCache = new Dictionary();
		}

		/**
		 * 此处需要缓存AssetLoader,这里创建的Loader加载完资源后，根据其设置选择是否缓存其加载的资源。
		 */
		public function createLoader(id:String):AssetLoader
		{
			var loader:AssetLoader = new AssetLoader(id);
			loader.onComplete.add(_loadComplete);
			return loader;
		}

		public function getAsset(id:String):*
		{
			return mAssetCache[id];
		}

		//TODO 最好还能完成资源的解析工作
		private function _loadComplete(signal:LoaderSignal, assets:Dictionary):void
		{
			//cache 资源
			for (var i:* in assets)
			{
				mAssetCache[i] = assets[i];
			}


			(signal.loader as AssetLoader).onComplete.remove(_loadComplete);
		}
	}
}

