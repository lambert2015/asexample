package quake3.net ;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	class AbstractLoader extends EventDispatcher,implements ILoader {
		private var _loading : Bool;
		private var _data : Dynamic;

		public function new() {
			super();
			_loading = false;
		}

		public function getData() : Dynamic {
			return _data;
		}

		public function load(request : URLRequest, ?content : LoaderContext = null) : Void {
			if (!_loading) {
				_loading = true;
				_load(request, content);
			}
		}

		public function stop() : Void {
			_loading = false;
		}

		public function destroy() : Void {

		}

		private function _load(request : URLRequest, ?content : LoaderContext = null) : Void {
			
		}

		private function _loadCompleteHandler(e : Event) : Void {
			stop();
			dispatchEvent(e);
		}

		private function _loadIOErrorHandler(e : IOErrorEvent) : Void {
			stop();
			dispatchEvent(e);
		}

		private function _loadProgressHandler(e : ProgressEvent) : Void {
			dispatchEvent(e);
		}

		public function unload(?gc : Bool = true) : Void {
			stop();
			_data = null;
		}

	}