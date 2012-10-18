package org.angle3d.material.shader
{
	import flash.display3D.textures.TextureBase;
	import org.angle3d.texture.TextureMapBase;

	/**
	 *
	 * @author Andy
	 */
	public class TextureVariable extends ShaderVariable
	{
		public var textureMap:TextureMapBase;

		public function TextureVariable(name:String, size:int)
		{
			super(name, size);
		}
	}
}

