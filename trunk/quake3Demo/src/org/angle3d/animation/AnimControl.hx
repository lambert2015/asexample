package org.angle3d.animation;
import org.angle3d.renderer.ViewPort;
import flash.Vector;
import org.angle3d.renderer.RenderManager;
import org.angle3d.scene.control.AbstractControl;
import org.angle3d.utils.Assert;
import org.angle3d.utils.HashMap;
/**
 * <code>AnimControl</code> is a Spatial control that allows manipulation
 * of skeletal animation.
 *
 * The control currently supports:
 * 1) Animation blending/transitions
 * 2) Multiple animation channels
 * 3) Multiple skins
 * 4) Animation event listeners
 * 5) Animated model cloning
 * 
 * Planned:
 * 1) Hardware skinning
 * 2) Morph/Pose animation
 * 3) Attachments
 * 4) Add/remove skins
 *
 * @author Kirill Vainer
 */
class AnimControl extends AbstractControl
{
	/**
     * Skeleton object must contain corresponding data for the targets' weight buffers.
     */
    public var skeleton:Skeleton;
	
	/**
     * List of animations
     */
	public var animationMap:HashMap<String,Animation>;
	
	/**
     * Animation channels
     */
	private var channels:Vector<AnimChannel>;
	
	/**
     * Animation event listeners
     */
	private var listeners:Vector<AnimEventListener>;

	/**
     * Creates a new animation control for the given skeleton.
     * The method {@link AnimControl#setAnimations(java.util.HashMap) }
     * must be called after initialization in order for this class to be useful.
     *
     * @param skeleton The skeleton to animate
     */
	public function new(skeleton:Skeleton) 
	{
		super();
		
		channels = new Vector<AnimChannel>();
		listeners = new Vector<AnimEventListener>();
		
		this.skeleton = skeleton;
		reset();
	}
	
	public function reset():Void
	{
        if (skeleton != null) 
		{
            skeleton.resetAndUpdate();
        }
    }
	
	public function getSkeleton():Skeleton
	{
		return skeleton;
	}
	
	/**
     * @return The names of all animations that this <code>AnimControl</code>
     * can play.
     */
	public function getAnimationNames():Array<String>
	{
		return animationMap.getKeys();
	}
	
	/**
     * Returns the length of the given named animation.
     * @param name The name of the animation
     * @return The length of time, in seconds, of the named animation.
     */
	public function getAnimationLength(name:String):Float
	{
		var a:Animation = animationMap.getValue(name);
		
		Assert.assert(a != null, "The animation " + name
                    + " does not exist in this AnimControl");
		
		return a.getLength();
	}
	
	/**
     * Internal use only.
     */
	override private function controlUpdate(tpf:Float):Void
	{
		if (skeleton != null)
		{
			skeleton.reset();//reset skeleton to bind pose
		}
		
		for (i in 0...channels.length)
		{
			channels[i].update(tpf);
		}
		
		if (skeleton != null)
		{
			skeleton.updateWorldVectors();
		}
		
	}
	
	/**
     * Internal use only.
     */
	override private function controlRender(rm:RenderManager, vp:ViewPort):Void 
	{
		super.controlRender(rm, vp);
	}
	
	public function notifyAnimChange(channel:AnimChannel,name:String):Void
	{
        for (i in 0...listeners.length) 
		{
            listeners[i].onAnimChange(this, channel, name);
        }
    }

    public function notifyAnimCycleDone(channel:AnimChannel, name:String):Void
	{
        for (i in 0...listeners.length) 
		{
            listeners[i].onAnimCycleDone(this, channel, name);
        }
    }
	
}