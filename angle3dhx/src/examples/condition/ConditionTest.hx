package examples.condition;
import org.angle3d.utils.StringUtil;
import org.angle3d.shader.hgal.core.condition.ConditionalCompilation;
/**
 * ...
 * @author andy
 */
//关于循环嵌套，
class ConditionTest 
{
	static function main()
	{
		new ConditionTest();
	}

	private var _condition:ConditionalCompilation;
	public function new() 
	{
		var str:String = 
		"#if test1|test2\n" +
		
		    "test1|test2\n" +
			
			"#if test1\n" +
			    "test1\n" +
			"#elseif test4\n" +
		        "test4\n"+
		    "#else\n" +
		        "else test1\n"+
		    "#end\n" +
			
			"#if test2\n" +
			    "test2\n" +
		    "#else\n" +
		        "else test2\n"+
		    "#end\n" +
			
		    "#if test3\n" +
			    "test3\n" +
		    "#else\n" +
		        "else test3\n"+
		    "#end\n" +
			
		"#end";
		
		_condition = new ConditionalCompilation();
		
		var list:Array<String> = str.split("\n");
		
		trace(str);
		trace(["test2","test6","test3"].toString()+"\n"+_condition.parse(list, ["test2","test6","test3"]));
	}
}