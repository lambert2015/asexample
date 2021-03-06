package three.renderers;
import js.html.webgl.Texture;
import three.math.Vector2;
import three.ThreeGlobal;
import js.html.webgl.Framebuffer;
/**
 * ...
 * @author 
 */

class WebGLRenderTarget 
{
	public var width:Int;
	public var height:Int;
	
	public var options:Dynamic;
	
	public var wrapS:Int;
	public var wrapT:Int;
	
	public var magFilter:Int;
	public var minFilter:Int;
	
	public var anisotropy:Int;
	
	public var offset:Vector2;
	public var repeat:Vector2;
	
	public var format:Int;
	public var type:Int;
	
	public var depthBuffer:Bool;
	public var stencilBuffer:Bool;
	
	public var generateMipmaps:Bool;
	
	public var needsUpdate:Bool;
	
	public var __webglFramebuffer:Array<Framebuffer>;
	public var __webglRenderbuffer:Array<Framebuffer> ;
	public var __webglTexture:Texture;
	
	public var __oldAnisotropy:Int;

	public function new(width:Int, height:Int, options:Dynamic = null)
	{
		this.width = width;
		this.height = height;

		if (options == null)
		{
			options = { };
		}

		this.wrapS = options.wrapS != null ? options.wrapS : ThreeGlobal.ClampToEdgeWrapping;
		this.wrapT = options.wrapT != null ? options.wrapT : ThreeGlobal.ClampToEdgeWrapping;

		this.magFilter = options.magFilter != null ? options.magFilter : ThreeGlobal.LinearFilter;
		this.minFilter = options.minFilter != null ? options.minFilter : ThreeGlobal.LinearMipMapLinearFilter;

		this.anisotropy = options.anisotropy != null ? options.anisotropy : 1;

		this.offset = new Vector2(0, 0);
		this.repeat = new Vector2(1, 1);

		this.format = options.format != null ? options.format : ThreeGlobal.RGBAFormat;
		this.type = options.type != null ? options.type : ThreeGlobal.UnsignedByteType;

		this.depthBuffer = options.depthBuffer != null ? options.depthBuffer : true;
		this.stencilBuffer = options.stencilBuffer != null ? options.stencilBuffer : true;

		this.generateMipmaps = true;
	}
		
	public function clone():WebGLRenderTarget
	{
		var result:WebGLRenderTarget = new WebGLRenderTarget(this.width, this.height);

		result.wrapS = this.wrapS;
		result.wrapT = this.wrapT;

		result.magFilter = this.magFilter;
		result.anisotropy = this.anisotropy;

		result.minFilter = this.minFilter;

		result.offset.copy(this.offset);
		result.repeat.copy(this.repeat);

		result.format = this.format;
		result.type = this.type;

		result.depthBuffer = this.depthBuffer;
		result.stencilBuffer = this.stencilBuffer;

		result.generateMipmaps = this.generateMipmaps;

		return result;
	}
}