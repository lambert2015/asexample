package org.angle3d.input
{
	import org.angle3d.input.event.KeyInputEvent;
	import org.angle3d.input.event.MouseButtonEvent;
	import org.angle3d.input.event.MouseMotionEvent;
	import org.angle3d.input.event.MouseWheelEvent;

	/**
	 * An public interface used for receiving raw input from devices.
	 */
	public interface RawInputListener
	{
		/**
		 * Called before a batch of input will be sent to this
		 * <code>RawInputListener</code>.
		 */
		function beforeInput():void;

		/**
		 * Called after a batch of input was sent to this
		 * <code>RawInputListener</code>.
		 *
		 * The listener should set the {@link InputEvent#setConsumed() consumed flag}
		 * on any events that have been consumed either at this call or previous calls.
		 */
		function afterInput():void;

		/**
		 * Invoked on mouse movement/motion events.
		 *
		 * @param evt
		 */
		function onMouseMotionEvent(evt:MouseMotionEvent):void;

		function onMouseWheelEvent(evt:MouseWheelEvent):void;

		/**
		 * Invoked on mouse button events.
		 *
		 * @param evt
		 */
		function onMouseButtonEvent(evt:MouseButtonEvent):void;

		/**
		 * Invoked on keyboard key press or release events.
		 *
		 * @param evt
		 */
		function onKeyEvent(evt:KeyInputEvent):void;
	}
}

