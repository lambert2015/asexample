package examples.speed;

import flash.display.Sprite;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.text.TextField;
import flash.Vector;

import org.angle3d.utils.BitVector;

class TestBitVector extends Sprite
{
	static function main()
	{
		return new TestBitVector();
	}

	private var tf:TextField;
	public function new() 
	{
		super();
		tf = new TextField();
		tf.height = 200;
		tf.width = 200;
		Lib.current.addChild(tf);
		
		var COUNT:Int = 10000000;
		
		var bitVector:BitVector = new BitVector(COUNT);
		var vector:Vector<Int> = new Vector<Int>(COUNT, true);
		var boolVector:Vector<Bool> = new Vector<Bool>(COUNT, true);
		
		tf.text = "bitVector.bucketSize=" + bitVector.bucketSize() + "\n";
		
		var time:Int = Lib.getTimer();
		for (i in 0...COUNT)
		{
			bitVector.set(i);
		}
		tf.text += "bitVector.set time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			vector[i] = 1;
		}
		tf.text += "vector.set time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			boolVector[i] = true;
		}
		tf.text += "boolVector.set time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			var t:Bool = bitVector.get(i);
		}
		tf.text += "bitVector.get time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			var t:Bool = vector[i] == 1;
		}
		tf.text += "vector.get time=" + (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...COUNT)
		{
			var t:Bool = boolVector[i];
		}
		tf.text += "boolVector.get time=" + (Lib.getTimer() - time) + "\n";
	}
}