package quake3.net;

import nme.events.IEventDispatcher;
import nme.net.URLRequest;
import nme.system.LoaderContext;

interface ILoader extends IEventDispatcher {

	function load(request : URLRequest, ?content : LoaderContext = null) : Void;

	function stop() : Void;

	function unload(?gc : Bool = true) : Void;

	function destroy() : Void;

	function getData() : Dynamic;
}