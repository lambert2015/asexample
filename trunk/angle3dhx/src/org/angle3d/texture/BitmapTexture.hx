package org.angle3d.texture;


import flash.display3D.textures.Texture;
import flash.display3D.textures.TextureBase;
import flash.Lib;
import flash.display.BitmapData;

import org.angle3d.utils.TextureUtil;

#if debug
import org.angle3d.utils.Assert;
#end

/**
 * ...
 * @author andy
 */
class BitmapTexture extends TextureMap
{
	private var _bitmapData:BitmapData;

	public function new(bitmapData : BitmapData,mipmap:Bool = false) 
	{
		super(mipmap);
		
		setBitmapData(bitmapData);
	}
	
	public function getBitmapData() : BitmapData
	{
		return _bitmapData;
	}

	public function setBitmapData(value : BitmapData) : Void
	{
		if (value == _bitmapData) return;

		#if debug
		Assert.assert(TextureUtil.isBitmapDataValid(value),
			"Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
		#end

		invalidateContent();
		
		setSize(value.width, value.height);

		_bitmapData = value;
	}
	
	override private function uploadContent(texture : TextureBase) : Void
	{
		if (_mipmap)
		{
			MipmapGenerator.generateMipMaps(_bitmapData, Lib.as(texture,Texture), null, true);
		}
		else
		{
			Lib.as(texture, Texture).uploadFromBitmapData(_bitmapData, 0);
		}
	}
	
}