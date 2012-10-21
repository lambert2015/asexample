package org.angle3d.texture
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.TextureBase;

	import org.angle3d.utils.TextureUtil;

	CF::DEBUG
	{
		import org.angle3d.utils.Assert;
	}

	/**
	 * ...
	 * @author andy
	 */
//TODO FIXME 为何CubeTexture必须要生成mipmap,否则报错
	public class CubeTextureMap extends TextureMapBase
	{
		private var mBitmapDatas:Vector.<BitmapData>;

		public function CubeTextureMap(posX:BitmapData, negX:BitmapData, posY:BitmapData, negY:BitmapData, posZ:BitmapData, negZ:BitmapData)
		{
			super(true);

			mBitmapDatas=new Vector.<BitmapData>(6, true);
			mBitmapDatas[0]=posX;
			mBitmapDatas[1]=negX;
			mBitmapDatas[2]=posY;
			mBitmapDatas[3]=negY;
			mBitmapDatas[4]=posZ;
			mBitmapDatas[5]=negZ;

			CF::DEBUG
			{
				for (var i:int=0; i < 6; i++)
				{
					testSize(mBitmapDatas[i]);
				}
			}

			setSize(posX.width, posX.height);
		}

		CF::DEBUG
		{
			private function testSize(value:BitmapData):void
			{
				Assert.assert(value.width == value.height, "BitmapData should have equal width and height!");
				Assert.assert(TextureUtil.isBitmapDataValid(value), "Invalid bitmapData: Width and height must be power of 2 and cannot exceed 1024");
			}

		}

		override protected function createTexture(context:Context3D):TextureBase
		{
			return context.createCubeTexture(mWidth, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
		}

		override protected function uploadTexture():void
		{
			var cubeTexture:CubeTexture=(mTexture as CubeTexture);

			for (var i:int=0; i < 6; i++)
			{
				MipmapGenerator.generateMipMapsCube(mBitmapDatas[i], cubeTexture, i, null, true);
			}
		}
	}
}

