package ;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;

using StringUtil;
/**
 * ...
 * @author 
 */
class StringInterpolation extends Sprite
{
	static function main()
	{
		Lib.current.addChild(new StringInterpolation());
	}

	public function new() 
	{
		super();
		
		#if flash
		var a:String = "dsfsdfsdf";
		var b:String  = "sdsdfdf";
		Lib.trace(a.connect(b, this));
		#elseif js
		#end
		
		#if debug 
		#end
		
		
		var tf = new TextField();
		tf.width = 300;
		tf.height = 50;
		this.addChild(tf);

		var nick:String = "andy";
		var age:Int = 18;
		tf.text = '$nick`s age is $age \n';
		
		var haxe = "Haxe";
		var as3 = "actionscript3";
		var x = 10;
		tf.text += '${haxe.toUpperCase()} is ${x*2} times better than $as3';
	}
	
}