package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flash.text.TextField;
import flash.Vector;

/**
 * ...
 * @author 
 */

class Main extends Sprite
{
	
	static function main() 
	{
		Lib.current.addChild(new Main());
	}
	
	private var textField:TextField;
		
	public function new() 
	{
		super();
		
		textField = new TextField();
		this.addChild(textField);
		
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	private function addedToStageHandler(e:Event):Void
	{
		var list:Vector<Float> = new Vector<Float>(3000000,true);
		
		var time:Int = Lib.getTimer();
		for (i in 0...1000000)
		{
			list[i * 3 + 0] = i + 0;
			list[i * 3 + 1] = i + 1;
			list[i * 3 + 2] = i + 2;
		}
		textField.text = (Lib.getTimer() - time) + "\n";
		
		time = Lib.getTimer();
		for (i in 0...1000000)
		{
			list[Std.int(i * 3 + 0)] = i + 0;
			list[Std.int(i * 3 + 1)] = i + 1;
			list[Std.int(i * 3 + 2)] = i + 2;
		}
		textField.text += (Lib.getTimer() - time) + "";
	}
	
}