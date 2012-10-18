package examples.tempVar;

import flash.display.Sprite;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.text.TextField;

/**
 * ...
 * @author andy
 */
class TempVar
{
	public var v0:Vector3f;
	public var v1:Vector3f;
	public var v2:Vector3f;
	
	public function new()
	{
		v0 = new Vector3f();
	    v1 = new Vector3f();
	    v2 = new Vector3f();
	}
	
	public function release():Void
	{
		
	}
	
	private static var _instance:TempVar;
	
	public static function getTempVar():TempVar
	{
		if (_instance == null)
		_instance = new TempVar();
		return _instance;
	}
}

class TestTempVar extends Sprite
{
	static function main()
	{
		return new TestTempVar();
	}

	private var tf:TextField;
	public function new() 
	{
		super();
		tf = new TextField();
		tf.height = 200;
		tf.width = 200;
		Lib.current.addChild(tf);
		
		var time:Int = Lib.getTimer();
		for (i in 0...10000)
		{
			testFunc();
		}
		tf.text = "testFunc time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...10000)
		{
			testTempFunc();
		}
		tf.text += "testTempFunc time=" + (Lib.getTimer() - time) + "";
		
	}
	
	public function testFunc():Vector3f
	{
		var v0:Vector3f = new Vector3f();
		var v1:Vector3f = new Vector3f();
		var v2:Vector3f = new Vector3f();
		
		v0.setTo(1, 2, 3);
		v1.setTo(2, 3, 4);
		v2.setTo(3, 4, 5);
		
		v0.addLocal(v1);
		v2.addLocal(v0);
		
		return v2.clone();
	}
	
	public function testTempFunc():Vector3f
	{
		var tempVar:TempVar = TempVar.getTempVar();
		
		var v0:Vector3f = tempVar.v0;
		var v1:Vector3f = tempVar.v1;
		var v2:Vector3f = tempVar.v2;
		
		v0.setTo(1, 2, 3);
		v1.setTo(2, 3, 4);
		v2.setTo(3, 4, 5);
		
		v0.addLocal(v1);
		v2.addLocal(v0);
		
		tempVar.release();
		
		return v2.clone();
	}
	
}