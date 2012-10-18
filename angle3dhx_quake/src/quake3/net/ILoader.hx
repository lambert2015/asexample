package quake3.net;

import flash.events.IEventDispatcher;
import flash.net.URLRequest;
import flash.system.LoaderContext;

interface ILoader implements IEventDispatcher {

	function load(request : URLRequest, ?content : LoaderContext = null) : Void;

	function stop() : Void;

	function unload(?gc : Bool = true) : Void;

	function destroy() : Void;

	function getData() : Dynamic;
}