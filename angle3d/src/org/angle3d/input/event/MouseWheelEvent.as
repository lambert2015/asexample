package org.angle3d.input.event
{

	/**
	 * Mouse movement event.
	 * <p>
	 * Movement events are only generated if the mouse is on-screen.
	 *
	 * @author Kirill Vainer
	 */
	public class MouseWheelEvent extends InputEvent
	{
		public var wheel:int;
		public var deltaWheel:int;

		public function MouseWheelEvent(wheel:int, deltaWheel:int)
		{
			super();
			this.wheel = wheel;
			this.deltaWheel = deltaWheel;
		}

		public function toString():String
		{
			return "MouseWheel(wheel=" + wheel + ", deltaWheel=" + deltaWheel + ")";
		}

		public function getButtonIndex():int
		{
			return 2;
		}
	}
}

