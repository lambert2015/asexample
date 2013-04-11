package three.loaders;
import js.Browser;
import js.html.ImageElement;
import three.core.EventDispatcher;
import three.utils.ImageUtil;

/**
 * ...
 * @author 
 */
class ImageLoader extends EventDispatcher
{
	public var crossOrigin:String;

	public function new() 
	{
		super();
	}
	
	public function load(url:String, image:ImageElement):Void
	{
		if (image == null)
			image = ImageUtil.createImage();
			
		image.addEventListener('load', function(e:Dynamic):Void
		{
			this.dispatchEvent( { type:'load', content:image } );
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