package org.angle3d.texture
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.TextureBase;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author andy
	 */

	public class TextureMap extends TextureMapBase
	{
		public function TextureMap(mipmap:Boolean=false)
		{
			super(mipmap);
		}

		override protected function createTexture(context:Context3D):TextureBase
		{
			return context.createTexture(mWidth, mHeight, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
		}
	}
}

