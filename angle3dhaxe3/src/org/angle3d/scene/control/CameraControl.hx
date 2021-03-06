package org.angle3d.scene.control;

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
class CameraControl extends AbstractControl
{
	public var controlDir(get, set):String;
	public var camera(get, set):Camera3D;
	
	/**
	 * Means, that the Camera's transform is "copied"
	 * to the Transform of the Spatial.
	 */
	public static inline var CameraToSpatial:String = "cameraToSpatial";
	/**
	 * Means, that the Spatial's transform is "copied"
	 * to the Transform of the Camera.
	 */
	public static inline var SpatialToCamera:String = "spatialToCamera";

	private var mCamera:Camera3D;
	private var mControlDir:String;

	public function new(camera:Camera3D = null, controlDir:String = null)
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

	
	private function set_controlDir(dir:String):String
	{
		return this.mControlDir = dir;
	}
	
	private function get_controlDir():String
	{
		return mControlDir;
	}

	
	private function set_camera(camera:Camera3D):Camera3D
	{
		return this.mCamera = camera;
	}

	private function get_camera():Camera3D
	{
		return mCamera;
	}

	override private function controlUpdate(tpf:Float):Void
	{
		if (spatial != null && mCamera != null)
		{
			switch (mControlDir)
			{
				case SpatialToCamera:
					mCamera.location = spatial.getWorldTranslation();
					mCamera.rotation = spatial.getWorldRotation();
				case CameraToSpatial:
					// set_the localtransform, so that the worldtransform would be equal to the camera's transform.
					// Location:
					var vecDiff:Vector3f = mCamera.location.subtract(spatial.getWorldTranslation());
					vecDiff.addLocal(spatial.translation);

					// Rotation:
					var worldDiff:Quaternion = mCamera.rotation.subtract(spatial.getWorldRotation());
					worldDiff.addLocal(spatial.getRotation());
					spatial.setRotation(worldDiff);
			}
		}
	}

	override private function controlRender(rm:RenderManager, vp:ViewPort):Void
	{

	}

	override public function cloneForSpatial(newSpatial:Spatial):Control
	{
		var control:CameraControl = new CameraControl(this.mCamera, this.mControlDir);
		control.spatial = newSpatial;
		control.enabled = enabled;
		return control;
	}
}

