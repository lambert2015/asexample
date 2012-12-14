package org.angle3d.material.post
{
	import org.angle3d.material.Material;
	import org.angle3d.renderer.IRenderer;
	import org.angle3d.renderer.queue.RenderQueue;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.texture.FrameBuffer;

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
		public var name:String;
		
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
		protected final function init(renderManager:RenderManager, vp:ViewPort, w:int, h:int):void
		{
			defaultPass = new Pass();
			defaultPass.init(renderManager.getRenderer(), w, h);
			initFilter(renderManager, vp, w, h);
		}
		
		/**
		 * Initialization of sub classes filters
		 * This method is called once when the filter is added to the FilterPostProcessor
		 * It should contain Material initializations and extra passes initialization
		 * @param manager the assetManager
		 * @param renderManager the renderManager
		 * @param vp the viewPort where this filter is rendered
		 * @param w the width of the filter
		 * @param h the height of the filter
		 */
		protected function initFilter(renderManager:RenderManager, vp:ViewPort, w:int, h:int):void
		{
			
		}
		
		
		/**
		 * cleanup this filter
		 * @param r
		 */
		protected final function cleanUp(r:IRenderer):void
		{
			processor = null;
			if (defaultPass != null) {
				defaultPass.cleanup(r);
			}
			if (postRenderPasses != null) {
				for (var i:int = 0, il:int = postRenderPasses.length; i < il; i++)
				{
					var pass:Pass = postRenderPasses[i];
					pass.cleanup(r);
				}
			}
			cleanUpFilter(r);
		}
		
		/**
		 * override this method if you have some cleanup to do
		 * @param r the renderer
		 */
		protected function cleanUpFilter(r:IRenderer):void
		{
			
		}
		
		/**
		 * Must return the material used for this filter.
		 * this method is called every frame.
		 *
		 * @return the material used for this filter.
		 */
		protected function getMaterial():Material
		{
			return null;
		}
		
		/**
		 * Override this method if you want to make a pre pass, before the actual rendering of the frame
		 * @param queue
		 */
		protected function postQueue(queue:RenderQueue):void
		{
		}

		/**
		 * Override this method if you want to modify parameters according to tpf before the rendering of the frame.
		 * This is usefull for animated filters
		 * Also it can be the place to render pre passes
		 * @param tpf the time used to render the previous frame
		 */
		protected function preFrame(tpf:Number):void 
		{
		}

		/**
		 * Override this method if you want to make a pass just after the frame has been rendered and just before the filter rendering
		 * @param renderManager
		 * @param viewPort
		 * @param prevFilterBuffer
		 * @param sceneBuffer
		 */
		protected function postFrame(renderManager:RenderManager,viewPort:ViewPort, 
									prevFilterBuffer:FrameBuffer,sceneBuffer:FrameBuffer):void
		{
		}
		
		public function setEnabled(enabled:Boolean):void
		{
			if (processor != null)
			{
				processor.setFilterState(this, enabled);
			}
			else
			{
				this.enabled = enabled;
			}
		}
		
		public function isEnabled():Boolean
		{
			return this.enabled;
		}
		
		protected function setProcessor(proc:FilterPostProcessor):void
		{
			this.processor = proc;
		}

	}
}

