package quake3.bsp;
import flash.Vector;

/**
 * ...
 * @author ...
 */

class BSPShader 
{
    public var shaderName:String;
	public var flags:Int;
	public var contents:Int;
	public var shader:Dynamic;
	public var faces:Vector<BSPFace>;
	public var indexOffset: Int;
	public var elementCount: Int;
	public var visible: Bool;
	public function new() 
	{
		
	}
	
}