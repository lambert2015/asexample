package org.angle3d.input.event
{

	/**
	 * Mouse movement event.
	 * <p>
	 * Movement events are only generated if the mouse is on-screen.
	 *
	 * @author Kirill Vainer
	 */
	public class MouseMotionEvent extends InputEvent
	{
		public var x:Number;
		public var y:Number;
		public var dx:Number;
		public var dy:Number;

		public function MouseMotionEvent(x:Number, y:Number, dx:Number, dy:Number)
		{
			super();
			this.x = x;
			this.y = y;
			this.dx = dx;
			this.dy = dy;
		}

		public function toString():String
		{
			return "MouseMotion(x=" + x + ", y=" + y + ", dx=" + dx + ", dy=" + dy + ")";
		}
	}
}

