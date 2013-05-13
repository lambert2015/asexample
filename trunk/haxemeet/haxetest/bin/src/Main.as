package  {
	import flash.Lib;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.Boot;
	public class Main extends flash.display.Sprite {
		public function Main() : void { if( !flash.Boot.skip_constructor ) {
			super();
			this.textField = new flash.text.TextField();
			this.addChild(this.textField);
			this.addEventListener(flash.events.Event.ADDED_TO_STAGE,this.addedToStageHandler);
		}}
		
		protected function addedToStageHandler(e : flash.events.Event) : void {
			var list : Vector.<Number> = new Vector.<Number>(3000000,true);
			var time : int = flash.Lib._getTimer();
			{
				var _g : int = 0;
				while(_g < 1000000) {
					var i : int = _g++;
					list[i * 3] = i;
					list[i * 3 + 1] = i + 1;
					list[i * 3 + 2] = i + 2;
				}
			};
			this.textField.text = flash.Lib._getTimer() - time + "\n";
			time = flash.Lib._getTimer();
			{
				var _g1 : int = 0;
				while(_g1 < 1000000) {
					var i1 : int = _g1++;
					list[Std._int(i1 * 3)] = i1;
					list[Std._int(i1 * 3 + 1)] = i1 + 1;
					list[Std._int(i1 * 3 + 2)] = i1 + 2;
				}
			};
			this.textField.text += flash.Lib._getTimer() - time + "";
		}
		
		protected var textField : flash.text.TextField;
		static public function main() : void {
			flash.Lib.current.addChild(new Main());
		}
		
	}
}
