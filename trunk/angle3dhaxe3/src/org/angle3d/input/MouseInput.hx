package org.angle3d.input
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.getTimer;

	import org.angle3d.input.event.MouseButtonEvent;
	import org.angle3d.input.event.MouseMotionEvent;
	import org.angle3d.input.event.MouseWheelEvent;

	/**
	 * A specific API for interfacing with the mouse.
	 */
	public class MouseInput implements Input
	{
		public static const AXIS_X:int = 0;
		public static const AXIS_Y:int = 1;
		public static const AXIS_WHEEL:int = 2;

		/**
		 * Left mouse button.
		 */
		public static const BUTTON_LEFT:int = 0;

		/**
		 * Right mouse button.
		 */
		public static const BUTTON_RIGHT:int = 1;

		/**
		 * Middle mouse button.
		 */
		public static const BUTTON_MIDDLE:int = 2;

		private var _stage:Stage;

		private var _listener:RawInputListener;

		private var curX:Float;
		private var curY:Float;
		private var dx:Float;
		private var dy:Float;
		private var wheel:int;
		private var wheelDelta:int;
		private var visible:Bool;

		public function MouseInput()
		{
			curX = 0;
			curY = 0;
			dx = 0;
			dy = 0;
			wheelDelta = 0;
			wheel = 0;
			visible = true;

			_stage = null;
			_listener = null;
		}

		/**
		 * Set whether the mouse cursor should be visible or not.
		 *
		 * @param visible Whether the mouse cursor should be visible or not.
		 */
		public function setCursorVisible(visible:Bool):Void
		{
			this.visible = visible;
			if (visible)
			{
				Mouse.show();
			}
			else
			{
				Mouse.hide();
			}
		}

		/**
		* Initializes the native side to listen into events from the device.
		*/
		public function initialize(stage:Stage):Void
		{
			_stage = stage;

			if (_stage != null)
			{
				_stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				_stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
				_stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);

				curX = _stage.mouseX;
				curY = _stage.mouseY;
			}
		}

		private function _onMouseDown(e:MouseEvent):Void
		{
			var evt:MouseButtonEvent = new MouseButtonEvent(true, e.stageX, e.stageY);
			evt.setTime(getTimer());
			_listener.onMouseButtonEvent(evt);
		}

		private function _onMouseUp(e:MouseEvent):Void
		{
			var evt:MouseButtonEvent = new MouseButtonEvent(false, e.stageX, e.stageY);
			evt.setTime(getTimer());
			_listener.onMouseButtonEvent(evt);
		}

		private function _onMouseMove(e:MouseEvent):Void
		{
			dx = e.stageX - curX;
			dy = e.stageY - curY;
			curX = e.stageX;
			curY = e.stageY;

			//Lib.trace("_onMouseMove dx : "+dx);

			var evt:MouseMotionEvent = new MouseMotionEvent(curX, curY, dx, dy);
			evt.setTime(getTimer());
			_listener.onMouseMotionEvent(evt);
		}

		private function _onMouseWheel(e:MouseEvent):Void
		{
			wheelDelta = e.delta;
			wheel += wheelDelta;

			var evt:MouseWheelEvent = new MouseWheelEvent(wheel, wheelDelta);
			evt.setTime(getTimer());
			_listener.onMouseWheelEvent(evt);
		}

		/**
		 * Queries the device for input. All events should be sent to the
		 * RawInputListener set with setInputListener.
		 *
		 * @see #setInputListener(com.jme3.input.RawInputListener)
		 */
		public function update():Void
		{

		}

		/**
		 * Ceases listening to events from the device.
		 */
		public function destroy():Void
		{
			if (_stage != null)
			{
				_stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
				_stage = null;
			}
		}

		/**
		 * @return True if the device has been initialized and not destroyed.
		 * @see #initialize()
		 * @see #destroy()
		 */
		public function isInitialized():Bool
		{
			return _stage != null;
		}

		/**
		 * Sets the input listener to receive events from this device. The
		 * appropriate events should be dispatched through the callbacks
		 * in RawInputListener.
		 * @param listener
		 */
		public function setInputListener(listener:RawInputListener):Void
		{
			this._listener = listener;
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

