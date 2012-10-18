package org.angle3d.input.controls
{
	import org.angle3d.input.MouseInput;
	import org.angle3d.utils.Assert;

	/**
	 * A <code>MouseAxisTrigger</code> is used as a mapping to mouse axis,
	 * a mouse axis is movement along the X axis (left/right), Y axis (up/down)
	 * and the mouse wheel (scroll up/down).
	 *
	 * @author Kirill Vainer
	 */
	public class MouseAxisTrigger implements Trigger
	{
		private var mouseAxis:int;
		private var negative:Boolean;

		/**
		 * Create a new <code>MouseAxisTrigger</code>.
		 * <p>
		 * @param mouseAxis Mouse axis. See AXIS_*** constants in {@link MouseInput}
		 * @param negative True if listen to negative axis events, false if
		 * listen to positive axis events.
		 */
		public function MouseAxisTrigger(mouseAxis:int, negative:Boolean)
		{
			Assert.assert(mouseAxis >= 0 && mouseAxis <= 2, "Mouse Axis must be between 0 and 2");

			this.mouseAxis = mouseAxis;
			this.negative = negative;
		}

		public function getName():String
		{
			var sign:String = negative ? "Negative" : "Positive";
			switch (mouseAxis)
			{
				case MouseInput.AXIS_X:
					return "Mouse X Axis " + sign;
				case MouseInput.AXIS_Y:
					return "Mouse Y Axis " + sign;
				case MouseInput.AXIS_WHEEL:
					return "Mouse Wheel " + sign;
			}
			return "";
		}

		public function getMouseAxis():int
		{
			return mouseAxis;
		}

		public function isNegative():Boolean
		{
			return negative;
		}

		public static function mouseAxisHash(mouseAxis:int, negative:Boolean):int
		{
			Assert.assert(mouseAxis >= 0 && mouseAxis <= 2, "Mouse Axis must be between 0 and 2");

			return (negative ? 768 : 512) | (mouseAxis & 0xff);
		}

		public function triggerHashCode():int
		{
			return mouseAxisHash(mouseAxis, negative);
		}
	}
}
