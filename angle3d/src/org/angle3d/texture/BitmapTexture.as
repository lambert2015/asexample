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
		private var _bitmapData : BitmapData;

		public function BitmapTexture(bitmapData : BitmapData, mipmap : Boolean = false)
		{
			super(mipmap);

			setBitmapData(bitmapData);
		}

		public function getBitmapData() : BitmapData
		{
			return _bitmapData;
		}

		public function setBitmapData(value : BitmapData) : void
		{
			if (value == _bitmapData)
				return;

			CF::DEBUG
			{
				Assert.assert(TextureUtil.isBitmapDataValid(value),
					"Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
			}

			invalidateContent();

			setSize(value.width, value.height);

			_bitmapData = value;
		}

		override protected function uploadTexture() : void
		{
			var t : Texture = _texture as Texture;
			if (_mipmap)
			{
				MipmapGenerator.generateMipMaps(_bitmapData, t, null, true);
			}
			else
			{
				t.uploadFromBitmapData(_bitmapData);
			}
		}
	}
}

