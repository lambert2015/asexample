package org.angle3d.scene.control
{
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.Spatial;

	/**
	 * An abstract implementation of the Control public interface.
	 *
	 * @author Kirill Vainer
	 */

	public class AbstractControl implements Control
	{
		protected var _enabled:Boolean;
		protected var _spatial:Spatial;

		public function AbstractControl()
		{
			_enabled = true;
		}

		public function set spatial(value:Spatial):void
		{
			if (_spatial != null && value != null)
			{
				throw new Error("This control has already been added to a Spatial");
			}

			_spatial = value;
		}

		public function get spatial():Spatial
		{
			return _spatial;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function update(tpf:Number):void
		{
			if (!enabled)
				return;

			controlUpdate(tpf);
		}

		/**
		 * To be implemented in subpublic class.
		 */
		protected function controlUpdate(tpf:Number):void
		{

		}

		public function render(rm:RenderManager, vp:ViewPort):void
		{
			if (!enabled)
				return;

			controlRender(rm, vp);
		}

		/**
		 * To be implemented in subpublic class.
		 */
		protected function controlRender(rm:RenderManager, vp:ViewPort):void
		{

		}

		/**
		 *  Default implementation of cloneForSpatial() that
		 *  simply clones the control and sets the spatial.
		 *  <pre>
		 *  AbstractControl c = clone();
		 *  c.spatial = null;
		 *  c.setSpatial(spatial);
		 *  </pre>
		 *
		 *  Controls that wish to be persisted must be Cloneable.
		 */
		public function cloneForSpatial(newSpatial:Spatial):Control
		{
			var c:Control = clone();
			c.spatial = null;
			return c;
		}

		public function clone():Control
		{
			return new AbstractControl();
		}
	}
}

