package org.angle3d.scene.control
{
	import org.angle3d.light.DirectionalLight;
	import org.angle3d.light.Light;
	import org.angle3d.light.PointLight;
	import org.angle3d.light.SpotLight;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.Spatial;
	import org.angle3d.math.Vector3f;

	/**
	 * This Control maintains a reference to a Light
	 * @author tim
	 */
	public class LightControl extends AbstractControl
	{
		/**
		 * Means, that the Light's transform is "copied"
		 * to the Transform of the Spatial.
		 */
		public static const LightToSpatial : String = "lightToSpatial";
		/**
		 * Means, that the Spatial's transform is "copied"
		 * to the Transform of the light.
		 */
		public static const SpatialToLight : String = "spatialToLight";

		private var light : Light;
		private var controlDir : String;

		public function LightControl(light : Light = null, controlDir : String = "spatialToLight")
		{
			super();

			if (light != null)
			{
				this.light = light;
			}

			this.controlDir = controlDir;
		}

		public function setControlDir(dir : String) : void
		{
			this.controlDir = dir;
		}

		public function setLight(light : Light) : void
		{
			if (light == null)
			{
				return;
			}
			this.light = light;
		}

		public function getLight() : Light
		{
			return light;
		}

		public function getControlDir() : String
		{
			return controlDir;
		}

		override protected function controlUpdate(tpf : Number) : void
		{
			if (spatial != null && light != null)
			{
				switch (controlDir)
				{
					case SpatialToLight:
						_spatialToLight(light);
						break;
					case LightToSpatial:
						_lightToSpatial(light);
						break;
				}
			}
		}

		private function _spatialToLight(light : Light) : void
		{
			if (light is PointLight)
			{
				var pl : PointLight = light as PointLight;
				pl.position = spatial.getWorldTranslation();
			}

			if (light is DirectionalLight)
			{
				var dl : DirectionalLight = light as DirectionalLight;
				//TODO 这里是不是传错了
				var p : Vector3f = dl.direction;
				p.copyFrom(spatial.getWorldTranslation());
					//p.scaleBy( -1);
			}

			//TODO add code for Spot light here when it's done
			//if (Std.is(light, SpotLight))
			//{
			//var sp:SpotLight = Lib.as(light, SpotLight);
			//sp.setPosition(spatial.getWorldTranslation());
			//sp.setRotation(spatial.getWorldRotation());
			//}
		}

		private function _lightToSpatial(light : Light) : void
		{
			var vecDiff : Vector3f;
			if (light is PointLight)
			{
				var pLight : PointLight = light as PointLight;

				vecDiff = pLight.position.subtract(spatial.getWorldTranslation());
				vecDiff.addLocal(spatial.getTranslation());
				spatial.setTranslation(vecDiff);
			}
			else if (light is DirectionalLight)
			{
				var dLight : DirectionalLight = light as DirectionalLight;
				vecDiff = dLight.direction.clone();
				vecDiff.scaleLocal(-1);
				vecDiff.subtractLocal(spatial.getWorldTranslation());
				vecDiff.addLocal(spatial.getTranslation());
				spatial.setTranslation(vecDiff);
			}
		}

		override protected function controlRender(rm : RenderManager, vp : ViewPort) : void
		{

		}

		override public function cloneForSpatial(newSpatial : Spatial) : Control
		{
			var control : LightControl = new LightControl(this.light, this.controlDir);
			control.spatial = newSpatial;
			control.enabled = enabled;
			return control;
		}
	}
}

