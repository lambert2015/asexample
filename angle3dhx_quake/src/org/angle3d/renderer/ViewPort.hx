package org.angle3d.renderer;
import flash.Vector;
import org.angle3d.math.Color;
import org.angle3d.post.SceneProcessor;
import org.angle3d.renderer.queue.RenderQueue;
import org.angle3d.scene.Spatial;
import org.angle3d.texture.FrameBuffer;

/**
 * A <code>ViewPort</code> represents a view inside the display
 * window or a {@link FrameBuffer} to which scenes will be rendered. 
 * <p>
 * A viewport has a {@link #ViewPort(java.lang.String, org.angle3d.renderer.Camera) camera}
 * which is used to render a set of {@link #attachScene(org.angle3d.scene.Spatial) scenes}.
 * A view port has a location on the screen as set by the 
 * {@link Camera#setViewPort(float, float, float, float) } method.
 * By default, a view port does not clear the framebuffer, but it can be
 * set to {@link #setClearFlags(boolean, boolean, boolean) clear the framebuffer}.
 * The background color which the color buffer is cleared to can be specified 
 * via the {@link #setBackgroundColor(org.angle3d.math.ColorRGBA)} method.
 * <p>
 * A ViewPort has a list of {@link SceneProcessor}s which can
 * control how the ViewPort is rendered by the {@link RenderManager}.
 * 
 * @author Kirill Vainer
 * 
 * @see RenderManager
 * @see SceneProcessor
 * @see Spatial
 * @see Camera
 */

class ViewPort 
{
    private var _name:String;
	
	private var _camera:Camera3D;
	public var camera(__getCamera, never):Camera3D;
	
	private var _queue:RenderQueue;
	public var queue(__getRenderQueue, never):RenderQueue;
	
	private var _sceneList:Vector<Spatial>;
	private var _processors:Vector<SceneProcessor>;
	
	private var _frameBuffer:FrameBuffer;
	public var frameBuffer(__getFrameBuffer, __setFrameBuffer):FrameBuffer;
	
	private var _bgColor:Color;
	private var _clearDepth:Bool;
	private var _clearColor:Bool;
	private var _clearStencil:Bool;
	
	private var _enabled:Bool;
	public var enabled(__isEnabled, __setEnabled):Bool;
	
	/**
     * Create a new viewport. User code should generally use these methods instead:<br>
     * <ul>
     * <li>{@link RenderManager#createPreView(java.lang.String, org.angle3d.renderer.Camera) }</li>
     * <li>{@link RenderManager#createMainView(java.lang.String, org.angle3d.renderer.Camera)  }</li>
     * <li>{@link RenderManager#createPostView(java.lang.String, org.angle3d.renderer.Camera)  }</li>
     * </ul>
     * 
     * @param name The name of the viewport. Used for debugging only.
     * @param cam The camera through which the viewport is rendered. The camera
     * cannot be swapped to a different one after creating the viewport.
     */
	public function new(name:String,camera:Camera3D) 
	{
		_name = name;
		_camera = camera;
		_init();
	}
	
	private function _init():Void
	{
		_queue = new RenderQueue();
		_sceneList = new Vector<Spatial>();
		_processors = new Vector<SceneProcessor>();
		_bgColor = new Color();
		_bgColor.setColor(0x333333);
		_clearDepth = false;
		_clearColor = false;
		_clearStencil = false;
		_enabled = true;
	}
	
	/**
     * Returns the name of the viewport as set in the constructor.
     * 
     * @return the name of the viewport
     * 
     * @see #ViewPort(java.lang.String, org.angle3d.renderer.Camera) 
     */
	public function getName():String
	{
		return _name;
	}
	
	/**
     * Get the list of {@link SceneProcessor scene processors} that were
     * added to this <code>ViewPort</code>
     * 
     * @return the list of processors attached to this ViewPort
     * 
     * @see #addProcessor(org.angle3d.post.SceneProcessor) 
     */
	public function getProcessors():Vector<SceneProcessor>
	{
		return _processors;
	}
	
	/**
     * Adds a {@link SceneProcessor} to this ViewPort.
     * <p>
     * SceneProcessors that are added to the ViewPort will be notified
     * of events as the ViewPort is being rendered by the {@link RenderManager}.
     * 
     * @param processor The processor to add
     * 
     * @see SceneProcessor
     */
	public function addProcessor(processor:SceneProcessor):Void
	{
		_processors.push(processor);
	}
	
	/**
     * Removes a {@link SceneProcessor} from this ViewPort.
     * <p>
     * The processor will no longer receive events occurring to this ViewPort.
     * 
     * @param processor The processor to remove
     * 
     * @see SceneProcessor
     */
	public function removeProcessor(processor:SceneProcessor):Void
	{
		var index:Int = _processors.indexOf(processor);
		if (index != -1)
		{
			_processors.splice(index, 1);
			processor.cleanup();
		}
	}
	
	/**
     * Check if depth buffer clearing is enabled.
     * 
     * @return true if depth buffer clearing is enabled.
     * 
     * @see #setClearDepth(boolean) 
     */
	public function isClearDepth():Bool
	{
		return _clearDepth;
	}
	
	/**
     * Enable or disable clearing of the depth buffer for this ViewPort.
     * <p>
     * By default depth clearing is disabled.
     * 
     * @param clearDepth Enable/disable depth buffer clearing.
     */
	public function setClearDepth(clearDepth:Bool):Void
	{
		_clearDepth = clearDepth;
	}
	
