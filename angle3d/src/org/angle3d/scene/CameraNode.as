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
		private var mCamControl:CameraControl;

		public function CameraNode(name:String, camera:Camera3D)
		{
			super(name);
			if (camera != null)
			{
				mCamControl.camera=camera;
			}
		}

		public function getCameraControl():CameraControl
		{
			return mCamControl;
		}

		override protected function _init():void
		{
			super._init();
			mCamControl=new CameraControl();
			addControl(mCamControl);
		}

		public function setEnabled(enabled:Boolean):void
		{
			mCamControl.enabled=enabled;
		}

		public function isEnabled():Boolean
		{
			return mCamControl.enabled;
		}

		public function set controlDir(controlDir:String):void
		{
			mCamControl.controlDir=controlDir;
		}

		public function get controlDir():String
		{
			return mCamControl.controlDir;
		}

		public function setCamera(camera:Camera3D):void
		{
			mCamControl.camera=camera;
		}

		public function getCamera():Camera3D
		{
			return mCamControl.camera;
		}
	}
}

