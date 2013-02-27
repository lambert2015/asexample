package tests;

import haxe.unit.TestCase;
import org.angle3d.utils.ArrayUtil;
/**
 * ...
 * @author 
 */
class ArrayUtilTest extends TestCase
{

	public function new() 
	{
		super();
	}
	
	public function testIndexOf():Void
	{
		var list:Array<Int> = new Array<Int>();
		list[0] = 100;
		list[1] = 200;
		list[2] = 320;
		
		assertEquals(1, ArrayUtil.indexOf(list, 200));
		assertEquals(2, ArrayUtil.indexOf(list, 320));
	}
	
}