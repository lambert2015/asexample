package optimization
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;

	public class Test extends Sprite
	{
		private var textField:TextField;
		private var time:int;
        
		public function Test()
		{
			textField=new TextField();
			textField.width=400;
			textField.multiline=true;
			addChild(textField);
		}
		public function start(s:String=''):void
		{
			time=getTimer();
			textField.appendText(s);
		}
		public function end():void
		{
			textField.text=textField.text+" take times : "+(getTimer()-time)+"ms.\n";
		}
		public function appendText(s:String):void
		{
			textField.appendText(s+":\n");
		}
		
	}
}