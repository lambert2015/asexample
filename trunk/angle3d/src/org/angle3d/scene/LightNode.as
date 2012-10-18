package org.angle3d.scene
{
	import org.angle3d.light.Light;
	import org.angle3d.scene.control.LightControl;

	/**
	 * <code>LightNode</code> is used to link together a {@link Light} object
	 * with a {@link Node} object.
	 *
	 * @author Tim8Dev
	 */
	public class LightNode extends Node
	{
		private var lightControl:LightControl;

		public function LightNode(name:String, light:Light)
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
		public function setEnabled(enabled:Boolean):void
		{
			lightControl.enabled = enabled;
		}

		public function isEnabled():Boolean
		{
			return lightControl.enabled;
		}

		public function setControlDir(dir:String):void
		{
			lightControl.setControlDir(dir);
		}

		public function setLight(light:Light):void
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
}

