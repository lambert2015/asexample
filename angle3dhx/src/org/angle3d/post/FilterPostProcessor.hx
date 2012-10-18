package org.angle3d.post;
import org.angle3d.renderer.queue.RenderQueue;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.texture.FrameBuffer;

/**
 * ...
 * @author andy
 */

class FilterPostProcessor implements SceneProcessor
{

	public function new() 
	{
		
	}
	
	/**
     * Called in the render thread to initialize the scene processor.
     *
     * @param rm The render manager to which the SP was added to
     * @param vp The viewport to which the SP is assigned
     */
    public function initialize(rm:RenderManager,vp:ViewPort):Void
	{
		
	}

    /**
     * Called when the resolution of the viewport has been changed.
     * @param vp
     */
    public function reshape(vp:ViewPort,w:Int,h:Int):Void
	{
		
	}

    /**
     * @return True if initialize() has been called on this SceneProcessor,
     * false if otherwise.
     */
    public function isInitialized():Bool
	{
		return false;
	}

    /**
     * Called before a frame
     *
     * @param tpf Time per frame
     */
    public function preFrame(tpf:Float):Void
	{
		
	}

    /**
     * Called after the scene graph has been queued, but before it is flushed.
     *
     * @param rq The render queue
     */
    public function postQueue(rq:RenderQueue):Void
	{
		
	}

    /**
     * Called after a frame has been rendered and the queue flushed.
     *
     * @param out The FB to which the scene was rendered.
     */
    public function postFrame(out:FrameBuffer):Void
	{
		
	}

    /**
     * Called when the SP is removed from the RM.
     */
    public function cleanup():Void
	{
		
	}
	
}