	/**
     * Check if color buffer clearing is enabled.
     * 
     * @return true if color buffer clearing is enabled.
     * 
     * @see #setClearColor(boolean) 
     */
	public function isClearColor():Bool
	{
		return _clearColor;
	}
	
	/**
     * Enable or disable clearing of the color buffer for this ViewPort.
     * <p>
     * By default color clearing is disabled.
     * 
     * @param clearDepth Enable/disable color buffer clearing.
     */
	public function setClearColor(clearColor:Bool):Void
	{
		_clearColor = clearColor;
	}
	
	/**
     * Check if stencil buffer clearing is enabled.
     * 
     * @return true if stencil buffer clearing is enabled.
     * 
     * @see #setClearStencil(boolean) 
     */
	public function isClearStencil():Bool
	{
		return _clearStencil;
	}
	
	/**
     * Enable or disable clearing of the stencil buffer for this ViewPort.
     * <p>
     * By default stencil clearing is disabled.
     * 
     * @param clearDepth Enable/disable stencil buffer clearing.
     */
	public function setClearStencil(clearStencil:Bool):Void
	{
		_clearStencil = clearStencil;
	}
	
	/**
     * Set the clear flags (color, depth, stencil) in one call.
     * 
     * @param color If color buffer clearing should be enabled.
     * @param depth If depth buffer clearing should be enabled.
     * @param stencil If stencil buffer clearing should be enabled.
     * 
     * @see #setClearColor(boolean) 
     * @see #setClearDepth(boolean) 
     * @see #setClearStencil(boolean) 
     */
	public function setClearFlags(color:Bool, depth:Bool, stencil:Bool):Void
	{
		_clearColor = color;
		_clearDepth = depth;
		_clearStencil = stencil;
	}
	
	/**
     * Returns the framebuffer where this ViewPort's scenes are
     * rendered to.
     * 
     * @return the framebuffer where this ViewPort's scenes are
     * rendered to.
     * 
     * @see #setOutputFrameBuffer(org.angle3d.texture.FrameBuffer) 
     */
	private function __getFrameBuffer():FrameBuffer
	{
		return _frameBuffer;
	}
	
	/**
     * Sets the output framebuffer for the ViewPort.
     * <p>
     * The output framebuffer specifies where the scenes attached
     * to this ViewPort are rendered to. By default this is <code>null</code>
     * which indicates the scenes are rendered to the display window.
     * 
     * @param out The framebuffer to render scenes to, or null if to render
     * to the screen.
     */
	private function __setFrameBuffer(out:FrameBuffer):FrameBuffer
	{
		_frameBuffer = out;
		return _frameBuffer;
	}
	
	/**
     * Returns the camera which renders the attached scenes.
     * 
     * @return the camera which renders the attached scenes.
     * 
     * @see Camera
     */
	private function __getCamera():Camera3D
	{
		return _camera;
	}
	
	/**
     * Internal use only.
     */
	private function __getRenderQueue():RenderQueue
	{
		return _queue;
	}
	
	/**
     * Attaches a new scene to render in this ViewPort.
     * 
     * @param scene The scene to attach
     * 
     * @see Spatial
     */
	public function attachScene(scene:Spatial):Void
	{
		_sceneList.push(scene);
	}
	
	/**
     * Detaches a scene from rendering.
     * 
     * @param scene The scene to detach
     * 
     * @see #attachScene(org.angle3d.scene.Spatial) 
     */
	public function detachScene(scene:Spatial):Void
	{
		var index:Int = _sceneList.indexOf(scene);
		if (index != -1)
		{
			_sceneList.splice(index, 1);
		}
	}
	
	/**
     * Removes all attached scenes.
     * 
     * @see #attachScene(org.angle3d.scene.Spatial) 
     */
	public function clearScenes():Void
	{
		_sceneList.length = 0;
	}
	
	/**
     * Returns a list of all attached scenes.
     * 
     * @return a list of all attached scenes.
     * 
     * @see #attachScene(org.angle3d.scene.Spatial) 
     */
	public function getScenes():Vector<Spatial>
	{
		return _sceneList;
	}
	
	/**
     * Sets the background color.
     * <p>
     * When the ViewPort's color buffer is cleared 
     * (if {@link #setClearColor(boolean) color clearing} is enabled), 
     * this specifies the color to which the color buffer is set to.
     * By default the background color is black without alpha.
     * 
     * @param background the background color.
     */
	public function setBackgroundColor(color:UInt):Void
	{
		_bgColor.setColor(color);
	}
	
	/**
     * Returns the background color of this ViewPort
     * 
     * @return the background color of this ViewPort
     * 
     * @see #setBackgroundColor(org.angle3d.math.Color) 
     */
	public function getBackgroundColor():UInt
	{
		return _bgColor.getColor();
	}
	
	/**
     * Enable or disable this ViewPort.
     * <p>
     * Disabled ViewPorts are skipped by the {@link RenderManager} when
     * rendering. By default all ViewPorts are enabled.
     * 
     * @param enable If the viewport should be disabled or enabled.
     */
	private function __setEnabled(enabled:Bool):Bool
	{
		_enabled = enabled;
		return _enabled;
	}
	
	/**
     * Returns true if the viewport is enabled, false otherwise.
     * @return true if the viewport is enabled, false otherwise.
     * @see #setEnabled(boolean) 
     */
	private function __isEnabled():Bool
	{
		return _enabled;
	}
}