package org.angle3d.animation;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Quaternion;
import org.angle3d.math.Transform;
import org.angle3d.scene.Node;
import org.angle3d.utils.Assert;

/**
 * <code>Bone</code> describes a bone in the bone-weight skeletal animation
 * system. A bone contains a name and an index, as well as relevant
 * transformation data.
 *
 * @author Kirill Vainer
 */
//TODO 未完成
class Bone 
{
	private var name:String;
	private var parent:Bone;
    private var children:Vector<Bone>;
	
	/**
     * If enabled, user can control bone transform with setUserTransforms.
     * Animation transforms are not applied to this bone when enabled.
     */
    private var userControl:Bool;
	
	/**
	 * The attachment node
	 */
	private var attachNode:Node;
	
	/**
     * Initial transform is the local bind transform of this bone.
     * PARENT SPACE -> BONE SPACE
     */
    private var initialPos:Vector3f;
    private var initialRot:Quaternion;
    private var initialScale:Vector3f;
    /**
     * The inverse world bind transform.
     * BONE SPACE -> MODEL SPACE
     */
    private var worldBindInversePos:Vector3f;
    private var worldBindInverseRot:Quaternion;
    private var worldBindInverseScale:Vector3f;
    /**
     * The local animated transform combined with the local bind transform and parent world transform
     */
    private var localPos:Vector3f;
    private var localRot:Quaternion;
    private var localScale:Vector3f;
    /**
     * MODEL SPACE -> BONE SPACE (in animated state)
     */
    private var worldPos:Vector3f;
    private var worldRot:Quaternion;
    private var worldScale:Vector3f;
    //used for getCombinedTransform 
    private var tmpTransform:Transform;
	
	
	public function new(name:String) 
	{
		this.name = name;
		
		children = new Vector<Bone>();
		userControl = false;
		
		initialPos = new Vector3f();
		initialRot = new Quaternion();
		initialScale = new Vector3f(1.0, 1.0, 1.0);
		
		localPos = new Vector3f();
		localRot = new Quaternion();
		localScale = new Vector3f(1.0, 1.0, 1.0);
		
		worldPos = new Vector3f();
		worldRot = new Quaternion();
		worldScale = new Vector3f(1.0, 1.0, 1.0);
		
		tmpTransform = new Transform();
		
		worldBindInversePos = new Vector3f();
		worldBindInverseRot = new Quaternion();
		worldBindInverseScale = new Vector3f(1.0, 1.0, 1.0);
	}
	
	/**
     * Returns the name of the bone, set in the constructor.
     * 
     * @return The name of the bone, set in the constructor.
     */
	public function getName():String
	{
		return name;
	}
	
	/**
     * Returns parent bone of this bone, or null if it is a root bone.
     * @return The parent bone of this bone, or null if it is a root bone.
     */
	public function getParent():Bone
	{
		return parent;
	}
	
	/**
     * Returns all the children bones of this bone.
     * 
     * @return All the children bones of this bone.
     */
	public function getChildren():Vector<Bone>
	{
		return children;
	}
	
	/**
     * Returns the local position of the bone, relative to the parent bone.
     * 
     * @return The local position of the bone, relative to the parent bone.
     */
	public function getLocalPosition():Vector3f
	{
		return localPos;
	}
	
	/**
     * Returns the local rotation of the bone, relative to the parent bone.
     * 
     * @return The local rotation of the bone, relative to the parent bone.
     */
	public function getLocalRotation():Quaternion
	{
		return localRot;
	}
	
	/**
     * Returns the local scale of the bone, relative to the parent bone.
     * 
     * @return The local scale of the bone, relative to the parent bone.
     */
	public function getLocalScale():Vector3f
	{
		return localScale;
	}
	
	/**
     * Returns the position of the bone in model space.
     * 
     * @return The position of the bone in model space.
     */
    public function getModelSpacePosition():Vector3f 
	{
        return worldPos;
    }

    /**
     * Returns the rotation of the bone in model space.
     * 
     * @return The rotation of the bone in model space.
     */
    public function getModelSpaceRotation():Quaternion 
	{
        return worldRot;
    }

    /**
     * Returns the scale of the bone in model space.
     * 
     * @return The scale of the bone in model space.
     */
    public function getModelSpaceScale():Vector3f 
	{
        return worldScale;
    }

    /**
     * Returns the inverse world bind pose position.
     * <p>
     * The bind pose transform of the bone is its "default"
     * transform with no animation applied.
     * 
     * @return the inverse world bind pose position.
     */
    public function getWorldBindInversePosition():Vector3f 
	{
        return worldBindInversePos;
    }

    /**
     * Returns the inverse world bind pose rotation.
     * <p>
     * The bind pose transform of the bone is its "default"
     * transform with no animation applied.
     * 
     * @return the inverse world bind pose rotation.
     */
    public function getWorldBindInverseRotation():Quaternion 
	{
        return worldBindInverseRot;
    }

