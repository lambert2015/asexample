package org.angle3d.net;
import flash.net.URLRequest;

/**
 * ...
 * @author andy
 */
class TextureLoader extends BitmapLoader
{
    private var _name:String;
	public function new() 
	{
		super();
	}
	
	public function loadTexture(name:String, url:String):Void
	{
		setName(name);
		load(new URLRequest(url));
	}
	
	public function getName():String
	{
		return _name;
	}
	
	public function setName(name:String):Void
	{
		_name = name;
	}
	
}