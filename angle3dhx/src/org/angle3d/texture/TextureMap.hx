package org.angle3d.texture;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import flash.display3D.textures.TextureBase;
import flash.utils.ByteArray;

/**
 * ...
 * @author andy
 */

class TextureMap extends TextureMapBase
{
	public function new(mipmap:Bool = false) 
	{
		super(mipmap);
	}
	
	override private function createTexture(context : Context3D) : TextureBase
	{
		return context.createTexture(_width, _height, Context3DTextureFormat.BGRA, false);
	}
}