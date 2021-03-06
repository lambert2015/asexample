package org.angle3d.input;
import flash.display.Stage;
import flash.errors.Error;
import flash.Lib;
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
import org.angle3d.utils.Logger;
import org.angle3d.utils.HashMap;

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
class InputManager implements RawInputListener
{
	private var _stage:Stage;
	
	private var _keyInput:KeyInput;
	private var _mouseInput:MouseInput;
	
	private var frameTPF:Float;
    private var lastLastUpdateTime:Float;
    private var lastUpdateTime:Float;
    private var frameDelta:Float;
    private var firstTime:Int;
    private var eventsPermitted:Bool;
    private var safeMode:Bool;
    private var axisDeadZone:Float;
	
	private var cursorPos:Vector2f;
	
	private var bindings:HashMap<Int,Array<InputMapping>>;
	private var mappings:HashMap<String,InputMapping>;
	
	private var pressedButtons:HashMap<Int,Float>;
	private var axisValues:HashMap<Int,Float>;
	private var rawListeners:Array<RawInputListener>;
	private var inputQueue:Array<InputEvent>;

	public function new() 
	{
		_init();
	}
	
	private function _init():Void
	{
		_keyInput = new KeyInput();
		_mouseInput = new MouseInput();
		
		_keyInput.setInputListener(this);
		_mouseInput.setInputListener(this);
		
		lastLastUpdateTime = 0;
		lastUpdateTime = 0;
		frameDelta = 0;
		eventsPermitted = true;
		safeMode = false;
		axisDeadZone = 0.05;
		
		cursorPos = new Vector2f();
		
		bindings = new HashMap<Int,Array<InputMapping>>();
		mappings = new HashMap<String,InputMapping>();
		
		pressedButtons = new HashMap<Int,Float>();
		axisValues = new HashMap<Int,Float>();
		rawListeners = new Array<RawInputListener>();
		inputQueue = new Array<InputEvent>();
	}
	
	public function initialize(stage:Stage):Void
	{
		_keyInput.initialize(stage);
		_mouseInput.initialize(stage);
		
		firstTime = Lib.getTimer();
	}
	
	public function destroy():Void
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
    public function beforeInput():Void
	{
		
	}
    
    /**
     * Called after a batch of input was sent to this
     * <code>RawInputListener</code>. 
     * 
     * The listener should set the {@link InputEvent#setConsumed() consumed flag}
     * on any events that have been consumed either at this call or previous calls.
     */
    public function afterInput():Void
	{
		
	}

    /**
     * Invoked on mouse movement/motion events.
     * 
     * @param evt 
     */
    public function onMouseMotionEvent(evt:MouseMotionEvent):Void
	{
		//if (!eventsPermitted) 
		//{
            //throw new Error("MouseInput has raised an event at an illegal time.");
        //}
		
		cursorPos.setTo(evt.getX(), evt.getY());
		inputQueue.push(evt);
	}
	
	public function onMouseWheelEvent(evt:MouseWheelEvent):Void
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
    public function onMouseButtonEvent(evt:MouseButtonEvent):Void
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
    public function onKeyEvent(evt:KeyInputEvent):Void
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
    public function setAxisDeadZone(deadZone:Float):Void
	{
        this.axisDeadZone = deadZone;
    }

