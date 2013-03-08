package three.textures;
import js.html.ImageElement;
import three.materials.UVMapping;
import three.math.Vector2;
import three.ThreeGlobal;
/**
 * ...
 * @author 
 */

class Texture 
{
	public static var TextureCount:Int = 0;
	
	public var id:Int;
	public var image:ImageElement;
	
	public var mapping:UVMapping;
	
	public var wrapS:Int;
	public var wrapT:Int;
	
	public var magFilter:Int;
	public var minFilter:Int;
	
	public var anisotropy:Int;
	public var format:Int;
	public var type:Int;
	
	public var offset:Vector2;
	public var repeat:Vector2;
	
	public var generateMipmaps:Bool;
	public var premultiplyAlpha:Bool;
	public var flipY:Bool;
	
	public var needsUpdate:Bool;

	public var __webglInit:Bool;
	public var __webglTexture:js.html.webgl.Texture;
	
	public var __oldAnisotropy:Int;
	
	public function new(image:ImageElement, mapping:UVMapping = null) 
	{
		this.id = TextureCount++;

		this.image = image;

		this.mapping = mapping != null ? mapping : new UVMapping();

		this.wrapS = ThreeGlobal.ClampToEdgeWrapping;
		this.wrapT = ThreeGlobal.ClampToEdgeWrapping;

		this.magFilter = ThreeGlobal.LinearFilter;
		this.minFilter = ThreeGlobal.LinearMipMapLinearFilter;

		this.anisotropy = 1;

		this.format = ThreeGlobal.RGBAFormat;
		this.type = ThreeGlobal.RGBAFormat;

		this.offset = new Vector2(0, 0);
		this.repeat = new Vector2(1, 1);

		this.generateMipmaps = true;
		this.premultiplyAlpha = false;
		this.flipY = true;

		this.needsUpdate = false;
	}
	
	public function onUpdate():Void
	{
		
	}
	
	public function clone():Texture
	{
		var clonedTexture:Texture = new Texture(this.image, this.mapping);
		
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