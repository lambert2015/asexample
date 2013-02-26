package quake3.net ;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	class DataLoader extends AbstractLoader {
		private var _loader : URLLoader;

		public function new(?dataFormat : URLLoaderDataFormat = null) {
			super();
			_loader = new URLLoader();
			_loader.dataFormat = (dataFormat == null) ? URLLoaderDataFormat.TEXT : dataFormat;
		}

		override public function stop() : Void {
			if (_loading) {
				super.stop();
				if (_loader != null)
					_loader.close();
			}
		}

		override public function destroy() : Void {
			stop();
			if (_loader != null) {
				_loader.removeEventListener(Event.COMPLETE, _loadCompleteHandler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler);
				_loader.removeEventListener(ProgressEvent.PROGRESS, _loadProgressHandler);
				_loader = null;
			}
		}

		override private function _load(request : URLRequest, ?context : LoaderContext = null) : Void {
			_loader.addEventListener(Event.COMPLETE, _loadCompleteHandler, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler, false, 0, true);
			_loader.addEventListener(ProgressEvent.PROGRESS, _loadProgressHandler, false, 0, true);
			_loader.load(request);
		}

		override private function _loadCompleteHandler(e : Event) : Void {
			_data = _loader.data;
			super._loadCompleteHandler(e);
		}
	}