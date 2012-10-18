package org.angle3d.texture;
import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.CubeTexture;
import flash.display3D.textures.TextureBase;
import flash.Lib;
import flash.Vector;

import org.angle3d.utils.TextureUtil;

#if debug
import org.angle3d.utils.Assert;
#end
/**
 * ...
 * @author andy
 */
//为何CubeTexture必须要生成mipmap,否则报错
class CubeTextureMap extends TextureMapBase 
{
	private var _bitmapDatas:Vector<BitmapData>;

	public function new(posX : BitmapData, negX : BitmapData, 
	                    posY : BitmapData, negY : BitmapData, 
						posZ : BitmapData, negZ : BitmapData) 
	{
		super(true);
		
		_bitmapDatas = new Vector<BitmapData>(6, true);
		_bitmapDatas[0] = posX;
		_bitmapDatas[1] = negX;
		_bitmapDatas[2] = posY;
		_bitmapDatas[3] = negY;
		_bitmapDatas[4] = posZ;
		_bitmapDatas[5] = negZ;
		
		#if debug
		for (i in 0...6)
		{
			testSize(_bitmapDatas[i]);
		}
		#end

		setSize(posX.width, posX.height);
	}
	
	#if debug
	private inline function testSize(value : BitmapData) : Void
	{
		Assert.assert(value.width == value.height,"BitmapData should have equal width and height!");
		Assert.assert(TextureUtil.isBitmapDataValid(value),"Invalid bitmapData: Width and height must be power of 2 and cannot exceed 1024");
	}
	#end
	
	override private function createTexture(context : Context3D) : TextureBase
	{
		return context.createCubeTexture(_width, Context3DTextureFormat.BGRA, false);
	}
	
	override private function uploadContent(texture : TextureBase) : Void
	{
		var cubeTexture:CubeTexture = Lib.as(texture, CubeTexture);

		for (i in 0...6)
		{
			MipmapGenerator.generateMipMapsCube(_bitmapDatas[i], cubeTexture, i, null, true);
		}
	}
	
}