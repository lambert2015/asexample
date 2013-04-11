package three.loaders;
import js.Browser;
import js.html.ImageElement;
import three.core.EventDispatcher;
import three.textures.Texture;
import three.utils.ImageUtil;

/**
 * ...
 * @author 
 */
class TextureLoader extends EventDispatcher
{
	public var crossOrigin:String;

	public function new() 
	{
		super();
	}
	
	public function load(url:String):Void
	{
		var image:ImageElement = ImageUtil.createImage();
			
		image.addEventListener('load', function(e:Dynamic):Void
		{
			var texture:Texture = new Texture(image);
			texture.needsUpdate = true;
			this.dispatchEvent( { type:'load', content:texture } );
		},false);
		
		image.addEventListener('error', function(e:Dynamic):Void
		{
			this.dispatchEvent( { type:'error', message : 'Couldn\'t load URL [' + url + ']' } );
		},false);
		
		if (this.crossOrigin != null)
			image.crossOrigin = this.crossOrigin;
		image.src = url;
	}
	
}