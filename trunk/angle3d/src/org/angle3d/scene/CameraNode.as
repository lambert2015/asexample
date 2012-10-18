package org.angle3d.scene
{
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.scene.control.CameraControl;

	/**
	 * This Node is a shorthand for using a CameraControl.
	 *
	 * @author andy
	 */

	public class CameraNode extends Node
	{
		private var camControl:CameraControl;

		public function CameraNode(name:String, camera:Camera3D)
		{
			super(name);
			if (camera != null)
			{
				camControl.camera = camera;
			}
		}

		public function getCameraControl():CameraControl
		{
			return camControl;
		}

		override protected function _init():void
		{
			super._init();
			camControl = new CameraControl();
			addControl(camControl);
		}

		public function setEnabled(enabled:Boolean):void
		{
			camControl.enabled = enabled;
		}

		public function isEnabled():Boolean
		{
			return camControl.enabled;
		}

		public function set controlDir(controlDir:String):void
		{
			camControl.controlDir = controlDir;
		}

		public function get controlDir():String
		{
			return camControl.controlDir;
		}

		public function setCamera(camera:Camera3D):void
		{
			camControl.camera = camera;
		}

		public function getCamera():Camera3D
		{
			return camControl.camera;
		}
	}
}

