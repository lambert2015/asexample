package org.angle3d.input
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;

	/**
	 * Abstract public interface for an input device.
	 *
	 * @see MouseInput
	 * @see KeyInput
	 * @see JoyInput
	 */
	public interface Input
	{

		/**
		 * Initializes the native side to listen into events from the device.
		 */
		function initialize(stage:Stage):void;

		/**
		 * Queries the device for input. All events should be sent to the
		 * RawInputListener set with setInputListener.
		 *
		 * @see #setInputListener(com.jme3.input.RawInputListener)
		 */
		function update():void;

		/**
		 * Ceases listening to events from the device.
		 */
		function destroy():void;

		/**
		 * @return True if the device has been initialized and not destroyed.
		 * @see #initialize()
		 * @see #destroy()
		 */
		function isInitialized():Boolean;

		/**
		 * Sets the input listener to receive events from this device. The
		 * appropriate events should be dispatched through the callbacks
		 * in RawInputListener.
		 * @param listener
		 */
		function setInputListener(listener:RawInputListener):void;

		/**
		 * @return The current absolute time as milliseconds. This time is expected
		 * to be relative to the time given in InputEvents time property.
		 */
		function getInputTime():int;
	}
}

