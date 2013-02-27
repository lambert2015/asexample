package tests;
import haxe.unit.TestRunner;
/**
 * ...
 * @author 
 */
class MathTest
{
	static function main()
	{
        var runner:TestRunner = new TestRunner();
		
		runner.add(new TestVector2());
		runner.add(new ArrayUtilTest());
		
        runner.run();
    }
}