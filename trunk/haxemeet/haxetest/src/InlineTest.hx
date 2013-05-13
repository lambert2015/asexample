package ;
import flash.Lib;

/**
 * ...
 * @author 
 */
class InlineTest
{
	static function main()
	{
		new InlineTest();
	}

	public function new() 
	{
		var v0:Float = abs(-3.45);
		var v1:Float = abs( -v0);
		
	}
	
	private inline function abs(value:Float):Float
	{
		return value >= 0 ? value : -value;
	}
	
}