package three.renderers;

/**
 * ...
 * @author 
 */

class WebGLRenderTargetCube extends WebGLRenderTarget
{
	public var activeCubeFace:Int;

	public function new(width:Int, height:Int, options:Dynamic = null)
	{
		super(width, height, options);
		
		// PX 0, NX 1, PY 2, NY 3, PZ 4, NZ 5
		this.activeCubeFace = 0;
	}
}