    /**
     * Returns the deadzone for joystick axes.
     * 
     * @return the deadzone for joystick axes.
     */
    public function getAxisDeadZone():Float 
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
     * depending on which interface the <code>listener</code> implements. 
     * If the listener implements both interfaces, then it will receive the
     * appropriate event for each method.
     * 
     * @param listener The listener to register to receive input events.
     * @param mappingNames The mapping names which the listener will receive
     * events from.
     * 
     * @see InputManager#removeListener(com.jme3.input.controls.InputListener) 
     */
	public function addListener(listener:InputListener,mappingNames:Array<String>):Void
	{
        for (i in 0...mappingNames.length) 
		{
			var mappingName:String = mappingNames[i];
            var im:InputMapping = mappings.getValue(mappingName);
            if (im == null) 
			{
                im = new InputMapping(mappingName);
                mappings.setValue(mappingName, im);
            }
			
            if (!ArrayUtil.contain(im.listeners,listener))
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
    public function removeListener(listener:InputListener):Void
	{
		var inputMaps:Array<InputMapping> = mappings.toArray();
		for(map in inputMaps)
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
    public function addMapping(mappingName:String,triggers:flash.Vector<Trigger>):Void
	{
        var mapping:InputMapping = mappings.getValue(mappingName);
        if (mapping == null) 
		{
            mapping = new InputMapping(mappingName);
            mappings.setValue(mappingName, mapping);
        }

		var trigger:Trigger;
        for (trigger in triggers) 
		{
            var hash:Int = trigger.triggerHashCode();
            var names:Array<InputMapping> = bindings.getValue(hash);
            if (names == null) 
			{
                names = new Array<InputMapping>();
                bindings.setValue(hash, names);
            }
			
            if (!ArrayUtil.contain(names,mapping))
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
	
	public function addSingleMapping(mappingName:String,trigger:Trigger):Void
	{
		var mapping:InputMapping = mappings.getValue(mappingName);
        if (mapping == null) 
		{
            mapping = new InputMapping(mappingName);
            mappings.setValue(mappingName, mapping);
        }

        var hash:Int = trigger.triggerHashCode();
        var names:Array<InputMapping> = bindings.getValue(hash);
        if (names == null) 
		{
            names = new Array<InputMapping>();
            bindings.setValue(hash, names);
        }
			
        if (!ArrayUtil.contain(names,mapping))
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
    public function deleteMapping(mappingName:String):Void
	{
        var mapping:InputMapping = mappings.delete(mappingName);

        Assert.assert(mapping != null,"Cannot find mapping: " + mappingName);

        var triggers:Array<Int> = mapping.triggers;
		var i:Int = triggers.length;
        while (--i >= 0)
		{
            var hash:Int = triggers[i];
            var maps:Array<InputMapping> = bindings.getValue(hash);
            maps.remove(mapping);
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
    public function deleteTrigger(mappingName:String,trigger:Trigger):Void
	{
        var mapping:InputMapping = mappings.getValue(mappingName);
		
        Assert.assert(mapping != null,"Cannot find mapping: " + mappingName);

        var maps:Array<InputMapping> = bindings.getValue(trigger.triggerHashCode());
		
        maps.remove(mapping);

    }

    /**
     * Clears all the input mappings from this InputManager. 
     * Consequently, also clears all of the
     * InputListeners as well.
     */
    public function clearMappings():Void
	{
        mappings.clear();
        bindings.clear();
        reset();
    }

    /**
     * Do not use.
     * Called to reset pressed keys or buttons when focus is restored.
     */
    public function reset():Void
	{
        pressedButtons.clear();
        axisValues.clear();
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
    public function addRawInputListener(listener:RawInputListener):Void
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
    public function removeRawInputListener(listener:RawInputListener):Void 
	{
        rawListeners.remove(listener);
    }

    /**
     * Clears all {@link RawInputListener}s.
     * 
     * @see InputManager#addRawInputListener(com.jme3.input.RawInputListener) 
     */
    public function clearRawInputListeners():Void
	{
        ArrayUtil.clear(rawListeners);
    }
	
	/**
     * Updates the <code>InputManager</code>. 
     * This will query current input devices and send
     * appropriate events to registered listeners.
     *
     * @param tpf Time per frame value.
     */
    public function update(tpf:Float):Void
	{
        frameTPF = tpf;
        
        // Activate safemode if the TPF value is so small
        // that rounding errors are inevitable
        safeMode = tpf < 0.015;
        
        var currentTime:Int = Lib.getTimer();
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
	
	private function invokeActions(hash:Int, pressed:Bool):Void
	{
		var maps:Array<InputMapping> = bindings.getValue(hash);
		if (maps == null)
		{
			return;
		}
		
		var size:Int = maps.length;
		var i:Int = size;
		while (--i >= 0)
		{
			var mapping:InputMapping = maps[i];
			var listeners:Array<InputListener> = mapping.listeners;
			var j:Int = listeners.length;
			while (--j >= 0)
			{
				var listener:InputListener = listeners[j];
				if (Std.is(listener, ActionListener))
				{
					Lib.as(listener, ActionListener).onAction(mapping.name, pressed, frameTPF);
				}
			}
		}
	}
	
	private function computeAnalogValue(timeDelta:Float):Float
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
	
	private function invokeTimedActions(hash:Int, time:Float, pressed:Bool):Void
	{
		if (!bindings.containsKey(hash))
		{
			return;
		}
		
		if (pressed)
		{
			pressedButtons.setValue(hash, time);
		}
		else
		{
			var pressTime:Float = pressedButtons.delete(hash);
			var timeDelta:Float = time - FastMath.fmax(pressTime, lastLastUpdateTime);
			if (timeDelta > 0) 
			{
                invokeAnalogs(hash, computeAnalogValue(timeDelta), false);
            }
		}
	}
	
	private function processQueue():Void
	{
		var queueSize:Int = inputQueue.length;
		
        for (listener in rawListeners) 
		{
            listener.beforeInput();

            for (j in 0...queueSize) 
			{
                var event:InputEvent = inputQueue[j];
                if (event.isConsumed()) 
				{
                    continue;
                }
				
				if (Std.is(event, MouseMotionEvent)) 
				{
            	    listener.onMouseMotionEvent(Lib.as(event,MouseMotionEvent));
            	} 
				else if (Std.is(event, KeyInputEvent)) 
				{
            	    listener.onKeyEvent(Lib.as(event,KeyInputEvent));
            	} 
				else if (Std.is(event, MouseButtonEvent)) 
				{
            	    listener.onMouseButtonEvent(Lib.as(event,MouseButtonEvent));
            	} 
				else if (Std.is(event, MouseWheelEvent)) 
				{
            	    listener.onMouseWheelEvent(Lib.as(event,MouseWheelEvent));
            	} 
				else 
				{
					Assert.assert(false, "Can`t find this Event type");
				}
            }

            listener.afterInput();
        }

		
        for (i in 0...queueSize) 
		{
            var event:InputEvent = inputQueue[i];
            if (event.isConsumed()) 
			{
                continue;
            }

            if (Std.is(event, MouseMotionEvent)) 
			{
                onMouseMotionEventQueued(Lib.as(event,MouseMotionEvent));
            } 
			else if (Std.is(event, KeyInputEvent)) 
			{
                onKeyEventQueued(Lib.as(event,KeyInputEvent));
            } 
			else if (Std.is(event, MouseButtonEvent)) 
			{
                onMouseButtonEventQueued(Lib.as(event,MouseButtonEvent));
            } 
			else if (Std.is(event, MouseWheelEvent)) 
			{
                onMouseWheelEventQueued(Lib.as(event,MouseWheelEvent));
            } 
			else 
			{
               Assert.assert(false, "");
            }
        }
		
		ArrayUtil.clear(inputQueue);
    }
	
	private function invokeUpdateActions():Void
	{
		var hashs:Array<Int> = pressedButtons.toKeys();
		for(i in 0...hashs.length)
		{
			var hash:Int = hashs[i];
			var pressTime:Float = pressedButtons.getValue(hash);
			var timeDelta:Float = lastUpdateTime - FastMath.fmax(lastLastUpdateTime, pressTime);
			
			if (timeDelta > 0)
			{
				invokeAnalogs(hash, computeAnalogValue(timeDelta), false);
			}
		}
		
		var keys:Array<Int> = axisValues.toKeys();
		for(i in 0...keys.length)
		{
			var key:Int = keys[i];
			var value:Float = axisValues.getValue(key);
			invokeAnalogs(key, value * frameTPF, true);
		}
	}
	
	private function invokeAnalogs(hash:Int, value:Float, isAxis:Bool):Void
	{
		var maps:Array<InputMapping> = bindings.getValue(hash);
		if (maps == null)
		{
			return;
		}
		
		if (!isAxis)
		{
			value *= frameTPF;
		}
		
		var i:Int = maps.length;
		while (--i >= 0)
		{
			var mapping:InputMapping = maps[i];
			var listeners:Array<InputListener> = mapping.listeners;
			var j:Int = listeners.length;
			while (--j >= 0)
			{
				var listener:InputListener = listeners[j];
				if (Std.is(listener, AnalogListener))
				{
					// NOTE: multiply by TPF for any button bindings
					Lib.as(listener, AnalogListener).onAnalog(mapping.name, value, frameTPF);
				}
			}
		}
	}
	
	private function invokeAnalogsAndActions(hash:Int, value:Float, applyTpf:Bool):Void
	{
		if (value < axisDeadZone) 
		{
            invokeAnalogs(hash, value, !applyTpf);
            return;
        }
		
		var maps:Array<InputMapping> = bindings.getValue(hash);
		if (maps == null)
		{
			return;
		}
		
		var valueChanged:Bool = !axisValues.containsKey(hash);
		if (applyTpf)
		{
			value *= frameTPF;
		}
		
		var i:Int = maps.length;
		while (--i >= 0)
		{
			var mapping:InputMapping = maps[i];
			var listeners:Array<InputListener> = mapping.listeners;
			var j:Int = listeners.length;
			while (--j >= 0)
			{
				var listener:InputListener = listeners[j];
				
				if (Std.is(listener, ActionListener))
				{
					Lib.as(listener, ActionListener).onAction(mapping.name, true, frameTPF);
				}
				
				
				if (Std.is(listener, AnalogListener))
				{
					Lib.as(listener, AnalogListener).onAnalog(mapping.name, value, frameTPF);
				}
			}
		}
	}
	
	private function onMouseMotionEventQueued(evt:MouseMotionEvent):Void
	{
		var dx:Float = evt.getDX();
		if (dx != 0) 
		{
			var val:Float = FastMath.fabs(dx / 1024);
            invokeAnalogsAndActions(MouseAxisTrigger.mouseAxisHash(MouseInput.AXIS_X, dx < 0), val, false);
        }
		var dy:Float = evt.getDY();
        if (dy != 0) 
		{
            var val:Float = FastMath.fabs(dy / 1024);
            invokeAnalogsAndActions(MouseAxisTrigger.mouseAxisHash(MouseInput.AXIS_Y, dy < 0), val, false);
        }
	}
	
	private function onMouseWheelEventQueued(evt:MouseWheelEvent):Void
	{
		var delta:Int = evt.getDeltaWheel();
		if (delta != 0) 
		{
            //var val:Float = FastMath.fabs(delta / 10);
            invokeAnalogsAndActions(MouseAxisTrigger.mouseAxisHash(MouseInput.AXIS_WHEEL, delta < 0), delta, false);
        }
	}
	
	
	private function onKeyEventQueued(evt:KeyInputEvent):Void
	{
        var hash:Int = KeyTrigger.keyHash(evt.getKeyCode());
        invokeActions(hash, evt.isPressed());
        invokeTimedActions(hash, evt.getTime(), evt.isPressed());
    }
	
	private function onMouseButtonEventQueued(evt:MouseButtonEvent):Void
	{
		var hash:Int = MouseButtonTrigger.mouseButtonHash(evt.getButtonIndex());
		invokeActions(hash, evt.isPressed());
		invokeTimedActions(hash, evt.getTime(), evt.isPressed());
	}
}