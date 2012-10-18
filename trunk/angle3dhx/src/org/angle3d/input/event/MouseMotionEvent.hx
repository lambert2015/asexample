package org.angle3d.input.event;

/**
 * Mouse movement event.
 * <p>
 * Movement events are only generated if the mouse is on-screen.
 * 
 * @author Kirill Vainer
 */
class MouseMotionEvent extends InputEvent
{
	private var x:Float;
	private var y:Float;
	private var dx:Float;
	private var dy:Float;

	public function new(x:Float,y:Float,dx:Float,dy:Float) 
	{
		super();
		this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
	}

    /**
     * The change in X coordinate
     * @return change in X coordinate
     */
    public function getDX():Float
	{
        return dx;
    }

    /**
     * The change in Y coordinate
     * 
     * @return change in Y coordinate
     */
    public function getDY():Float
	{
        return dy;
    }

    /**
     * Current X coordinate
     * @return Current X coordinate
     */
    public function getX():Float
	{
        return x;
    }

    /**
     * Current Y coordinate
     * @return Current Y coordinate
     */
    public function getY():Float
	{
        return y;
    }

    public function toString():String
	{
        return "MouseMotion(x=" + x + ", y=" + y + ", dx=" + dx + ", dy=" + dy + ")";
    }
	
}