package org.angle3d.material.post
{
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.renderer.queue.RenderQueue;
	import org.angle3d.texture.FrameBuffer;

	/**
	 * ...
	 * @author andy
	 */

	public class FilterPostProcessor implements SceneProcessor
	{
		private var _initialized:Boolean;

		public function FilterPostProcessor()
		{
			_initialized=false;
		}

		/**
		 * Called in the render thread to initialize the scene processor.
		 *
		 * @param rm The render manager to which the SP was added to
		 * @param vp The viewport to which the SP is assigned
		 */
		public function initialize(rm:RenderManager, vp:ViewPort):void
		{
			_initialized=true;
		}

		/**
		 * Called when the resolution of the viewport has been changed.
		 * @param vp
		 */
		public function reshape(vp:ViewPort, w:int, h:int):void
		{

		}

		/**
		 * @return True if initialize() has been called on this SceneProcessor,
		 * false if otherwise.
		 */
		public function get initialized():Boolean
		{
			return false;
		}

		/**
		 * Called before a frame
		 *
		 * @param tpf Time per frame
		 */
		public function preFrame(tpf:Number):void
		{

		}

		/**
		 * Called after the scene graph has been queued, but before it is flushed.
		 *
		 * @param rq The render queue
		 */
		public function postQueue(rq:RenderQueue):void
		{

		}

		/**
		 * Called after a frame has been rendered and the queue flushed.
		 *
		 * @param out The FB to which the scene was rendered.
		 */
		public function postFrame(out:FrameBuffer):void
		{

		}

		/**
		 * Called when the SP is removed from the RM.
		 */
		public function cleanup():void
		{

		}
	}
}

