package org.angle3d.input
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;

	import org.angle3d.input.event.KeyInputEvent;

	/**
	 * A specific API for interfacing with the keyboard.
	 */
	public class KeyInput implements Input
	{
		private var _stage:Stage;

		private var _listener:RawInputListener;

		public function KeyInput()
		{
			_stage=null;
			_listener=null;
		}

		/**
		* Initializes the native side to listen into events from the device.
		*/
		public function initialize(stage:Stage):void
		{
			_stage=stage;

			if (_stage != null)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				_stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
			}
		}

		private function _onKeyDown(e:KeyboardEvent):void
		{
			if (_listener != null)
			{
				var evt:KeyInputEvent=new KeyInputEvent(e.keyCode, String.fromCharCode(e.keyCode), true);
				evt.setTime(getTimer());
				_listener.onKeyEvent(evt);
			}
		}

		private function _onKeyUp(e:KeyboardEvent):void
		{
			if (_listener != null)
			{
				var evt:KeyInputEvent=new KeyInputEvent(e.keyCode, String.fromCharCode(e.keyCode), false);
				evt.setTime(getTimer());
				_listener.onKeyEvent(evt);
			}
		}

		/**
		 * Queries the device for input. All events should be sent to the
		 * RawInputListener set with setInputListener.
		 *
		 * @see #setInputListener(com.jme3.input.RawInputListener)
		 */
		public function update():void
		{

		}

		/**
		 * Ceases listening to events from the device.
		 */
		public function destroy():void
		{
			if (_stage != null)
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
				_stage=null;
			}

		}

		/**
		 * @return True if the device has been initialized and not destroyed.
		 * @see #initialize()
		 * @see #destroy()
		 */
		public function isInitialized():Boolean
		{
			return _stage != null;
		}

		/**
		 * Sets the input listener to receive events from this device. The
		 * appropriate events should be dispatched through the callbacks
		 * in RawInputListener.
		 * @param listener
		 */
		public function setInputListener(listener:RawInputListener):void
		{
			_listener=listener;
		}

		/**
		 * @return The current absolute time as milliseconds. This time is expected
		 * to be relative to the time given in InputEvents time property.
		 */
		public function getInputTime():int
		{
			return getTimer();
		}
	}
}

