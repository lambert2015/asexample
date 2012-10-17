package three.renderers;
import three.core.Object3D;
import three.materials.Material;

/**
 * ...
 * @author 
 */

class WebGLObject 
{
	public var __webglInit:Bool;
	
	public var object:Object3D;
	
	public var render:Bool;
	
	public var opaque:Material;
	public var transparent:Material;
	
	public var buffer:WebGLGeometry;
	
	public var z:Float;

	public function new(object:Object3D) 
	{
		
	}
	
}