package org.angle3d.texture;
import flash.display3D.Context3D;
import flash.display3D.textures.TextureBase;

/**
 * ...
 * @author andy
 */

class TextureMapBase 
{
	private var _width : Int;
	private var _height : Int;
	
	private var _mipmap:Bool;
	
	private var _dirty:Bool;
	
	private var _texture:TextureBase;

	public function new(mipmap:Bool = false) 
	{
		_mipmap = mipmap;
		_dirty = false;
	}
	
	public function getTexture(context:Context3D) : TextureBase
	{
		if (_texture == null || _dirty)
		{
			if (_texture == null)
			    _texture = createTexture(context);
				
			uploadContent(_texture);
			_dirty = false;
		}

		return _texture;
	}
	
	public function setMipMap(value:Bool):Void
	{
		if (_mipmap != value)
		{
			_mipmap = value;
			_dirty = true;
		}
	}
	
	public function getMipMap():Bool
	{
		return _mipmap;
	}
	
	public inline function getWidth():Int
	{
		return _width;
	}
	
	public inline function getHeight():Int
	{
		return _height;
	}
	
	public inline function invalidateContent() : Void
	{
		_dirty = true;
	}
	
	public function dispose() : Void
	{
		if (_texture != null)
		{
			_texture.dispose();
			_texture = null;
			_dirty = false;
		}
	}
	
	private function createTexture(context : Context3D) : TextureBase
	{
		return null;
	}
	
	private function uploadContent(texture : TextureBase) : Void
	{
		
	}
		
	private function setSize(width : Int, height : Int) : Void
	{
		if (_width != width || _height != height)
			dispose();

		_width = width;
		_height = height;
	}
	
}