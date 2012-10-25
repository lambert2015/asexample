package away3d.textures
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.TextureBase;

	import away3d.arcane;

	use namespace arcane;

	public class Texture2DBase extends TextureProxyBase
	{
		public var textureFormat:String = Context3DTextureFormat.BGRA;
		public var hasMipmaps:Boolean = false;

		public function Texture2DBase()
		{
			super();
		}

		override protected function createTexture(context:Context3D):TextureBase
		{
			return context.createTexture(_width, _height, Context3DTextureFormat.BGRA, false);
		}
	}
}
