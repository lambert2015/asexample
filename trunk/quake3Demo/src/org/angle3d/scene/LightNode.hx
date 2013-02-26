package org.angle3d.scene;
import org.angle3d.light.Light;
import org.angle3d.scene.control.LightControl;

/**
 * <code>LightNode</code> is used to link together a {@link Light} object
 * with a {@link Node} object. 
 *
 * @author Tim8Dev
 */
class LightNode extends Node
{
	private var lightControl:LightControl;

	public function new(name:String,light:Light)
	{
		super(name);
		lightControl = new LightControl(light);
		addControl(lightControl);
	}
	
	/**
     * Enable or disable the <code>LightNode</code> functionality.
     * 
     * @param enabled If false, the functionality of LightNode will
     * be disabled.
     */
	public function setEnabled(enabled:Bool):Void
	{
		lightControl.setEnabled(enabled);
	}
	
	public function isEnabled():Bool
	{
		return lightControl.isEnabled();
	}
	
	public function setControlDir(dir:String):Void
	{
		lightControl.setControlDir(dir);
	}
	
	public function setLight(light:Light):Void
	{
		lightControl.setLight(light);
	}
	
	public function getControlDir():String
	{
		return lightControl.getControlDir();
	}
	
	public function getLight():Light
	{
		return lightControl.getLight();
	}
}