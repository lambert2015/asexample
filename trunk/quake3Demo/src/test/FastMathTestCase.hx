package test;
import org.angle3d.math.FastMath;
import haxe.unit.TestCase;

/**
 * ...
 * @author andy
 */

class FastMathTestCase extends TestCase
{

	public function new() 
	{
		super();
	}
	
	public function testEquals():Void
	{
		var a:Float = 1.2346;
		var b:Float = 1.2345;
		
		assertTrue(FastMath.nearEqual(a, b));
		assertFalse(FastMath.nearEqual(a, 1.2348));
	}
	
	public function testSignum():Void
	{
		assertEquals(1.0, FastMath.signum(0.1));
		assertEquals( -1.0, FastMath.signum( -0.1));
		assertEquals(0.0, FastMath.signum(0));
	}
	
	public function testClamp():Void
	{
		assertEquals(4, FastMath.clamp(4, 1, 4));
		assertEquals(5, FastMath.clamp(5, 1, 6));
		assertEquals(6, FastMath.clamp(6, 6, 10));
		
		assertEquals(4., FastMath.fclamp(4., 1., 4.));
		assertEquals(5., FastMath.fclamp(5., 1., 6.));
		assertEquals(6., FastMath.fclamp(6., 6., 10.));
	}
	
	public function testAbs():Void
	{
		assertEquals(5,FastMath.abs(5));
		assertEquals(5,FastMath.abs( -5));
		
		assertEquals(5.1,FastMath.fabs(5.1));
		assertEquals(5.1,FastMath.fabs( -5.1));
	}
	
	public function testMinMax():Void
	{
		assertEquals(5, FastMath.min(5, 6));
		assertEquals( -6, FastMath.min( -5, -6));
		
		assertEquals(5.1, FastMath.fmin(5.1, 6.1));
		assertEquals( -6.1, FastMath.fmin( -5.1, -6.1));
		
		assertEquals(6, FastMath.max(5, 6));
		assertEquals( -5, FastMath.max( -5, -6));
		
		assertEquals(6.1, FastMath.fmax(5.1, 6.1));
		assertEquals( -5.1, FastMath.fmax( -5.1, -6.1));
	}
	
	public function testFloorAndCeil():Void
	{
		assertEquals(Math.floor(5.4), FastMath.floor(5.4));
		assertEquals(Math.floor(5.5), FastMath.floor(5.5));
		assertEquals(Math.floor(5.6), FastMath.floor(5.6));
		
		assertEquals(Math.floor(-5.4), FastMath.floor(-5.4));
		assertEquals(Math.floor(-5.5), FastMath.floor(-5.5));
		assertEquals(Math.floor( -5.6), FastMath.floor( -5.6));
		
		assertEquals(Math.ceil(5.4), FastMath.ceil(5.4));
		assertEquals(Math.ceil(5.5), FastMath.ceil(5.5));
		assertEquals(Math.ceil(5.6), FastMath.ceil(5.6));
		
		assertEquals(Math.ceil(-5.4), FastMath.ceil(-5.4));
		assertEquals(Math.ceil(-5.5), FastMath.ceil(-5.5));
		assertEquals(Math.ceil(-5.6), FastMath.ceil(-5.6));
	}
	
	public function testRound():Void
	{
		assertEquals(Math.round(5.4), FastMath.round(5.4));
		assertEquals(Math.round(5.5), FastMath.round(5.5));
		assertEquals(Math.round(5.6), FastMath.round(5.6));
		
		assertEquals(Math.round(-5.4), FastMath.round(-5.4));
		assertEquals(Math.round(-5.5), FastMath.round(-5.5));
		assertEquals(Math.round(-5.6), FastMath.round(-5.6));
	}
	
	public function testPow():Void
	{
		assertEquals(Math.pow(5.4, 5), FastMath.pow(5.4, 5));
		
		assertEquals(Math.pow(25.4,15), FastMath.pow(25.4,15));
	}
}