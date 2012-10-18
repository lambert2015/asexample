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

		private var camera : Camera3D;
		private var controlDir : String;

		public function CameraControl(camera : Camera3D = null, controlDir : String = null)
		{
			super();

			this.camera = camera;

			if (controlDir != null)
			{
				this.controlDir = controlDir;
			}
			else
			{
				controlDir = SpatialToCamera;
			}
		}

		public function setControlDir(dir : String) : void
		{
			this.controlDir = dir;
		}

		public function setCamera(camera : Camera3D) : void
		{
			this.camera = camera;
		}

		public function getCamera() : Camera3D
		{
			return camera;
		}

		public function getControlDir() : String
		{
			return controlDir;
		}

		override protected function controlUpdate(tpf : Number) : void
		{
			if (spatial != null && camera != null)
			{
				switch (controlDir)
				{
					case SpatialToCamera:
						camera.location = spatial.getWorldTranslation();
						camera.rotation = spatial.getWorldRotation();
						break;
					case CameraToSpatial:
						// set the localtransform, so that the worldtransform would be equal to the camera's transform.
						// Location:
						var vecDiff : Vector3f = camera.location.subtract(spatial.getWorldTranslation());
						vecDiff.addLocal(spatial.getTranslation());

						// Rotation:
						var worldDiff : Quaternion = camera.rotation.subtract(spatial.getWorldRotation());
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
			var control : CameraControl = new CameraControl(this.camera, this.controlDir);
			control.spatial = newSpatial;
			control.enabled = enabled;
			return control;
		}
	}
}

