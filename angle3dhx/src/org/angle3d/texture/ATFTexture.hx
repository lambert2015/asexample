package org.angle3d.texture;

import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import flash.display3D.textures.TextureBase;
import flash.Lib;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.utils.Endian;

import org.angle3d.utils.TextureUtil;

#if debug
import org.angle3d.utils.Assert;
#end

/**
 * adobe atf file
 * @author andy
 */
class ATFTexture extends TextureMap
{
	private var _byteArray:ByteArray;

	public function new(data : ByteArray) 
	{
		super(false);
		
		setByteArray(data);
	}
	
	public function getByteArray() : ByteArray
	{
		return _byteArray;
	}
	
	public function setByteArray(byte:ByteArray):Void
	{
		_byteArray = byte;
		_byteArray.position = 0;
		
		//check weather file if really is a compressed texture
		var signature:String = _byteArray.readUTFBytes(3);
		
		#if debug
		Assert.assert(signature == "ATF", "This ByteArray is not a atf file");
		#end

		_byteArray.readByte();
		_byteArray.readByte();
		_byteArray.readByte();

		//Check if this is a CubeMap
		var cubeMap:UInt = byte.readUnsignedByte();
		cubeMap = cubeMap & 0x80;
		#if debug
		Assert.assert(cubeMap != 0x80, "File is a CubeMap.");
		#end
		
		var log2Width:UInt = byte.readUnsignedByte();
		var log2Height:UInt = byte.readUnsignedByte();
		
		invalidateContent();
		
		setSize(Std.int(Math.pow(2, log2Width)), Std.int(Math.pow(2, log2Height)));
	}
	
	override private function uploadContent(texture : TextureBase) : Void
	{
		var texture:Texture = Lib.as(texture, Texture);
		
		texture.uploadCompressedTextureFromByteArray(_byteArray, 0);
	}
	
	override private function createTexture(context : Context3D) : TextureBase
	{
		//TODO 为何用Context3DTextureFormat.Compressed不行呢
		return context.createTexture(_width, _height, Context3DTextureFormat.BGRA, false);
	}
	
}