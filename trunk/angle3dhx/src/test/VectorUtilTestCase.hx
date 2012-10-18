package test;
import haxe.unit.TestCase;
import flash.Vector;
import org.angle3d.math.VectorUtil;

class VectorUtilTestCase extends TestCase
{

	public function new() 
	{
		super();
	}
	
	public function testInsert():Void
	{
		var v0:Vector<Float> = Vector.ofArray([0.0, 1.0, 2.0]);
		
		VectorUtil.insert(v0, 1, Vector.ofArray([3.0, 4.0]));
		
		assertEquals(3.0, v0[1]);
		assertEquals(4.0, v0[2]);
		assertEquals(5, v0.length);
	}
	
}