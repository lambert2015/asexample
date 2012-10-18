package org.angle3d.animation;
import org.angle3d.math.FastMath;
import org.angle3d.utils.Assert;
import org.angle3d.utils.BitVector;

/**
 * <code>AnimChannel</code> provides controls, such as play, pause,
 * fast forward, etc, for an animation. The animation
 * channel may influence the entire model or specific bones of the model's
 * skeleton. A single model may have multiple animation channels influencing
 * various parts of its body. For example, a character model may have an
 * animation channel for its feet, and another for its torso, and
 * the animations for each channel are controlled independently.
 * 
 * @author Kirill Vainer
 */
class AnimChannel 
{
	private static var DEFAULT_BLEND_TIME:Float = 0.15;
	
	private static function clampWrapTime(t:Float,max:Float,loopMode:Int):Float
	{
        if (max == Math.POSITIVE_INFINITY)
            return t;
        
        if (t < 0)
		{
            switch (loopMode)
			{
                case LoopMode.DontLoop:
                    return 0;
                case LoopMode.Cycle:
                    return t;
                case LoopMode.Loop:
                    return max - t;
            }
        }
		else if (t > max)
		{
            switch (loopMode)
			{
                case LoopMode.DontLoop:
                    return max;
                case LoopMode.Cycle:
                    return /*-max;*/-(2 * max - t);
                case LoopMode.Loop:
                    return t - max;
            }
        }

        return t;
    }
	
	private var control:AnimControl;
	
	private var affectedBones:BitVector;
	
	private var animation:Animation;
	private var blendFrom:Animation;
	private var time:Float;
	private var speed:Float;
	private var timeBlendFrom:Float;
	private var speedBlendFrom:Float;
	
	private var loopMode:Int;
	private var loopModeBlendFrom:Int;
	
	private var blendAmount:Float;
	private var blendRate:Float;

	public function new(control:AnimControl) 
	{
		blendAmount = 1.0;
		blendRate = 0.0;
		
		this.control = control;
	}
	
	/**
     * Returns the parent control of this AnimChannel.
     * 
     * @return the parent control of this AnimChannel.
     * @see AnimControl
     */
	public function getControl():AnimControl
	{
		return control;
	}
	
	/**
     * @return The name of the currently playing animation, or null if
     * none is assigned.
     *
     * @see AnimChannel#setAnim(java.lang.String) 
     */
	public function getAnimationName():String
	{
		return animation != null ? animation.getName() : "";
	}
	
	/**
     * @return The loop mode currently set for the animation. The loop mode
     * determines what will happen to the animation once it finishes
     * playing.
     * 
     * For more information, see the LoopMode enum class.
     * @see LoopMode
     * @see AnimChannel#setLoopMode(com.jme3.animation.LoopMode)
     */
	public function getLoopMode():Int
	{
		return loopMode;
	}
	
	/**
     * @param loopMode Set the loop mode for the channel. The loop mode
     * determines what will happen to the animation once it finishes
     * playing.
     *
     * For more information, see the LoopMode enum class.
     * @see LoopMode
     */
	public function setLoopMode(mode:Int):Void
	{
		this.loopMode = mode;
	}
	
	/**
     * @return The speed that is assigned to the animation channel. The speed
     * is a scale value starting from 0.0, at 1.0 the animation will play
     * at its default speed.
     *
     * @see AnimChannel#setSpeed(float)
     */
	public function getSpeed():Float
	{
		return speed;
	}
	
	/**
     * @param speed Set the speed of the animation channel. The speed
     * is a scale value starting from 0.0, at 1.0 the animation will play
     * at its default speed.
     */
	public function setSpeed(speed:Float):Void
	{
		this.speed = speed;
	}
	
	/**
     * @return The time of the currently playing animation. The time
     * starts at 0 and continues on until getAnimMaxTime().
     *
     * @see AnimChannel#setTime(float)
     */
	public function getTime():Float
	{
		return time;
	}
	
	/**
     * @param speed Set the speed of the animation channel. The speed
     * is a scale value starting from 0.0, at 1.0 the animation will play
     * at its default speed.
     */
	public function setTime(time:Float):Void
	{
		this.time = FastMath.fclamp(time, 0, getAnimMaxTime());
	}
	
	/**
     * @return The length of the currently playing animation, or zero
     * if no animation is playing.
     *
     * @see AnimChannel#getTime()
     */
	public function getAnimMaxTime():Float
	{
        return animation != null ? animation.getLength() : 0;
    }
	
