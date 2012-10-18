package examples.speed;

import flash.display.Sprite;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.text.TextField;
import flash.Vector;

import org.angle3d.utils.BitVector;

class TestFastMath extends Sprite
{
	static function main()
	{
		return new TestFastMath();
	}

	private var tf:TextField;
	public function new() 
	{
		super();
		tf = new TextField();
		tf.height = 600;
		tf.width = 600;
		Lib.current.addChild(tf);
		
		
		testCeil();
	}
	
	private function testFloor():Void
	{
		var COUNT:Int = 1000000;
		
		var time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			Math.floor(1.57);
		}
		tf.text += "Math.floor =" + Math.floor(1.57) + ",time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			FastMath.floor(1.57);
		}
		tf.text += "FastMath.floor =" + FastMath.floor(1.57) + ",time=" + (Lib.getTimer() - time) + "\n";
	}
	
	private function testCeil():Void
	{
		var COUNT:Int = 100000;
		
		var v:Int;
		var time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			v = Math.ceil(1.57);
		}
		tf.text += "Math.ceil =" + Math.ceil(1.57) + ",time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			v = FastMath.ceil(1.57);
		}
		tf.text += "FastMath.ceil =" + FastMath.ceil(1.57) + ",time=" + (Lib.getTimer() - time) + "\n";
	}
}