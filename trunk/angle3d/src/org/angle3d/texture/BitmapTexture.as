package org.angle3d.texture
{


	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;

	import org.angle3d.utils.TextureUtil;

	CF::DEBUG
	{
		import org.angle3d.utils.Assert;

	}

	/**
	 * ...
	 * @author andy
	 */
	public class BitmapTexture extends TextureMap
	{
		private var mBitmapData:BitmapData;

		public function BitmapTexture(bitmapData:BitmapData, mipmap:Boolean=false)
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

			mBitmapData=value;
		}

		override protected function uploadTexture():void
		{
			var t:Texture=mTexture as Texture;
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

