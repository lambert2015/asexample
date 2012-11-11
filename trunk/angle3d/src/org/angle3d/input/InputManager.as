package org.angle3d.input
{
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import org.angle3d.input.controls.ActionListener;
	import org.angle3d.input.controls.AnalogListener;
	import org.angle3d.input.controls.InputListener;
	import org.angle3d.input.controls.KeyTrigger;
	import org.angle3d.input.controls.MouseAxisTrigger;
	import org.angle3d.input.controls.MouseButtonTrigger;
	import org.angle3d.input.controls.Trigger;
	import org.angle3d.input.event.InputEvent;
	import org.angle3d.input.event.KeyInputEvent;
	import org.angle3d.input.event.MouseButtonEvent;
	import org.angle3d.input.event.MouseMotionEvent;
	import org.angle3d.input.event.MouseWheelEvent;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector2f;
	import org.angle3d.utils.ArrayUtil;
	import org.angle3d.utils.Assert;
	import org.angle3d.utils.DictionaryUtil;
	import org.angle3d.utils.Logger;


	/**
	 * The <code>InputManager</code> is responsible for converting input events
	 * received from the Key, Mouse and Joy Input implementations into an
	 * abstract, input device independent representation that user code can use.
	 * <p>
	 * By default an <code>InputManager</code> is included with every Application instance for use
	 * in user code to query input, unless the Application is created as headless
	 * or with input explicitly disabled.
	 * <p>
	 * The input manager has two concepts, a {@link Trigger} and a mapping.
	 * A trigger represents a specific input trigger, such as a key button,
	 * or a mouse axis. A mapping represents a link onto one or several triggers,
	 * when the appropriate trigger is activated (e.g. a key is pressed), the
	 * mapping will be invoked. Any listeners registered to receive an event
	 * from the mapping will have an event raised.
	 * <p>
	 * There are two types of events that {@link InputListener input listeners}
	 * can receive, one is {@link ActionListener#onAction(java.lang.String, boolean, float) action}
	 * events and another is {@link AnalogListener#onAnalog(java.lang.String, float, float) analog}
	 * events.
	 * <p>
	 * <code>onAction</code> events are raised when the specific input
	 * activates or deactivates. For a digital input such as key press, the <code>onAction()</code>
	 * event will be raised with the <code>isPressed</code> argument equal to true,
	 * when the key is released, <code>onAction</code> is called again but this time
	 * with the <code>isPressed</code> argument set to false.
	 * For analog inputs, the <code>onAction</code> method will be called any time
	 * the input is non-zero, however an exception to this is for joystick axis inputs,
	 * which are only called when the input is above the {@link InputManager#setAxisDeadZone(float) dead zone}.
	 * <p>
	 * <code>onAnalog</code> events are raised every frame while the input is activated.
	 * For digital inputs, every frame that the input is active will cause the
	 * <code>onAnalog</code> method to be called, the argument <code>value</code>
	 * argument will equal to the frame's time per frame (TPF) value but only
	 * for digital inputs. For analog inputs however, the <code>value</code> argument
	 * will equal the actual analog value.
	 */
	public class InputManager implements RawInputListener
	{
		private var _stage:Stage;

		private var _keyInput:KeyInput;
		private var _mouseInput:MouseInput;

		private var frameTPF:Number;
		private var lastLastUpdateTime:Number;
		private var lastUpdateTime:Number;
		private var frameDelta:Number;
		private var firstTime:int;

		private var eventsPermitted:Boolean;
		private var mouseVisible:Boolean;
		private var safeMode:Boolean;
		private var axisDeadZone:Number;

		private var cursorPos:Vector2f;

		private var bindings:Dictionary; //<int,Array<InputMapping>>;
		private var mappings:Dictionary; //<String,InputMapping>;

		private var pressedButtons:Dictionary; //<int,Number>;
		private var axisValues:Dictionary; //<int,Number>;
		private var rawListeners:Vector.<RawInputListener>;
		private var inputQueue:Vector.<InputEvent>;

		public function InputManager()
		{
			_init();
		}

		private function _init():void
		{
			_keyInput = new KeyInput();
			_mouseInput = new MouseInput();

			_keyInput.setInputListener(this);
			_mouseInput.setInputListener(this);

			lastLastUpdateTime = 0;
			lastUpdateTime = 0;
			frameDelta = 0;
			eventsPermitted = true;
			mouseVisible = true;
			safeMode = false;
			axisDeadZone = 0.05;

			cursorPos = new Vector2f();

			bindings = new Dictionary();
			mappings = new Dictionary();

			pressedButtons = new Dictionary();
			axisValues = new Dictionary();
			rawListeners = new Vector.<RawInputListener>();
			inputQueue = new Vector.<InputEvent>();
		}

		public function initialize(stage:Stage):void
		{
			_keyInput.initialize(stage);
			_mouseInput.initialize(stage);

			firstTime = getTimer();
		}

		public function destroy():void
		{
			if (_keyInput != null)
			{
				_keyInput.destroy();
				_keyInput = null;
			}

			if (_mouseInput != null)
			{
				_mouseInput.destroy();
				_mouseInput = null;
			}
		}


		/**
		 * Called before a batch of input will be sent to this
		 * <code>RawInputListener</code>.
		 */
		public function beforeInput():void
		{

		}

		/**
		 * Called after a batch of input was sent to this
		 * <code>RawInputListener</code>.
		 *
		 * The listener should set the {@link InputEvent#setConsumed() consumed flag}
		 * on any events that have been consumed either at this call or previous calls.
		 */
		public function afterInput():void
		{

		}

		/**
		 * Invoked on mouse movement/motion events.
		 *
		 * @param evt
		 */
		public function onMouseMotionEvent(evt:MouseMotionEvent):void
		{
			//if (!eventsPermitted) 
			//{
			//throw new Error("MouseInput has raised an event at an illegal time.");
			//}

			cursorPos.setTo(evt.x, evt.y);
			inputQueue.push(evt);
		}

		public function onMouseWheelEvent(evt:MouseWheelEvent):void
		{
			//if (!eventsPermitted) 
			//{
			//throw new Error("MouseInput has raised an event at an illegal time.");
			//}
			inputQueue.push(evt);
		}

		/**
		 * Callback from RawInputListener. Do not use.
		 */
		public function onMouseButtonEvent(evt:MouseButtonEvent):void
		{
			//if (!eventsPermitted) 
			//{
			//throw new Error("MouseInput has raised an event at an illegal time.");
			//}

			inputQueue.push(evt);
		}

		/**
		 * Invoked on keyboard key press or release events.
		 *
		 * @param evt
		 */
		public function onKeyEvent(evt:KeyInputEvent):void
		{
			//if (!eventsPermitted) 
			//{
			//throw new Error("KeyInput has raised an event at an illegal time.");
			//}

			inputQueue.push(evt);
		}



		/**
		 * Set the deadzone for joystick axes.
		 *
		 * <p>{@link ActionListener#onAction(java.lang.String, boolean, float) }
		 * events will only be raised if the joystick axis value is greater than
		 * the <code>deadZone</code>.
		 *
		 * @param deadZone the deadzone for joystick axes.
		 */
		public function setAxisDeadZone(deadZone:Number):void
		{
			this.axisDeadZone = deadZone;
		}

		/**
		 * Returns the deadzone for joystick axes.
		 *
		 * @return the deadzone for joystick axes.
		 */
		public function getAxisDeadZone():Number
		{
			return axisDeadZone;
		}

		/**
		 * Adds a new listener to receive events on the given mappings.
		 *
		 * <p>The given InputListener will be registered to receive events
		 * on the specified mapping names. When a mapping raises an event, the
		 * listener will have its appropriate method invoked, either
		 * {@link ActionListener#onAction(java.lang.String, boolean, float) }
		 * or {@link AnalogListener#onAnalog(java.lang.String, float, float) }
		 * depending on which public interface the <code>listener</code> implements.
		 * If the listener implements both public interfaces, then it will receive the
		 * appropriate event for each method.
		 *
		 * @param listener The listener to register to receive input events.
		 * @param mappingNames The mapping names which the listener will receive
		 * events from.
		 *
		 * @see InputManager#removeListener(com.jme3.input.controls.InputListener)
		 */
		public function addListener(listener:InputListener, mappingNames:Array):void
		{
			var length:int = mappingNames.length;
			for (var i:int = 0; i < length; i++)
			{
				var mappingName:String = mappingNames[i];
				var im:InputMapping = mappings[mappingName];
				if (im == null)
				{
					im = new InputMapping(mappingName);
					mappings[mappingName] = im;
				}

				if (!ArrayUtil.contain(im.listeners, listener))
				{
					im.listeners.push(listener);
				}
			}
		}

		/**
		 * Removes a listener from receiving events.
		 *
		 * <p>This will unregister the listener from any mappings that it
		 * was previously registered with via
		 * {@link InputManager#addListener(com.jme3.input.controls.InputListener, java.lang.String[]) }.
		 *
		 * @param listener The listener to unregister.
		 *
		 * @see InputManager#addListener(com.jme3.input.controls.InputListener, java.lang.String[])
		 */
		public function removeListener(listener:InputListener):void
		{
			var map:*;
			for each (map in mappings)
			{
				map.listeners.remove(listener);
			}
		}

		/**
		 * Create a new mapping to the given triggers.
		 *
		 * <p>
		 * The given mapping will be assigned to the given triggers, when
		 * any of the triggers given raise an event, the listeners
		 * registered to the mappings will receive appropriate events.
		 *
		 * @param mappingName The mapping name to assign.
		 * @param triggers The triggers to which the mapping is to be registered.
		 *
		 * @see InputManager#deleteMapping(java.lang.String)
		 */
		public function addMapping(mappingName:String, triggers:flash.Vector.<Trigger>):void
		{
			var mapping:InputMapping = mappings[mappingName];
			if (mapping == null)
			{
				mapping = new InputMapping(mappingName);
				mappings[mappingName] = mapping;
			}

			var length:int = triggers.length;
			for (var i:int = 0; i < length; i++)
			{
				var trigger:Trigger = triggers[i];
				var hash:int = trigger.triggerHashCode();
				var names:Array = bindings[hash];
				if (names == null)
				{
					names = [];
					bindings[hash] = names;
				}

				if (!ArrayUtil.contain(names, mapping))
				{
					names.push(mapping);
					mapping.triggers.push(hash);
				}
				else
				{
					Logger.log("Attempted to add mapping \"" + mappingName + "\" twice to trigger.");
				}
			}
		}

		public function addSingleMapping(mappingName:String, trigger:Trigger):void
		{
			var mapping:InputMapping = mappings[mappingName];
			if (mapping == null)
			{
				mapping = new InputMapping(mappingName);
				mappings[mappingName] = mapping;
			}

			var hash:int = trigger.triggerHashCode();
			var names:Array = bindings[hash];
			if (names == null)
			{
				names = [];
				bindings[hash] = names;
			}

			if (!ArrayUtil.contain(names, mapping))
			{
				names.push(mapping);
				mapping.triggers.push(hash);
			}
			else
			{
				Logger.log("Attempted to add mapping \"" + mappingName + "\" twice to trigger.");
			}
		}

		/**
		 * Deletes a mapping from receiving trigger events.
		 *
		 * <p>
		 * The given mapping will no longer be assigned to receive trigger
		 * events.
		 *
		 * @param mappingName The mapping name to unregister.
		 *
		 * @see InputManager#addMapping(java.lang.String, com.jme3.input.controls.Trigger[])
		 */
		public function deleteMapping(mappingName:String):void
		{
			var mapping:InputMapping = mappings[mappingName];

			Assert.assert(mapping != null, "Cannot find mapping: " + mappingName);

			var triggers:Array = mapping.triggers;
			var i:int = triggers.length;
			while (--i >= 0)
			{
				var hash:int = triggers[i];
				var maps:Array = bindings[hash];
				ArrayUtil.remove(maps, mapping);
			}
		}

		/**
		 * Deletes a specific trigger registered to a mapping.
		 *
		 * <p>
		 * The given mapping will no longer receive events raised by the
		 * trigger.
		 *
		 * @param mappingName The mapping name to cease receiving events from the
		 * trigger.
		 * @param trigger The trigger to no longer invoke events on the mapping.
		 */
		public function deleteTrigger(mappingName:String, trigger:Trigger):void
		{
			var mapping:InputMapping = mappings[mappingName];

			Assert.assert(mapping != null, "Cannot find mapping: " + mappingName);

			var maps:Array = bindings[trigger.triggerHashCode()];
			ArrayUtil.remove(maps, mapping);
		}

		/**
		 * Clears all the input mappings from this InputManager.
		 * Consequently, also clears all of the
		 * InputListeners as well.
		 */
		public function clearMappings():void
		{
			mappings = new Dictionary();
			bindings = new Dictionary();
			reset();
		}

		/**
		 * Do not use.
		 * Called to reset pressed keys or buttons when focus is restored.
		 */
		public function reset():void
		{
			pressedButtons.clear();
			axisValues.clear();
		}

		/**
		 * Returns whether the mouse cursor is visible or not.
		 *
		 * <p>By default the cursor is visible.
		 *
		 * @return whether the mouse cursor is visible or not.
		 *
		 * @see InputManager#setCursorVisible(boolean)
		 */
		public function isCursorVisible():Boolean
		{
			return mouseVisible;
		}

		/**
		 * Set whether the mouse cursor should be visible or not.
		 *
		 * @param visible whether the mouse cursor should be visible or not.
		 */
		public function setCursorVisible(visible:Boolean):void
		{
			if (mouseVisible != visible)
			{
				mouseVisible = visible;
				_mouseInput.setCursorVisible(mouseVisible);
			}
		}

		/**
		 * Returns the current cursor position. The position is relative to the
		 * bottom-left of the screen and is in pixels.
		 *
		 * @return the current cursor position
		 */
		public function getCursorPosition():Vector2f
		{
			return cursorPos;
		}

		/**
		 * Adds a {@link RawInputListener} to receive raw input events.
		 *
		 * <p>
		 * Any raw input listeners registered to this <code>InputManager</code>
		 * will receive raw input events first, before they get handled
		 * by the <code>InputManager</code> itself. The listeners are
		 * each processed in the order they were added, e.g. FIFO.
		 * <p>
		 * If a raw input listener has handled the event and does not wish
		 * other listeners down the list to process the event, it may set the
		 * {@link InputEvent#setConsumed() consumed flag} to indicate the
		 * event was consumed and shouldn't be processed any further.
		 * The listener may do this either at each of the event callbacks
		 * or at the {@link RawInputListener#endInput() } method.
		 *
		 * @param listener A listener to receive raw input events.
		 *
		 * @see RawInputListener
		 */
		public function addRawInputListener(listener:RawInputListener):void
		{
			rawListeners.push(listener);
		}

		/**
		 * Removes a {@link RawInputListener} so that it no longer
		 * receives raw input events.
		 *
		 * @param listener The listener to cease receiving raw input events.
		 *
		 * @see InputManager#addRawInputListener(com.jme3.input.RawInputListener)
		 */
		public function removeRawInputListener(listener:RawInputListener):void
		{
			var index:int = rawListeners.indexOf(listener);

			if (index > -1)
			{
				rawListeners.splice(index, 1);
			}
		}

		/**
		 * Clears all {@link RawInputListener}s.
		 *
		 * @see InputManager#addRawInputListener(com.jme3.input.RawInputListener)
		 */
		public function clearRawInputListeners():void
		{
			rawListeners.length = 0;
		}

		/**
		 * Updates the <code>InputManager</code>.
		 * This will query current input devices and send
		 * appropriate events to registered listeners.
		 *
		 * @param tpf Time per frame value.
		 */
		public function update(tpf:Number):void
		{
			frameTPF = tpf;

			// Activate safemode if the TPF value is so small
			// that rounding errors are inevitable
			safeMode = tpf < 0.015;

			var currentTime:int = getTimer();
			frameDelta = currentTime - lastUpdateTime;

			eventsPermitted = true;

			_keyInput.update();
			_mouseInput.update();

			eventsPermitted = false;

			processQueue();
			invokeUpdateActions();

			lastLastUpdateTime = lastUpdateTime;
			lastUpdateTime = currentTime;
		}

		private function invokeActions(hash:int, pressed:Boolean):void
		{
			var maps:Array = bindings[hash];
			if (maps == null)
			{
				return;
			}

			var size:int = maps.length;
			var i:int = size;
			while (--i >= 0)
			{
				var mapping:InputMapping = maps[i];
				var listeners:Array = mapping.listeners;
				var j:int = listeners.length;
				while (--j >= 0)
				{
					var listener:InputListener = listeners[j];
					if (listener is ActionListener)
					{
						(listener as ActionListener).onAction(mapping.name, pressed, frameTPF);
					}
				}
			}
		}

		private function computeAnalogValue(timeDelta:Number):Number
		{
			if (safeMode || frameDelta == 0)
			{
				return 1.0;
			}
			else
			{
				return FastMath.fclamp(timeDelta / frameDelta, 0, 1);
			}
		}

		private function invokeTimedActions(hash:int, time:Number, pressed:Boolean):void
		{
			if (bindings[hash] == undefined)
			{
				return;
			}

			if (pressed)
			{
				pressedButtons[hash] = time;
			}
			else
			{
				var pressTime:Number = pressedButtons[hash];
				var timeDelta:Number = time - FastMath.fmax(pressTime, lastLastUpdateTime);
				if (timeDelta > 0)
				{
					invokeAnalogs(hash, computeAnalogValue(timeDelta), false);
				}
			}
		}

		private function processQueue():void
		{
			var i:int;
			var event:InputEvent;

			var queueSize:int = inputQueue.length;

			var length:int = rawListeners.length;
			for (i = 0; i < length; i++)
			{
				var listener:RawInputListener = rawListeners[i];

				listener.beforeInput();

				for (var j:int = 0; j < queueSize; j++)
				{
					event = inputQueue[j];
					if (event.isConsumed())
					{
						continue;
					}

					if (event is MouseMotionEvent)
					{
						listener.onMouseMotionEvent(event as MouseMotionEvent);
					}
					else if (event is KeyInputEvent)
					{
						listener.onKeyEvent(event as KeyInputEvent);
					}
					else if (event is MouseButtonEvent)
					{
						listener.onMouseButtonEvent(event as MouseButtonEvent);
					}
					else if (event is MouseWheelEvent)
					{
						listener.onMouseWheelEvent(event as MouseWheelEvent);
					}
					else
					{
						Assert.assert(false, "Can`t find this Event type");
					}
				}

				listener.afterInput();
			}


			for (i = 0; i < queueSize; i++)
			{
				event = inputQueue[i];
				if (event.isConsumed())
				{
					continue;
				}

				if (event is MouseMotionEvent)
				{
					onMouseMotionEventQueued(event as MouseMotionEvent);
				}
				else if (event is KeyInputEvent)
				{
					onKeyEventQueued(event as KeyInputEvent);
				}
				else if (event is MouseButtonEvent)
				{
					onMouseButtonEventQueued(event as MouseButtonEvent);
				}
				else if (event is MouseWheelEvent)
				{
					onMouseWheelEventQueued(event as MouseWheelEvent);
				}
				else
				{
					Assert.assert(false, "");
				}
			}

			inputQueue.length = 0;
		}

		private function invokeUpdateActions():void
		{
			for (var hash:* in pressedButtons)
			{
				var pressTime:Number = pressedButtons[hash];
				var timeDelta:Number = lastUpdateTime - FastMath.fmax(lastLastUpdateTime, pressTime);

				if (timeDelta > 0)
				{
					invokeAnalogs(hash, computeAnalogValue(timeDelta), false);
				}
			}

			for (var key:* in axisValues)
			{
				var value:Number = axisValues[key];
				invokeAnalogs(key, value * frameTPF, true);
			}
		}

		private function invokeAnalogs(hash:int, value:Number, isAxis:Boolean):void
		{
			var maps:Array = bindings[hash];
			if (maps == null)
			{
				return;
			}

			if (!isAxis)
			{
				value *= frameTPF;
			}

			var i:int = maps.length;
			while (--i >= 0)
			{
				var mapping:InputMapping = maps[i];
				var listeners:Array = mapping.listeners;
				var j:int = listeners.length;
				while (--j >= 0)
				{
					var listener:InputListener = listeners[j];
					if (listener is AnalogListener)
					{
						// NOTE: multiply by TPF for any button bindings
						(listener as AnalogListener).onAnalog(mapping.name, value, frameTPF);
					}
				}
			}
		}

		private function invokeAnalogsAndActions(hash:int, value:Number, applyTpf:Boolean):void
		{
			if (value < axisDeadZone)
			{
				invokeAnalogs(hash, value, !applyTpf);
				return;
			}

			var maps:Array = bindings[hash];
			if (maps == null)
			{
				return;
			}

			var valueChanged:Boolean = !DictionaryUtil.containKey(axisValues, hash);
			if (applyTpf)
			{
				value *= frameTPF;
			}

			var i:int = maps.length;
			while (--i >= 0)
			{
				var mapping:InputMapping = maps[i];
				var listeners:Array = mapping.listeners;
				var j:int = listeners.length;
				while (--j >= 0)
				{
					var listener:InputListener = listeners[j];

					if (listener is ActionListener)
					{
						(listener as ActionListener).onAction(mapping.name, true, frameTPF);
					}


					if (listener is AnalogListener)
					{
						(listener as AnalogListener).onAnalog(mapping.name, value, frameTPF);
					}
				}
			}
		}

		private function onMouseMotionEventQueued(evt:MouseMotionEvent):void
		{
			var val:Number;
			var dx:Number = evt.dx;
			if (dx != 0)
			{
				val = FastMath.fabs(dx / 1024);
				invokeAnalogsAndActions(MouseAxisTrigger.mouseAxisHash(MouseInput.AXIS_X, dx < 0), val, false);
			}
			var dy:Number = evt.dy;
			if (dy != 0)
			{
				val = FastMath.fabs(dy / 1024);
				invokeAnalogsAndActions(MouseAxisTrigger.mouseAxisHash(MouseInput.AXIS_Y, dy < 0), val, false);
			}
		}

		private function onMouseWheelEventQueued(evt:MouseWheelEvent):void
		{
			var delta:int = evt.deltaWheel;
			if (delta != 0)
			{
				//var val:Number = FastMath.fabs(delta / 10);
				invokeAnalogsAndActions(MouseAxisTrigger.mouseAxisHash(MouseInput.AXIS_WHEEL, delta < 0), delta, false);
			}
		}


		private function onKeyEventQueued(evt:KeyInputEvent):void
		{
			var hash:int = KeyTrigger.keyHash(evt.keyCode);
			invokeActions(hash, evt.pressed);
			invokeTimedActions(hash, evt.getTime(), evt.pressed);
		}

		private function onMouseButtonEventQueued(evt:MouseButtonEvent):void
		{
			var hash:int = MouseButtonTrigger.mouseButtonHash(evt.getButtonIndex());
			invokeActions(hash, evt.pressed);
			invokeTimedActions(hash, evt.getTime(), evt.pressed);
		}
	}
}

