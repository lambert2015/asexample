package test;
import haxe.unit.TestRunner;

/**
 * ...
 * @author andy
 */
//TODO 修改TestRunner，采用更好的图形化方式
class TestMain 
{
	static function main()
	{
		new TestMain();
	}

	private var tr:TestRunner;
	public function new() 
	{
		tr = new TestRunner();
		tr.add(new Vector2fTestCase());
		tr.add(new FastMathTestCase());
		tr.add(new Matrix4fTestCase());
		tr.add(new CustomShaderFunctionTest());
		tr.add(new VectorUtilTestCase());
		tr.add(new HashMapTestCase());
		
		tr.run();
	}
	
}