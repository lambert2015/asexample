package ;

enum Color 
{
	Red;
	Green;
}

typedef Point3 =
{
	var x:Float;
	var y:Float;
	var z:Float;
}
/**
 * ...
 * @author 
 */
class EnumTest
{
	static function main()
	{
		new EnumTest();
	}

	public function new() 
	{
		var t:Color = Red;
		var p:Point3 = { x:0, y:1, z:2,w:3 };
		trace(p.x);
		
	}
	
}