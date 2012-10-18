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
		private var _bitmapDatas : Vector.<BitmapData>;

		public function CubeTextureMap(posX : BitmapData, negX : BitmapData,
			posY : BitmapData, negY : BitmapData,
			posZ : BitmapData, negZ : BitmapData)
		{
			super(true);

			_bitmapDatas = new Vector.<BitmapData>(6, true);
			_bitmapDatas[0] = posX;
			_bitmapDatas[1] = negX;
			_bitmapDatas[2] = posY;
			_bitmapDatas[3] = negY;
			_bitmapDatas[4] = posZ;
			_bitmapDatas[5] = negZ;

			CF::DEBUG
			{
				for (var i : int = 0; i < 6; i++)
				{
					testSize(_bitmapDatas[i]);
				}
			}

			setSize(posX.width, posX.height);
		}

		CF::DEBUG
		{
			private function testSize(value : BitmapData) : void
			{
				Assert.assert(value.width == value.height, "BitmapData should have equal width and height!");
				Assert.assert(TextureUtil.isBitmapDataValid(value), "Invalid bitmapData: Width and height must be power of 2 and cannot exceed 1024");
			}

		}

		override protected function createTexture(context : Context3D) : TextureBase
		{
			return context.createCubeTexture(_width, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
		}

		override protected function uploadTexture() : void
		{
			var cubeTexture : CubeTexture = (_texture as CubeTexture);

			for (var i : int = 0; i < 6; i++)
			{
				MipmapGenerator.generateMipMapsCube(_bitmapDatas[i], cubeTexture, i, null, true);
			}
		}
	}
}

