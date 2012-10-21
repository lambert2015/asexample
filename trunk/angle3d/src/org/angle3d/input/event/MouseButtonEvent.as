package org.angle3d.input.event
{

	/**
	 * Mouse button press/release event.
	 *
	 * @author Kirill Vainer
	 */
	public class MouseButtonEvent extends InputEvent
	{
		public var x:Number;
		public var y:Number;
		public var pressed:Boolean;

		public function MouseButtonEvent(pressed:Boolean, x:Number, y:Number)
		{
			super();

			this.pressed = pressed;
			this.x = x;
			this.y = y;
		}

		/**
		 * Returns true if the mouse button was released, false if it was pressed.
		 *
		 * @return true if the mouse button was released, false if it was pressed.
		 */
		public function get released():Boolean
		{
			return !pressed;
		}

		public function getButtonIndex():int
		{
			return 0;
		}
	}
}

