package org.angle3d.input.controls;
import org.angle3d.utils.Assert;

/**
 * A <code>MouseButtonTrigger</code> is used as a mapping to receive events
 * from mouse buttons. It is generally expected for a mouse to have at least
 * a left and right mouse button, but some mice may have a lot more buttons
 * than that.
 *
 * @author Kirill Vainer
 */
class MouseWheelButtonTrigger extends MouseButtonTrigger
{
	/**
     * Create a new <code>MouseButtonTrigger</code> to receive mouse button events.
     * 
     * @param mouseButton Mouse button index. See BUTTON_*** constants in
     * {@link MouseInput}.
     */
	public function new() 
	{
		super(2);
	}

    override public function triggerHashCode():Int
	{
        return MouseButtonTrigger.mouseButtonHash(mouseButton);
    }
	
}