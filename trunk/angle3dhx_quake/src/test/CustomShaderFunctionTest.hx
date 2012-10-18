package test;
import haxe.unit.TestCase;

/**
 * 自定义Shader函数测试
 * @author 
 */
//TODO need test diffuse
class CustomShaderFunctionTest  extends TestCase
{

	public function new() 
	{
		super();
	}
	
	public function testClamp():Void
	{
		assertEquals(0.0, _clamp(0.0, 0.0, 1.0));
		assertEquals(0.3, _clamp(0.3, 0.0, 1.0));
		assertEquals(1.0, _clamp(1.3, 0.0, 1.0));
		assertEquals(0.0, _clamp(-1.0, 0.0, 1.0));
	}
	
	public function testLessThanEqual():Void
	{
		assertEquals(1.0, _lessThanEqual(1.0, 2.0));
		assertEquals(1.0, _lessThanEqual(1.0, 1.0));
		assertEquals(0.0, _lessThanEqual(3.0, 2.0));
	}
	
	public function testCeil():Void
	{
		assertEquals(1.0, _ceil(1.0));
		assertEquals(2.0, _ceil(1.1));
		assertEquals( -1.0, _ceil( -1));
		assertEquals( -1.0, _ceil( -1.1));
	}
	
	public function testFloor():Void
	{
		assertEquals(1.0, _floor(1.0));
		assertEquals(1.0, _floor(1.1));
		assertEquals(1.0, _floor(1.9));
		assertEquals( -1.0, _floor( -1));
		assertEquals( -2.0, _floor( -1.1));
		assertEquals( -2.0, _floor( -1.9));
	}
	
	public function testSign():Void
	{
		assertEquals(1.0, _sign(1.0));
		assertEquals(0.0, _sign(0.0));
		assertEquals( -1.0, _sign( -1.0));
	}
	
	private function _clamp(value:Float,min:Float,max:Float):Float
	{
		var t0:Float = Math.max(value, min);
		return Math.min(t0, max);
	}
	
	private function _ceil(value:Float):Float
	{
		var t0:Float = _fractional(value);
		var t1:Float = _sub(value, t0);
		var t2:Float = _lessThan(0, t0);
		return _add(t1, t2);
	}
	
	private function _floor(value:Float):Float
	{
		var t0:Float = _fractional(value);
		var t1:Float = _sub(value, t0);
		return t1;
	}
	
	private function _sign(value:Float):Float
	{
		var t0:Float, t1:Float, t2:Float;
		
		if (value != 0.0)
		{
			t0 = 1.0;
		}
		else 
		{
			t0 = 0.0;
		}
		
		if (value < 0.0)
		{
			t1 = 1.0;
		}
		else
		{
			t1 = 0.0;
		}
		
		t1 *= -1.0;
		
		if (value > 0.0)
		{
			t2 = 1.0;
		}
		else
		{
			t2 = 0.0;
		}
		
		return t0 * (t1 + t2);
	}
	
	private function _sub(a:Float, b:Float):Float
	{
		return a - b;
	}
	
	private function _add(a:Float, b:Float):Float
	{
		return a + b;
	}
	
	private function _lessThanEqual(a:Float, b:Float):Float
	{
		var t0:Float = _lessThan(a, b);
		var t1:Float = _equal(a, b);
		return t0 + t1;
	}
	
	private function _greateEqual(a:Float, b:Float):Float
	{
		if (a >= b)
		{
			return 1.0;
		}
		else
		{
			return 0.0;
		}
	}
	
	private function _equal(a:Float, b:Float):Float
	{
		if (a == b)
		{
			return 1.0;
		}
		else
		{
			return 0.0;
		}
	}
	
	private function _fractional(a:Float):Float
	{
		return a - Math.floor(a);
	}
	
	private function _lessThan(a:Float, b:Float):Float
	{
		if (a < b)
		{
			return 1.0;
		}
		else
		{
			return 0.0;
		}
	}
}