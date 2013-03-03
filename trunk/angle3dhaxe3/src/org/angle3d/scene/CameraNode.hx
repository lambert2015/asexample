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
	private var mCamControl:CameraControl;

	public function new(name:String, camera:Camera3D)
	{
		super(name);
		if (camera != null)
		{
			mCamControl.camera = camera;
		}
	}

	public function getCameraControl():CameraControl
	{
		return mCamControl;
	}

	override private function _init():Void
	{
		super._init();
		mCamControl = new CameraControl();
		addControl(mCamControl);
	}

	public function setEnabled(enabled:Bool):Void
	{
		mCamControl.enabled = enabled;
	}

	public function isEnabled():Bool
	{
		return mCamControl.enabled;
	}

	public var controlDir(get, set):String;
	private function set_controlDir(controlDir:String):String
	{
		mCamControl.controlDir = controlDir;
		return mCamControl.controlDir;
	}

	private function get_controlDir():String
	{
		return mCamControl.controlDir;
	}

	public function setCamera(camera:Camera3D):Void
	{
		mCamControl.camera = camera;
	}

	public function getCamera():Camera3D
	{
		return mCamControl.camera;
	}
}

