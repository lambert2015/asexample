package org.angle3d.scene.control
{
	import org.angle3d.math.Quaternion;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.Spatial;
	import org.angle3d.math.Vector3f;

	/**
	 * This Control maintains a reference to a Camera,
	 * which will be synched with the position (worldTranslation)
	 * of the current spatial.
	 * @author tim
	 */
	public class CameraControl extends AbstractControl
	{
		/**
		 * Means, that the Camera's transform is "copied"
		 * to the Transform of the Spatial.
		 */
		public static const CameraToSpatial : String = "cameraToSpatial";
		/**
		 * Means, that the Spatial's transform is "copied"
		 * to the Transform of the Camera.
		 */
		public static const SpatialToCamera : String = "spatialToCamera";

		private var mCamera : Camera3D;
		private var mControlDir : String;

		public function CameraControl(camera : Camera3D = null, controlDir : String = null)
		{
			super();

			this.mCamera = camera;

			if (controlDir != null)
			{
				this.mControlDir = controlDir;
			}
			else
			{
				controlDir = SpatialToCamera;
			}
		}

		public function set controlDir(dir : String) : void
		{
			this.mControlDir = dir;
		}

		public function set camera(camera : Camera3D) : void
		{
			this.mCamera = camera;
		}

		public function get camera() : Camera3D
		{
			return mCamera;
		}

		public function get controlDir() : String
		{
			return mControlDir;
		}

		override protected function controlUpdate(tpf : Number) : void
		{
			if (spatial != null && mCamera != null)
			{
				switch (mControlDir)
				{
					case SpatialToCamera:
						mCamera.location = spatial.getWorldTranslation();
						mCamera.rotation = spatial.getWorldRotation();
						break;
					case CameraToSpatial:
						// set the localtransform, so that the worldtransform would be equal to the camera's transform.
						// Location:
						var vecDiff : Vector3f = mCamera.location.subtract(spatial.getWorldTranslation());
						vecDiff.addLocal(spatial.getTranslation());

						// Rotation:
						var worldDiff : Quaternion = mCamera.rotation.subtract(spatial.getWorldRotation());
						worldDiff.addLocal(spatial.getRotation());
						spatial.setRotation(worldDiff);
						break;
				}
			}
		}

		override protected function controlRender(rm : RenderManager, vp : ViewPort) : void
		{

		}

		override public function cloneForSpatial(newSpatial : Spatial) : Control
		{
			var control : CameraControl = new CameraControl(this.mCamera, this.mControlDir);
			control.spatial = newSpatial;
			control.enabled = enabled;
			return control;
		}
	}
}

