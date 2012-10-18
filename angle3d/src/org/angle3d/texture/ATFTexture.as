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
	public class ATFTexture extends TextureMap
	{
		private var _byteArray : ByteArray;

		public function ATFTexture(data : ByteArray)
		{
			super(false);

			setByteArray(data);
		}

		public function getByteArray() : ByteArray
		{
			return _byteArray;
		}

		public function setByteArray(byte : ByteArray) : void
		{
			_byteArray = byte;
			_byteArray.position = 0;

			//check weather file if really is a compressed texture
			var signature : String = _byteArray.readUTFBytes(3);

			CF::DEBUG
			{
				Assert.assert(signature == "ATF", "This ByteArray is not a atf file");
			}

			_byteArray.position += 3;

			//Check if this is a CubeMap
			var cubeMap : uint = byte.readUnsignedByte();
			cubeMap = cubeMap & 0x80;

			CF::DEBUG
			{
				Assert.assert(cubeMap != 0x80, "File is a CubeMap.");
			}

			var log2Width : uint = byte.readUnsignedByte();
			var log2Height : uint = byte.readUnsignedByte();

			invalidateContent();

			setSize(int(Math.pow(2, log2Width)), int(Math.pow(2, log2Height)));
		}

		override protected function uploadTexture() : void
		{
			var t : Texture = _texture as Texture;

			t.uploadCompressedTextureFromByteArray(_byteArray, 0);
		}

		override protected function createTexture(context : Context3D) : TextureBase
		{
			//TODO 为何用Context3DTextureFormat.Compressed不行呢
			return context.createTexture(_width, _height, Context3DTextureFormat.COMPRESSED, false);
		}
	}
}

