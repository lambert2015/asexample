package org.angle3d.texture
{

	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.utils.ByteArray;

	import org.angle3d.utils.Assert;


	/**
	 * adobe atf file
	 * @author andy
	 */
	public class ATFTexture extends TextureMapBase
	{
		private var mByteArray:ByteArray;

		private var mContext3DTextureFormat:String;

		public function ATFTexture(data:ByteArray)
		{
			super(false);

			setByteArray(data);
		}

		public function getByteArray():ByteArray
		{
			return mByteArray;
		}

		public function setByteArray(byte:ByteArray):void
		{
			mByteArray = byte;
			mByteArray.position = 0;

			CF::DEBUG
			{
				var signature:String = String.fromCharCode(mByteArray[0], mByteArray[1], mByteArray[2]);
				Assert.assert(signature == "ATF", "Invalid ATF data");
			}

			switch (mByteArray[6])
			{
				case 0:
				case 1:
					mContext3DTextureFormat = Context3DTextureFormat.BGRA;
					break;
				case 2:
				case 3:
					mContext3DTextureFormat = Context3DTextureFormat.COMPRESSED;
					break;
				case 4:
				case 5:
					mContext3DTextureFormat = Context3DTextureFormat.COMPRESSED_ALPHA;
					break;
				default:
					throw new Error("Invalid ATF format");
			}

			var log2Width:uint = mByteArray[7];
			var log2Height:uint = mByteArray[8];
			var numTextures:uint = mByteArray[9];

			mMipmap = numTextures > 1;

			invalidateContent();

			setSize(Math.pow(2, log2Width), Math.pow(2, log2Height));
		}

		public function get context3DTextureFormat():String
		{
			return mContext3DTextureFormat;
		}

		public function set context3DTextureFormat(value:String):void
		{
			mContext3DTextureFormat = value;
			switch (mContext3DTextureFormat)
			{
				case Context3DTextureFormat.BGRA:
					setFormat(TextureFormat.RGBA);
					break;
				case Context3DTextureFormat.COMPRESSED:
					setFormat(TextureFormat.DXT1);
					break;
				case Context3DTextureFormat.COMPRESSED_ALPHA:
					setFormat(TextureFormat.DXT5);
					break;
			}
		}

		override protected function uploadTexture():void
		{
			var t:Texture = mTexture as Texture;

			t.uploadCompressedTextureFromByteArray(mByteArray, 0, false);
		}

		override protected function createTexture(context:Context3D):TextureBase
		{
			return context.createTexture(mWidth, mHeight, mContext3DTextureFormat, false);
		}
	}
}

