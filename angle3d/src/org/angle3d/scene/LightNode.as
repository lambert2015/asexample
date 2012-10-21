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
		private var mLightControl:LightControl;

		public function LightNode(name:String, light:Light)
		{
			super(name);
			mLightControl=new LightControl(light);
			addControl(mLightControl);
		}

		/**
		 * Enable or disable the <code>LightNode</code> functionality.
		 *
		 * @param enabled If false, the functionality of LightNode will
		 * be disabled.
		 */
		public function setEnabled(enabled:Boolean):void
		{
			mLightControl.enabled=enabled;
		}

		public function isEnabled():Boolean
		{
			return mLightControl.enabled;
		}

		public function setControlDir(dir:String):void
		{
			mLightControl.setControlDir(dir);
		}

		public function setLight(light:Light):void
		{
			mLightControl.setLight(light);
		}

		public function getControlDir():String
		{
			return mLightControl.getControlDir();
		}

		public function getLight():Light
		{
			return mLightControl.getLight();
		}
	}
}

