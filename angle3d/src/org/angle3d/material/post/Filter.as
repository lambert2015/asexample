package org.angle3d.material.post
{
	import org.angle3d.material.Material;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;

	/**
	 * Filters are 2D effects applied to the rendered scene.<br>
	 * The filter is fed with the rendered scene image rendered in an offscreen frame buffer.<br>
	 * This texture is applied on a fullscreen quad, with a special material.<br>
	 * This material uses a shader that aplly the desired effect to the scene texture.<br>
	 * <br>
	 * This public class is abstract, any Filter must extend it.<br>
	 * Any filter holds a frameBuffer and a texture<br>
	 * The getMaterial must return a Material that use a GLSL shader immplementing the desired effect<br>
	 *
	 * @author Rémy Bouquet aka Nehon
	 */
	public class Filter
	{
		private var name:String;
		protected var defaultPass:Pass;
		protected var postRenderPasses:Vector.<Pass>;
		protected var material:Material;
		protected var enabled:Boolean = true;
		protected var processor:FilterPostProcessor;


		public function Filter(name:String)
		{
			this.name = name;
		}

		/**
		 *
		 * initialize this filter
		 * use InitFilter for overriding filter initialization
		 * @param manager the assetManager
		 * @param renderManager the renderManager
		 * @param vp the viewport
		 * @param w the width
		 * @param h the height
		 */
		protected function init(renderManager:RenderManager, vp:ViewPort, w:int, h:int):void
		{
			defaultPass = new Pass();
			defaultPass.init(renderManager.getRenderer(), w, h);
			initFilter(renderManager, vp, w, h);
		}
	}
}

