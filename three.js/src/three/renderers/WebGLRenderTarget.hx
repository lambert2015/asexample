package three.renderers;
import three.math.Vector2;
import UserAgentContext;
import three.Three;
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
	
	public var __webglFramebuffer:Array<WebGLFramebuffer>;
	public var __webglRenderbuffer:Array<WebGLRenderbuffer> ;
	public var __webglTexture:Array<WebGLTexture>;

	public function new(width:Int, height:Int, options:Dynamic = null)
	{
		this.width = width;
		this.height = height;

		if (options == null)
		{
			options = { };
		}

		this.wrapS = options.wrapS != null ? options.wrapS : Three.ClampToEdgeWrapping;
		this.wrapT = options.wrapT != null ? options.wrapT : Three.ClampToEdgeWrapping;

		this.magFilter = options.magFilter != null ? options.magFilter : Three.LinearFilter;
		this.minFilter = options.minFilter != null ? options.minFilter : Three.LinearMipMapLinearFilter;

		this.anisotropy = options.anisotropy != null ? options.anisotropy : 1;

		this.offset = new Vector2(0, 0);
		this.repeat = new Vector2(1, 1);

		this.format = options.format != null ? options.format : Three.RGBAFormat;
		this.type = options.type != null ? options.type : Three.UnsignedByteType;

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