    /**
     * Returns the inverse world bind pose scale.
     * <p>
     * The bind pose transform of the bone is its "default"
     * transform with no animation applied.
     * 
     * @return the inverse world bind pose scale.
     */
    public function getWorldBindInverseScale():Vector3f  
	{
        return worldBindInverseScale;
    }

    /**
     * Returns the world bind pose position.
     * <p>
     * The bind pose transform of the bone is its "default"
     * transform with no animation applied.
     * 
     * @return the world bind pose position.
     */
    public function getWorldBindPosition():Vector3f  {
        return initialPos;
    }

    /**
     * Returns the world bind pose rotation.
     * <p>
     * The bind pose transform of the bone is its "default"
     * transform with no animation applied.
     * 
     * @return the world bind pose rotation.
     */
    public function getWorldBindRotation():Quaternion 
	{
        return initialRot;
    }

    /**
     * Returns the world bind pose scale.
     * <p>
     * The bind pose transform of the bone is its "default"
     * transform with no animation applied.
     * 
     * @return the world bind pose scale.
     */
    public function getWorldBindScale():Vector3f 
	{
        return initialScale;
    }

    /**
     * If enabled, user can control bone transform with setUserTransforms.
     * Animation transforms are not applied to this bone when enabled.
     */
    public function setUserControl(enable:Bool):Void 
	{
        userControl = enable;
    }
	
	/**
     * Add a new child to this bone. Shouldn't be used by user code.
     * Can corrupt skeleton.
     * 
     * @param bone The bone to add
     */
    public function addChild(bone:Bone):Void
	{
        children.push(bone);
        bone.parent = this;
    }

    /**
     * Updates the world transforms for this bone, and, possibly the attach node
     * if not null.
     * <p>
     * The world transform of this bone is computed by combining the parent's
     * world transform with this bones' local transform.
     */
    public function updateWorldVectors():Void
	{
        if (parent != null) 
		{
            //rotation
            parent.worldRot.multiply(localRot, worldRot);

            //scale
			parent.worldScale.multiply(localScale, worldScale);

            //translation
            //scale and rotation of parent affect bone position            
            parent.worldRot.multiplyVector(localPos, worldPos);
			
			worldPos.multiplyLocal(parent.worldScale);
            worldPos.addLocal(parent.worldPos);
        } 
		else 
		{
            worldRot.copyFrom(localRot);
            worldPos.copyFrom(localPos);
            worldScale.copyFrom(localScale);
        }

        if (attachNode != null) 
		{
            attachNode.setLocalTranslation(worldPos);
            attachNode.setLocalRotation(worldRot);
            attachNode.setLocalScale(worldScale);
        }
    }

    /**
     * Updates world transforms for this bone and it's children.
     */
    public function update():Void
	{
        this.updateWorldVectors();

		var i:Int = children.length;
		while (--i >= 0)
		{
			children[i].update();
		}
    }

    /**
     * Saves the current bone state as its binding pose, including its children.
     */
    public function setBindingPose():Void
	{
        initialPos.copyFrom(localPos);
        initialRot.copyFrom(localRot);
        initialScale.copyFrom(localScale);

        if (worldBindInversePos == null) 
		{
            worldBindInversePos = new Vector3f();
            worldBindInverseRot = new Quaternion();
            worldBindInverseScale = new Vector3f();
        }

        // Save inverse derived position/scale/orientation, used for calculate offset transform later
        worldBindInversePos.copyFrom(worldPos);
        worldBindInversePos.scaleLocal( -1);

        worldBindInverseRot.copyFrom(worldRot);
        worldBindInverseRot.inverseLocal();

        worldBindInverseScale.setTo(1, 1, 1);
		worldBindInverseScale.divideLocal(worldScale);

		var b:Bone;
        for (b in children) 
		{
            b.setBindingPose();
        }
    }

    /**
     * Reset the bone and it's children to bind pose.
     */
    public function reset():Void
	{
        if (!userControl) 
		{
            localPos.copyFrom(initialPos);
            localRot.copyFrom(initialRot);
            localScale.copyFrom(initialScale);
        }
		
		var i:Int = children.length;
		while (--i >= 0)
		{
			children[i].reset();
		}
    }

