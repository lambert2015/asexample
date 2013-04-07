package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import com.adobe.utils.AGALMiniAssembler;
import starling.events.Event;
/**
 * ...
 * @author 
 */

class Main 
{
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		trace(Type.getClass(Lib.current));
	}
	
}