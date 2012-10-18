package org.angle3d.shadow
{
	import org.angle3d.light.DirectionalLight;
	import org.angle3d.light.Light;
	import org.angle3d.light.LightType;
	import org.angle3d.light.PointLight;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;

	/**
	 * Creates a camera according to a light
	 * Handy to compute projection matrix of a light
	 * @author Kirill Vainer
	 */
	public class ShadowCamera
	{
		private var points:Vector.<Vector3f> = new Vector.<Vector3f>(8, true);
		private var target:Light;

		public function ShadowCamera(target:Light)
		{
			this.target = target;
			for (var i:int = 0; i < points.length; i++)
			{
				points[i] = new Vector3f();
			}
		}

		/**
		 * Updates the camera view direction and position based on the light
		 */
		public function updateLightCamera(lightCam:Camera3D):void
		{
			if (target.type == LightType.Directional)
			{
				var dl:DirectionalLight = target as DirectionalLight;
				lightCam.parallelProjection = true;
				lightCam.location = Vector3f.ZERO;
				lightCam.lookAtDirection(dl.direction, Vector3f.Y_AXIS);
				lightCam.setFrustum(-1, 1, -1, 1, 1, -1);
			}
			else
			{
				var pl:PointLight = target as PointLight;
				lightCam.parallelProjection = false;
				lightCam.location = pl.position;
				// direction will have to be calculated automatically
				lightCam.setFrustumPerspective(45, 1, 1, 300);
			}
		}
	}
}