	/**
     * Set the current animation that is played by this AnimChannel.
     * <p>
     * This resets the time to zero, and optionally blends the animation
     * over <code>blendTime</code> seconds with the currently playing animation.
     * Notice that this method will reset the control's speed to 1.0.
     *
     * @param name The name of the animation to play
     * @param blendTime The blend time over which to blend the new animation
     * with the old one. If zero, then no blending will occur and the new
     * animation will be applied instantly.
     */
	public function setAnim(name:String, blendTime:Float = 0.15):Void
	{
		Assert.assert(blendTime >= 0.0, "blendTime cannot be less than zero");
		
		var anim:Animation = control.animationMap.getValue(name);
		
	    Assert.assert(anim != null, "Cannot find animation named: '" + name + "'");
		
		control.notifyAnimChange(this, name);
		
		if (animation != null && blendTime > 0)
		{
            // activate blending
            blendFrom = animation;
            timeBlendFrom = time;
            speedBlendFrom = speed;
            loopModeBlendFrom = loopMode;
            blendAmount = 0;
            blendRate   = 1 / blendTime;
        }

        animation = anim;
        time = 0;
        speed = 1;
        loopMode = LoopMode.Loop;
	}
	
	/**
     * Add all the bones of the model's skeleton to be
     * influenced by this animation channel.
     */
	public function addAllBones():Void
	{
		affectedBones = null;
	}
	
	/**
     * Add a single bone to be influenced by this animation channel.
     */
	public function addBoneByName(name:String):Void
	{
		addBone(control.getSkeleton().getBoneByName(name));
	}
	
	/**
     * Add a single bone to be influenced by this animation channel.
     */
    public function addBone(bone:Bone):Void
	{
        var boneIndex:Int = control.getSkeleton().getBoneIndex(bone);
        if (affectedBones == null) 
		{
            affectedBones = new BitVector(control.getSkeleton().getBoneCount());
        }
        affectedBones.set(boneIndex);
    }
	
	/**
     * Add bones to be influenced by this animation channel starting from the
     * given bone name and going toward the root bone.
     */
	public function addToRootBoneByName(name:String):Void
	{
		addToRootBone(control.getSkeleton().getBoneByName(name));
	}
	
	/**
     * Add bones to be influenced by this animation channel starting from the
     * given bone and going toward the root bone.
     */
	public function addToRootBone(bone:Bone):Void
	{
        addBone(bone);
		while (bone.getParent() != null)
		{
			bone = bone.getParent();
			addBone(bone);
		}
    }
	
	/**
     * Add bones to be influenced by this animation channel, starting
     * from the given named bone and going toward its children.
     */
	public function addFromRootBoneByName(name:String):Void
	{
        addFromRootBone(control.getSkeleton().getBoneByName(name));
    }
	
	/**
     * Add bones to be influenced by this animation channel, starting
     * from the given bone and going toward its children.
     */
	public function addFromRootBone(bone:Bone):Void
	{
        addBone(bone);
		if (bone.getChildren() == null)
            return;
			
		for(childBone in bone.getChildren())
		{
			addBone(childBone);
            addFromRootBone(childBone);
		}
    }
	
	public function getAffectedBones():BitVector
	{
		return affectedBones;
	}
	
	public function update(tpf:Float):Void
	{
		if (animation == null)
            return;
		
		if (blendFrom != null)
		{
            blendFrom.setTime(timeBlendFrom, 1 - blendAmount, control, this);
            //blendFrom.setTime(timeBlendFrom, control.skeleton, 1f - blendAmount, affectedBones);
            timeBlendFrom += tpf * speedBlendFrom;
            timeBlendFrom = clampWrapTime(timeBlendFrom,
                                          blendFrom.getLength(),
                                          loopModeBlendFrom);
            if (timeBlendFrom < 0)
			{
                timeBlendFrom = -timeBlendFrom;
                speedBlendFrom = -speedBlendFrom;
            }

            blendAmount += tpf * blendRate;
            if (blendAmount > 1)
			{
                blendAmount = 1;
                blendFrom = null;
            }
        }

        animation.setTime(time, blendAmount, control, this);
        //animation.setTime(time, control.skeleton, blendAmount, affectedBones);
        time += tpf * speed;

        if (animation.getLength() > 0)
		{
            if (time >= animation.getLength()) 
			{
                control.notifyAnimCycleDone(this, animation.getName());
            } 
			else if (time < 0) 
			{
                control.notifyAnimCycleDone(this, animation.getName());
            } 
        }

        time = clampWrapTime(time, animation.getLength(), loopMode);
        if (time < 0)
		{
            time = -time;
            speed = -speed;
        }	
	}
}