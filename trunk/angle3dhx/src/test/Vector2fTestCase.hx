package test;
import haxe.unit.TestCase;
import org.angle3d.math.Vector2f;

/**
 * ...
 * @author andy
 */

class Vector2fTestCase extends TestCase
{

	public function new() 
	{
		super();
	}
	
	public function testAdd():Void
	{
		var a:Vector2f = new Vector2f(3,4);
		a.addLocal(new Vector2f(100, 4));
		assertEquals(a.x, 103);
	}
	
}