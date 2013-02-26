package quake3.net ;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	class DisplayAssetLoader extends AbstractLoader {
		private var _loader : Loader;
		private var _loaderInfo : LoaderInfo;

		public function new() {
			super();
			_loader = new Loader();
			_loaderInfo = _loader.contentLoaderInfo;
		}

		override private function _load(request : URLRequest, content : LoaderContext = null) : Void {
			_loaderInfo.addEventListener(Event.COMPLETE, _loadCompleteHandler, false, 0, true);
			_loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler, false, 0, true);
			_loaderInfo.addEventListener(ProgressEvent.PROGRESS, _loadProgressHandler, false, 0, true);
			_loader.load(request, content);
		}

		public function loadBytes(bytes : ByteArray, context : LoaderContext = null) : Void {
			if (!_loading) {
				_loading = true;
				_loaderInfo.addEventListener(Event.COMPLETE, _loadCompleteHandler, false, 0, true);
				_loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler, false, 0, true);
				_loaderInfo.addEventListener(ProgressEvent.PROGRESS, _loadProgressHandler, false, 0, true);
				_loader.loadBytes(bytes, context);
			}
		}

		override public function stop() : Void {
			if (_loading) {
				super.stop();
				if (_loader != null) {
					_loader.unloadAndStop();
				}
			}
		}

		override public function destroy() : Void {
			stop();
			if (_loaderInfo != null) {
				_loaderInfo.removeEventListener(Event.COMPLETE, _loadCompleteHandler);
				_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler);
				_loaderInfo.removeEventListener(ProgressEvent.PROGRESS, _loadProgressHandler);
				_loaderInfo = null;
			}
			_loader = null;
		}

		override public function unload(?gc : Bool = true) : Void {
			if (_loader != null) {
				_loader.unloadAndStop(gc);
			}
			super.unload(gc);
		}


		override private function _loadCompleteHandler(e : Event) : Void {
			_data = _loader.content;
			_loading = false;
			stop();
			dispatchEvent(e);
		}
	}