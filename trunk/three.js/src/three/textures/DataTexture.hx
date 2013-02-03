package three.textures;

import js.html.Uint8Array;
import three.materials.UVMapping;
/**
 * ...
 * @author andy
 */

class DataTexture extends Texture
{
	public var data:Uint8Array;
	public var width:Int;
	public var height:Int;

	public function new(data:Uint8Array, width:Int, height:Int, mapping:UVMapping)
	{
		super(null, mapping);
		
		this.data = data;
		this.width = width;
		this.height = height;
	}
	
	override public function clone():Texture
	{
		var clonedTexture:DataTexture = new DataTexture(this.data, this.width, this.height, this.mapping);
		
		clonedTexture.wrapS = this.wrapS;
		clonedTexture.wrapT = this.wrapS;

		clonedTexture.magFilter = this.magFilter;
		clonedTexture.minFilter = this.magFilter;

		clonedTexture.anisotropy = this.anisotropy;

		clonedTexture.format = this.format;
		clonedTexture.type = this.type;

		clonedTexture.offset.copy(this.offset);
		clonedTexture.repeat.copy(this.repeat);

		clonedTexture.generateMipmaps = this.generateMipmaps;
		clonedTexture.premultiplyAlpha = this.premultiplyAlpha;
		clonedTexture.flipY = this.flipY;

		return clonedTexture;
	}
	
}