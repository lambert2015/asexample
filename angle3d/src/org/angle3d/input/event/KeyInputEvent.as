package org.angle3d.input.event
{

	/**
	 * Keyboard key event.
	 *
	 * @author Kirill Vainer
	 */
	public class KeyInputEvent extends InputEvent
	{

		public var keyCode:int;
		public var keyChar:String;
		public var pressed:Boolean;

		public function KeyInputEvent(keyCode:int, keyChar:String, pressed:Boolean)
		{
			super();

			this.keyCode=keyCode;
			this.keyChar=keyChar;
			this.pressed=pressed;
		}

		/**
		 * Returns true if this event is a key release, false if it was a key press.
		 *
		 * @return true if this event is a key release, false if it was a key press.
		 */
		public function get released():Boolean
		{
			return !pressed;
		}

		public function toString():String
		{
			var str:String="Key(CODE=" + keyCode;
			str=str + ", CHAR=" + keyChar;

			if (pressed)
			{
				return str + ", PRESSED)";
			}
			else
			{
				return str + ", RELEASED)";
			}
		}
	}
}

