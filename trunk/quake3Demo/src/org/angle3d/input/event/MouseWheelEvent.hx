package org.angle3d.input.event;

/**
 * Mouse movement event.
 * <p>
 * Movement events are only generated if the mouse is on-screen.
 * 
 * @author Kirill Vainer
 */
class MouseWheelEvent extends InputEvent
{
	private var wheel:Int;
	private var deltaWheel:Int;

	public function new(wheel:Int,deltaWheel:Int) 
	{
		super();
        this.wheel = wheel;
        this.deltaWheel = deltaWheel;
	}
	
	/**
     * The change in wheel rotation.
     * 
     * @return change in wheel rotation.
     */
    public function getDeltaWheel():Int 
	{
        return deltaWheel;
    }

    /**
     * Current mouse wheel value
     * @return Current mouse wheel value
     */
    public function getWheel():Int
	{
        return wheel;
    }

    public function toString():String
	{
        return "MouseWheel(wheel=" + wheel + ", deltaWheel=" + deltaWheel + ")";
    }
	
	public function getButtonIndex():Int
	{
		return 2;
	}
	
}