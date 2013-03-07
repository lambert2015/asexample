package org.angle3d.input.event
{

	/**
	 * Mouse button press/release event.
	 *
	 * @author Kirill Vainer
	 */
	public class MouseButtonEvent extends InputEvent
	{
		public var x:Float;
		public var y:Float;
		public var pressed:Bool;

		public function MouseButtonEvent(pressed:Bool, x:Float, y:Float)
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
		public function get released():Bool
		{
			return !pressed;
		}

		public function getButtonIndex():int
		{
			return 0;
		}
	}
}

