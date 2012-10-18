package test;
import haxe.unit.TestCase;
import org.angle3d.utils.HashMap;

class HashMapTestCase extends TestCase
{

	public function new() 
	{
		super();
	}
	
	public function testHashMap():Void
	{
		var hashMap:HashMap<String,String> = new HashMap<String,String>();
		hashMap.setValue("a", "A");
		hashMap.setValue("b", "B");
		hashMap.setValue("c", "C");
		hashMap.setValue("d", "D");
		
		assertEquals("A", hashMap.getValue("a"));
		assertEquals(4, hashMap.size());
		
		hashMap.delete("d");
		assertEquals(3, hashMap.size());
		
		var value:String = hashMap.setValue("c", "c");
		assertEquals("C", value);
		
		hashMap.clear();
		assertEquals(0, hashMap.size());
	}
	
}