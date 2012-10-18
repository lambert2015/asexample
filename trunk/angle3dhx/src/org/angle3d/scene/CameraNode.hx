package org.angle3d.scene;
import org.angle3d.renderer.Camera3D;
import org.angle3d.scene.control.CameraControl;

/**
 * This Node is a shorthand for using a CameraControl.
 *
 * @author andy
 */

class CameraNode extends Node
{
    private var camControl:CameraControl;
	
	public function new(name:String,camera:Camera3D) 
	{
		super(name);
		if (camera != null)
		{
			camControl.setCamera(camera);
		}
	}
	
	public function getCameraControl():CameraControl
	{
		return camControl;
	}
	
	override private function _init():Void
	{
		super._init();
		camControl = new CameraControl();
		addControl(camControl);
	}
	
	public function setEnabled(enabled:Bool):Void
	{
		camControl.setEnabled(enabled);
	}
	
	public function isEnabled():Bool
	{
		return camControl.isEnabled();
	}
	
	public function setControlDir(controlDir:String):Void
	{
		 camControl.setControlDir(controlDir);
	}
	
	public function getControlDir():String
	{
		return camControl.getControlDir();
	}
	
	public function setCamera(camera:Camera3D):Void
	{
		camControl.setCamera(camera);
	}
	
	public function getCamera():Camera3D
	{
		return camControl.getCamera();
	}
}