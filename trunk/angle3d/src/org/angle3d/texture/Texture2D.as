package org.angle3d.texture
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;

	import org.angle3d.utils.Assert;
	import org.angle3d.utils.TextureUtil;


	/**
	 * ...
	 * @author andy
	 */
	public class Texture2D extends TextureMapBase
	{
		private var mBitmapData:BitmapData;

		public function Texture2D(bitmapData:BitmapData, mipmap:Boolean = false)
		{
			super(mipmap);

			setBitmapData(bitmapData);
		}

		public function getBitmapData():BitmapData
		{
			return mBitmapData;
		}

		public function setBitmapData(value:BitmapData):void
		{
			if (value == mBitmapData)
				return;

			CF::DEBUG
			{
				Assert.assert(TextureUtil.isBitmapDataValid(value), "Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
			}

			invalidateContent();

			setSize(value.width, value.height);

			mBitmapData = value;
		}

		override protected function createTexture(context:Context3D):TextureBase
		{
			return context.createTexture(mWidth, mHeight, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
		}

		override protected function uploadTexture():void
		{
			var t:Texture = mTexture as Texture;
			if (mMipmap)
			{
				MipmapGenerator.generateMipMaps(mBitmapData, t, null, true);
			}
			else
			{
				t.uploadFromBitmapData(mBitmapData);
			}
		}
	}
}

