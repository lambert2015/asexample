package org.angle3d
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.angle3d.sgsl.SgslParser;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var parser:SgslParser = new SgslParser();
			parser.execute(
		}
		
	}
	
}