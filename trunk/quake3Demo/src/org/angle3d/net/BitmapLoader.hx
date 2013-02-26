package org.angle3d.net;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.Lib;
import flash.net.URLRequest;
import flash.system.LoaderContext;
	

class BitmapLoader extends DisplayObjectLoader 
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
		} 
		else 
		{
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