     /**
     * Stores the skinning transform in the specified Matrix4f.
     * The skinning transform applies the animation of the bone to a vertex.
     * 
     * This assumes that the world transforms for the entire bone hierarchy
     * have already been computed, otherwise this method will return undefined
     * results.
     * 
     * @param outTransform
     */
    public function getOffsetTransform(outTransform:Matrix4f, 
	                                   tmp1:Quaternion, tmp2:Vector3f, tmp3:Vector3f, tmp4:Matrix3f):Void
	{
        // Computing scale
        var scale:Vector3f = worldScale.multiply(worldBindInverseScale, tmp3);

        // Computing rotation
        var rotate:Quaternion = worldRot.multiply(worldBindInverseRot, tmp1);
		

        // Computing translation
        // Translation depend on rotation and scale
		scale.multiply(worldBindInversePos, tmp2);
		rotate.multiplyVector(tmp2, tmp2);
		tmp2.addLocal(worldPos);
        var translate:Vector3f = tmp2;

        // Populating the matrix
        outTransform.loadIdentity();
        outTransform.setTransform(translate, scale, rotate.toRotationMatrix3f(tmp4));
    }

    /**
     * Sets user transform.
     */
    public function setUserTransforms(translation:Vector3f,rotation:Quaternion,scale:Vector3f):Void
	{
        Assert.assert(userControl,"User control must be on bone to allow user transforms");

        localPos.copyFrom(initialPos);
        localRot.copyFrom(initialRot);
        localScale.copyFrom(initialScale);

        localPos.addLocal(translation);
        localRot = localRot.multiply(rotation);
		localScale.multiplyLocal(scale);
    }

    /**
     * Must update all bones in skeleton for this to work.
     * @param translation
     * @param rotation
     */
    public function setUserTransformsWorld(translation:Vector3f,rotation:Quaternion):Void
	{
        Assert.assert(userControl,"User control must be on bone to allow user transforms");

        // TODO: add scale here ???
        worldPos.copyFrom(translation);
        worldRot.copyFrom(rotation);
		
		//if there is an attached Node we need to set it's local transforms too.
        if(attachNode != null){
            attachNode.setLocalTranslation(translation);
            attachNode.setLocalRotation(rotation);
        }
    }

    /**
     * Returns the local transform of this bone combined with the given position and rotation
     * @param position a position
     * @param rotation a rotation
     */
    public function getCombinedTransform(position:Vector3f,rotation:Quaternion):Transform
	{
		var translation:Vector3f = tmpTransform.translation;
		rotation.multiplyVector(localPos, translation);
		translation.addLocal(position);
		
		tmpTransform.rotation.copyFrom(rotation);
		tmpTransform.rotation.multiplyLocal(localRot);
        return tmpTransform;
    }

    /**
     * Returns the attachment node.
     * Attach models and effects to this node to make
     * them follow this bone's motions.
     */
    public function getAttachmentsNode():Node
	{
        if (attachNode == null) 
		{
            attachNode = new Node(name + "_attachnode");
            attachNode.setUserData("AttachedBone", this);
        }
        return attachNode;
    }

    /**
     * Used internally after model cloning.
     * @param attachNode
     */
    public function setAttachmentsNode(attachNode:Node):Void
	{
        this.attachNode = attachNode;
    }

    /**
     * Sets the local animation transform of this bone.
     * Bone is assumed to be in bind pose when this is called.
     */
    public function setAnimTransforms(translation:Vector3f, rotation:Quaternion, scale:Vector3f):Void
	{
        if (userControl) 
		{
            return;
        }

        localPos.copyFrom(initialPos);
		localPos.addLocal(translation);
        localRot.copyFrom(initialRot);
		localRot.multiplyLocal(rotation);

        if (scale != null) 
		{
            localScale.copyFrom(initialScale);
			localScale.multiplyLocal(scale);
        }
    }

    public function blendAnimTransforms(translation:Vector3f, rotation:Quaternion, scale:Vector3f, weight:Float):Void
	{
        if (userControl) 
		{
            return;
        }

        var tmpV:Vector3f = new Vector3f();
        var tmpV2:Vector3f = new Vector3f();
        var tmpQ:Quaternion = new Quaternion();

        //location
        tmpV.copyFrom(initialPos);
		tmpV.addLocal(translation);
		localPos.interpolate(tmpV, weight,localPos);

        //rotation
        tmpQ.copyFrom(initialRot);
		tmpQ.multiplyLocal(rotation);
        localRot.nlerp(tmpQ, weight);

        //scale
        if (scale != null) 
		{
            tmpV2.copyFrom(initialScale);
			localScale.multiplyLocal(scale);
			localScale.interpolate(tmpV2, weight,localScale);
        }
    }

    /**
     * Sets local bind transform for bone.
     * Call setBindingPose() after all of the skeleton bones' bind transforms are set to save them.
     */
    public function setBindTransforms(translation:Vector3f, rotation:Quaternion, scale:Vector3f):Void
	{
        initialPos.copyFrom(translation);
        initialRot.copyFrom(rotation);
        //ogre.xml can have null scale values breaking this if the check is removed
        if (scale != null) 
		{
            initialScale.copyFrom(scale);
        }

        localPos.copyFrom(translation);
        localRot.copyFrom(rotation);
        if (scale != null) 
		{
            localScale.copyFrom(scale);
        }
    }
}