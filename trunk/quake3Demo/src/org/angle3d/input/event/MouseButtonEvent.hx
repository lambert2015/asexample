package org.angle3d.input.event;

/**
 * Mouse button press/release event.
 * 
 * @author Kirill Vainer
 */
class MouseButtonEvent extends InputEvent
{
	private var x:Float;
	private var y:Float;
	private var pressed:Bool;

	public function new(pressed:Bool, x:Float, y:Float) 
	{
		super();
		
		this.pressed = pressed;
		this.x = x;
		this.y = y;
	}
	
	/**
     * The X coordinate of the mouse when the event was generated.
     * @return X coordinate of the mouse when the event was generated.
     */
	public function getX():Float 
	{
        return x;
    }
	
	/**
     * The Y coordinate of the mouse when the event was generated.
     * @return Y coordinate of the mouse when the event was generated.
     */
	public function getY():Float 
	{
        return y;
    }

    /**
     * Returns true if the mouse button was pressed, false if it was released.
     * 
     * @return true if the mouse button was pressed, false if it was released.
     */
    public function isPressed():Bool  
	{
        return pressed;
    }

    /**
     * Returns true if the mouse button was released, false if it was pressed.
     * 
     * @return true if the mouse button was released, false if it was pressed.
     */
    public function isReleased():Bool 
	{
        return !pressed;
    }
	
	public function getButtonIndex():Int
	{
		return 0;
	}
	
}