package org.angle3d.input.event
{

	/**
	 * An abstract input event.
	 */
	public class InputEvent
	{
		private var time:Number;

		private var consumed:Boolean;

		public function InputEvent()
		{
			consumed = false;
		}

		/**
		 * The time when the event occurred. This is relative to
		 * {@link Input#getInputTimeNanos() }.
		 *
		 * @return time when the event occured
		 */
		public function getTime():Number
		{
			return time;
		}

		/**
		 * Set the time when the event occurred.
		 *
		 * @param time time when the event occurred.
		 */
		public function setTime(time:int):void
		{
			this.time = time;
		}

		/**
		 * Returns true if the input event has been consumed, meaning it is no longer valid
		 * and should not be forwarded to input listeners.
		 *
		 * @return true if the input event has been consumed
		 */
		public function isConsumed():Boolean
		{
			return consumed;
		}

		/**
		 * Call to mark this input event as consumed, meaning it is no longer valid
		 * and should not be forwarded to input listeners.
		 */
		public function setConsumed():void
		{
			this.consumed = true;
		}
	}
}

