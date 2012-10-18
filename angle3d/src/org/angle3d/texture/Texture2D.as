package org.angle3d.texture
{
	import org.angle3d.texture.TextureMap;

	public class Texture2D extends TextureMap
	{
		public function Texture2D(width:int, height:int, mipmap:Boolean = false)
		{
			super(mipmap);

			this.setSize(width, height);
		}
	}
}
