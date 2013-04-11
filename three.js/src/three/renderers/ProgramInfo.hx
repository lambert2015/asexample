package three.renderers;

/**
 * ...
 * @author andy
 */

class ProgramInfo 
{
	public var program:Program3D;
	public var usedTimes:Int;
	public var code:String;
	public var id:Int;
	public var uniforms:Dynamic;
	public var attributes:Dynamic;
	
	public function new()
	{
		usedTimes = 0;
		uniforms = { };
		attributes = { };
	}
}