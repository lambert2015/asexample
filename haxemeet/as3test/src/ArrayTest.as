package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 
	 */
	public class ArrayTest extends Sprite
	{
		private var textField:TextField;
		
		public function ArrayTest() 
		{
			super();
			
			textField = new TextField();
			this.addChild(textField);
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			var list:Vector.<Number> = new Vector.<Number>(3000000,true);
			
			var time:int = getTimer();
			for (var i:int = 0; i < 1000000; i++)
			{
				list[i * 3 + 0] = i + 0;
				list[i * 3 + 1] = i + 1;
				list[i * 3 + 2] = i + 2;
			}
			textField.text = (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < 1000000; i++)
			{
				list[int(i * 3 + 0)] = i + 0;
				list[int(i * 3 + 1)] = i + 1;
				list[int(i * 3 + 2)] = i + 2;
			}
			textField.text += (getTimer() - time) + "";
		}
		
	}

}