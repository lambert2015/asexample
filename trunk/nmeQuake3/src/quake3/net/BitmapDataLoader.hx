package quake3.net;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.Lib;
import nme.net.URLRequest;
import nme.system.LoaderContext;
	

class BitmapDataLoader extends DisplayAssetLoader 
{
	private var _request:URLRequest;

	public function new() 
	{
		super();
	}

	override private function _load(request:URLRequest, content:LoaderContext = null):Void 
	{
		super._load(request, content);
		_request = request;
	}

	public function getRequest():URLRequest 
	{
		return _request;
	}

	override private function _loadCompleteHandler(e:Event):Void 
	{
		var bmp:Bitmap = Lib.as(_loader.content,Bitmap);
		if (null == bmp) 
		{
		   _loadIOErrorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "this asset is not bitmapData"));
		} else {
			_data = bmp.bitmapData;
			_loading=false;
			stop();
			dispatchEvent(e);
		}
	}
		
	public function getBitmapData():BitmapData
	{
		return Lib.as(_data,BitmapData);
	}
}