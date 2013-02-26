package org.angle3d.input.event;

/**
 * Keyboard key event.
 * 
 * @author Kirill Vainer
 */
class KeyInputEvent extends InputEvent
{
	
	private var keyCode:Int;
    private var keyChar:String;
    private var pressed:Bool;

	public function new(keyCode:Int,keyChar:String,pressed:Bool) 
	{
		super();
		
		this.keyCode = keyCode;
		this.keyChar = keyChar;
		this.pressed = pressed;
	}
	
	/**
     * Returns the key character. Returns 0 if the key has no character.
     * 
     * @return the key character. 0 if the key has no character.
     */
    public function getKeyChar():String 
	{
        return keyChar;
    }

    /**
     * The key code.
     * <p>
     * See KEY_*** constants in {@link KeyInput}.
     * 
     * @return key code.
     */
    public function getKeyCode():Int 
	{
        return keyCode;
    }

    /**
     * Returns true if this event is key press, false is it was a key release.
     * 
     * @return true if this event is key press, false is it was a key release.
     */
    public function isPressed():Bool  
	{
        return pressed;
    }

    /**
     * Returns true if this event is a key release, false if it was a key press.
     * 
     * @return true if this event is a key release, false if it was a key press.
     */
    public function isReleased():Bool 
	{
        return !pressed;
    }

    public function toString():String
	{
        var str:String = "Key(CODE="+keyCode;
        str = str + ", CHAR=" + keyChar;
            
        if (pressed)
		{
            return str + ", PRESSED)";
        }
		else
		{
            return str + ", RELEASED)";
        }
    }
	
}