package org.angle3d.scene;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.Vector;
import org.angle3d.bounding.BoundingBox;
import org.angle3d.bounding.BoundingVolume;
import org.angle3d.collision.Collidable;
import org.angle3d.collision.CollisionResults;
import org.angle3d.light.Light;
import org.angle3d.light.LightList;
import org.angle3d.material.Material;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Quaternion;
import org.angle3d.math.Transform;
import org.angle3d.renderer.Camera3D;
import org.angle3d.renderer.queue.QueueBucket;
import org.angle3d.renderer.queue.ShadowMode;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.control.Control;
import org.angle3d.utils.Assert;
import org.angle3d.utils.Cloneable;
import org.angle3d.utils.HashMap;
/**
 * <code>Spatial</code> defines the base class for scene graph nodes. It
 * maintains a link to a parent, it's local transforms and the world's
 * transforms. All other nodes, such as <code>Node</code> and
 * <code>Geometry</code> are subclasses of <code>Spatial</code>.
 * @author andy
 */
class Spatial implements Cloneable implements Collidable
{
	/**
     * Refresh flag types
     */
	public static inline var RF_TRANSFORM:Int = 0x01;
	public static inline var RF_BOUND:Int     = 0x02;
	public static inline var RF_LIGHTLIST:Int = 0x04;
	
	private var cullHint:CullHint;
	
	/** 
     * Spatial's bounding volume relative to the world.
     */
	private var worldBound:BoundingVolume;
	
	
	/**
	 * LightList
	 */
	private var localLights:LightList;
	private var worldLights:LightList;
	
	/** 
     * This spatial's name.
     */
	private var name:String;
	
	// scale values
	private var frustrumIntersects:FrustumIntersect;
	private var queueBucket:QueueBucket;
	private var shadowMode:ShadowMode;
	
	public var queueDistance:Float;
	
	private var localTransform:Transform;
	private var worldTransform:Transform;
	
	private var controls:Vector<Control>;

	/** 
     * Spatial's parent, or null if it has none.
     */
	private var parent:Node;
	
	/**
     * Refresh flags. Indicate what data of the spatial need to be
     * updated to reflect the correct state.
     */
	private var refreshFlags:Int;
	
	
	private var userData:HashMap<String,Dynamic>;
	
	
	/**
     * Constructor instantiates a new <code>Spatial</code> object setting the
     * rotation, translation and scale value to defaults.
     *
     * @param name
     *            the name of the scene element. This is required for
     *            identification and comparision purposes.
     */
	public function new(name:String = "") 
	{
		_init();
		
		this.name = name;
	}
	
	private function _init():Void
	{
		localTransform = new Transform();
		worldTransform = new Transform();
		
		localLights = new LightList(this);
		worldLights = new LightList(this);
		
		worldBound = new BoundingBox();
		
		refreshFlags = 0;
		refreshFlags |= RF_BOUND;
		
		cullHint = CullHint.Inherit;
		frustrumIntersects = FrustumIntersect.Intersects;
		queueBucket = QueueBucket.Inherit;
		shadowMode = ShadowMode.Inherit;
		
		queueDistance = Math.NEGATIVE_INFINITY;
		
		controls = new Vector<Control>();
	}
	
	/**
	 * 是否需要更新LightList
	 * @return
	 */
	public inline function needLightListUpdate():Bool
	{
		return (refreshFlags & RF_LIGHTLIST) != 0;
	}
	
	/**
	 * 是否需要更新坐标
	 * @return
	 */
	public inline function needTransformUpdate():Bool
	{
		return (refreshFlags & RF_TRANSFORM) != 0;
	}
	
	/**
	 * 是否需要更新包围体
	 * @return
	 */
	public inline function needBoundUpdate():Bool
	{
		return (refreshFlags & RF_BOUND) != 0;
	}
	
	/**
     * Indicate that the transform of this spatial has changed and that
     * a refresh is required.
     */
	private function setTransformRefresh():Void
	{
		refreshFlags |= RF_TRANSFORM;
		setBoundRefresh();
	}
	
	private inline function setTransformUpdated():Void
	{
		refreshFlags &= ~RF_TRANSFORM;
	}
	
	private function setLightListRefresh():Void
	{
		refreshFlags |= RF_LIGHTLIST;
	}
	
	private inline function setLightListUpdated():Void
	{
		refreshFlags &= ~RF_LIGHTLIST;
	}
	
	/**
     * Indicate that the bounding of this spatial has changed and that
     * a refresh is required.
     */
	private function setBoundRefresh():Void
	{
		refreshFlags |= RF_BOUND;
		
		// XXX: Replace with a recursive call?
		var p:Spatial = parent;
		while (p != null)
		{
			if (p.needBoundUpdate()) 
			{
                return;
            }
			
			p.refreshFlags |= RF_BOUND;
			p = p.parent;
		}
	}
	
	private inline function setBoundUpdated():Void
	{
		refreshFlags &= ~RF_BOUND;
	}
	
	/**
     * <code>checkCulling</code> checks the spatial with the camera to see if it
     * should be culled.
     * <p>
     * This method is called by the renderer. Usually it should not be called
     * directly.
     *
     * @param cam The camera to check against.
     * @return true if inside or intersecting camera frustum
     * (should be rendered), false if outside.
     */
	public function checkCulling(cam:Camera3D):Bool
	{
		if (refreshFlags != 0) 
		{
			Assert.assert(false,"Scene graph is not properly updated for rendering.\n"
                        + "Make sure scene graph state was not changed after\n"
                        + " rootNode.updateGeometricState() call. \n"
                        + "Problem spatial name: " + getName());
		}
		
		var cm:CullHint = getCullHint();
		
		Assert.assert(cm != CullHint.Inherit, "getCullHint() is not CullHint.Inherit");
		
		if (cm == CullHint.Always)
		{
			setLastFrustumIntersection(FrustumIntersect.Outside);
			return false;
		}
		else if (cm == CullHint.Never)
		{
			setLastFrustumIntersection(FrustumIntersect.Intersects);
			return true;
		}
		
		// check to see if we can cull this node
		frustrumIntersects = (parent != null) ? parent.getLastFrustumIntersection() : 
			FrustumIntersect.Intersects;
		
		if (frustrumIntersects == FrustumIntersect.Intersects)
		{
			if (getQueueBucket() == QueueBucket.Gui)
			{
				return cam.containsGui(getWorldBound());
			}
			else 
			{
				frustrumIntersects = cam.contains(getWorldBound());
			}
		}
		return frustrumIntersects != FrustumIntersect.Outside;
	}
	
	/**
     * Sets the name of this spatial.
     *
     * @param name
     *            The spatial's new name.
     */
	public inline function setName(name:String):Void
	{
		this.name = name;
	}
	
	/**
     * Returns the name of this spatial.
     *
     * @return This spatial's name.
     */
	public inline function getName():String
	{
		return name;
	}
	
	/**
     * Returns the local {@link LightList}, which are the lights
     * that were directly attached to this <code>Spatial</code> through the
     * {@link #addLight(org.angle3d.light.Light) } and 
     * {@link #removeLight(org.angle3d.light.Light) } methods.
     * 
     * @return The local light list
     */
	public inline function getLocalLightList():LightList 
	{
        return localLights;
    }

	/**
     * Returns the world {@link LightList}, containing the lights
     * combined from all this <code>Spatial's</code> parents up to and including
     * this <code>Spatial</code>'s lights.
     * 
     * @return The combined world light list
     */
    public inline function getWorldLightList():LightList 
	{
        return worldLights;
    }
	
	/**
     * <code>getWorldRotation</code> retrieves the absolute rotation of the
     * Spatial.
     *
     * @return the Spatial's world rotation matrix.
     */
	public function getWorldRotation():Quaternion
	{
		checkDoTransformUpdate();
        return worldTransform.rotation;
	}
	
	 /**
     * <code>getWorldTranslation</code> retrieves the absolute translation of
     * the spatial.
     *
     * @return the world's tranlsation vector.
     */
	public function getWorldTranslation():Vector3f
	{
		checkDoTransformUpdate();
        return worldTransform.translation;
	}
	 
	/**
     * <code>getWorldScale</code> retrieves the absolute scale factor of the
     * spatial.
     *
     * @return the world's scale factor.
     */
    public function getWorldScale():Vector3f 
	{
        checkDoTransformUpdate();
        return worldTransform.scale;
    }
	
	 /**
     * <code>getWorldTransform</code> retrieves the world transformation
     * of the spatial.
     *
     * @return the world transform.
     */
    public function getWorldTransform():Transform 
	{
        checkDoTransformUpdate();
        return worldTransform;
    }
	
	/**
     * <code>rotateUpTo</code> is a util function that alters the
     * localrotation to point the Y axis in the direction given by newUp.
     *
     * @param newUp
     *            the up vector to use - assumed to be a unit vector.
     */
	public function rotateUpTo(newUp:Vector3f):Void
	{
		// First figure out the current up vector.
		var upY:Vector3f = new Vector3f(0, 1, 0);
		var rot:Quaternion = localTransform.rotation;
		rot.multVecLocal(upY);
		
		// get angle between vectors
		var angle:Float = upY.angleBetween(newUp);
		
		// figure out rotation axis by taking cross product
		var rotAxis:Vector3f = upY.crossLocal(newUp).normalizeLocal();
		
		// Build a rotation quat and apply current local rotation.
		var q:Quaternion = new Quaternion();
		q.fromAngleNormalAxis(angle, rotAxis);
        q.multiply(rot, rot);
		
		setTransformRefresh();
	}
	
	/**
     * <code>lookAt</code> is a convienence method for auto-setting the local
     * rotation based on a position and an up vector. It computes the rotation
     * to transform the z-axis to point onto 'position' and the y-axis to 'up'.
     * Unlike {@link Quaternion#lookAt} this method takes a world position to
     * look at not a relative direction.
     *
     * @param position
     *            where to look at in terms of world coordinates
     * @param upVector
     *            a vector indicating the (local) up direction. (typically {0,
     *            1, 0} in jME.)
     */
	public function lookAt(position:Vector3f, upVector:Vector3f):Void
	{
		var worldTranslation:Vector3f = getWorldTranslation();
		
		var dir:Vector3f = position.subtract(worldTranslation);
		getLocalRotation().lookAt(dir, upVector);
		
		setTransformRefresh();
	}
	
	/**
     * Should be overriden by Node and Geometry.
     */
	public function updateWorldBound():Void
	{
		// the world bound of a leaf is the same as it's model bound
        // for a node, the world bound is a combination of all it's children
        // bounds
        // -> handled by subclass
        refreshFlags &= ~RF_BOUND;
	}
	
	private function updateWorldLightList():Void
	{
        if (parent == null) 
		{
            worldLights.update(localLights, null);
            setLightListUpdated();
        } 
		else 
		{
            if (!parent.needLightListUpdate()) 
			{
                worldLights.update(localLights, parent.getWorldLightList());
                setLightListUpdated();
            } 
			else 
			{
                Assert.assert(false,"updateWorldLightList");
            }
        }
    }
	
	/**
     * Should only be called from updateGeometricState().
     * In most cases should not be subclassed.
     */
    private function updateWorldTransforms():Void
	{
        if (parent == null) 
		{
            worldTransform.copyFrom(localTransform);
            setTransformUpdated();
        } 
		else 
		{
            // check if transform for parent is updated
            Assert.assert(!parent.needTransformUpdate(), "parent transform sould already updated");
			
            worldTransform.copyFrom(localTransform);
            worldTransform.combineWithParent(parent.getWorldTransform());
            setTransformUpdated();
        }
    }
	
	/**
     * Computes the world transform of this Spatial in the most 
     * efficient manner possible.
     */
    public function checkDoTransformUpdate():Void
	{
        if (!needTransformUpdate()) 
		{
            return;
        }

        if (parent == null) 
		{
            worldTransform.copyFrom(localTransform);
			setTransformUpdated();
        } 
		else 
		{
			//TODO 此处未完全理解
			var stack:Vector<Spatial> = new Vector<Spatial>();
            var rootNode:Spatial = this;
            var i:Int = 0;
            while (true) 
			{
                var hisParent:Spatial = rootNode.parent;
                if (hisParent == null) 
				{
                    rootNode.worldTransform.copyFrom(rootNode.localTransform);
                    rootNode.setTransformUpdated();
                    i--;
                    break;
                }

                stack[i] = rootNode;

                if (!hisParent.needTransformUpdate()) 
				{
                    break;
                }

                rootNode = hisParent;
                i++;
            }

			while (i >= 0)
            {
                rootNode = stack[i];
                //rootNode.worldTransform.set(rootNode.localTransform);
                //rootNode.worldTransform.combineWithParent(rootNode.parent.worldTransform);
                //rootNode.setTransformUpdated();
                rootNode.updateWorldTransforms();
				i--;
            }
        }
    }
	
	/**
     * Computes this Spatial's world bounding volume in the most efficient
     * manner possible.
     */
    public function checkDoBoundUpdate():Void
	{
        if (!needBoundUpdate()) 
		{
            return;
        }

        checkDoTransformUpdate();

        // Go to children recursively and update their bound
        if (Std.is(this, Node)) 
		{
            var node:Node = Lib.as(this, Node);
            var len:Int = node.getNumChildren();
            for (i in 0...len) 
			{
                var child:Spatial = node.getChildAt(i);
                child.checkDoBoundUpdate();
            }
        }

        // All children's bounds have been updated. Update my own now.
        updateWorldBound();
    }
	
	private function runControlUpdate(tpf:Float):Void 
	{
        for (i in 0...controls.length) 
		{
            controls[i].update(tpf);
        }
    }
	
	/**
     * Called when the Spatial is about to be rendered, to notify
     * controls attached to this Spatial using the Control.render() method.
     *
     * @param rm The RenderManager rendering the Spatial.
     * @param vp The ViewPort to which the Spatial is being rendered to.
     *
     * @see Spatial#addControl(org.angle3d.scene.control.Control)
     * @see Spatial#getControl(java.lang.Class) 
     */
    public function runControlRender(rm:RenderManager, vp:ViewPort):Void 
	{
        for (i in 0...controls.length) 
		{
            controls[i].render(rm, vp);
        }
    }
	
	/**
     * Add a control to the list of controls.
     * @param control The control to add.
     *
     * @see Spatial#removeControl() 
     */
	public function addControl(control:Control):Void
	{
		Assert.assert(controls.indexOf(control) == -1, "controls already contain control");
			
		controls.push(control);
		control.setSpatial(this);
	}
	
	/**
     * Removes the given control from this spatial's controls.
     * 
     * @param control The control to remove
     * @return True if the control was successfuly removed. False if 
     * the control is not assigned to this spatial.
     * 
     * @see Spatial#addControl(org.angle3d.scene.control.Control) 
     */
	public function removeControl(control:Control):Bool
	{
		var index:Int = controls.indexOf(control);
		if (index > -1)
		{
			controls.splice(index, 1);
			control.setSpatial(null);
			return true;
		}
		return false;
	}
	
	/**
     * Returns the control at the given index in the list.
     *
     * @param index The index of the control in the list to find.
     * @return The control at the given index.
     *
     * @see Spatial#addControl(org.angle3d.scene.control.Control)
     */
	public inline function getControl(index:Int):Control
	{
		return controls[index];
	}
	
	/**
     * @return The number of controls attached to this Spatial.
     */
	public inline function getNumControls():Int
	{
		return controls.length;
	}
	
	public inline function getRefreshFlags():Int
	{
		return refreshFlags;
	}
	
	/**
     * <code>updateLogicalState</code> calls the <code>update()</code> method
     * for all controls attached to this Spatial.
     *
     * @param tpf Time per frame.
     *
     * @see Spatial#addControl(org.angle3d.scene.control.Control)
     */
	public function updateLogicalState(tpf:Float):Void
	{
		runControlUpdate(tpf);
	}
	
	/**
     * <code>updateGeometricState</code> updates the lightlist,
     * computes the world transforms, and computes the world bounds
     * for this Spatial.
     * Calling this when the Spatial is attached to a node
     * will cause undefined results. User code should only call this
     * method on Spatials having no parent.
     * 
     * @see Spatial#getWorldLightList()
     * @see Spatial#getWorldTransform()
     * @see Spatial#getWorldBound()
     */
	public function updateGeometricState():Void
	{
		// assume that this Spatial is a leaf, a proper implementation
        // for this method should be provided by Node.

        // NOTE: Update world transforms first because
        // bound transform depends on them.
		if (needLightListUpdate()) 
		{
            updateWorldLightList();
        }
		
        if (needTransformUpdate()) 
		{
            updateWorldTransforms();
        }
		
        if (needBoundUpdate()) 
		{
            updateWorldBound();
        }

        Assert.assert(refreshFlags == 0,"Already update all");
	}
	
	/**
     * Convert a vector (in) from this spatials' local coordinate space to world
     * coordinate space.
     *
     * @param in
     *            vector to read from
     * @param store
     *            where to write the result (null to create a new vector, may be
     *            same as in)
     * @return the result (store)
     */
	public function localToWorld(inVec:Vector3f, result:Vector3f = null):Vector3f
	{
		checkDoTransformUpdate();
        return worldTransform.transformVector(inVec, result);
	}
	
	/**
     * Convert a vector (in) from world coordinate space to this spatials' local
     * coordinate space.
     *
     * @param in
     *            vector to read from
     * @param store
     *            where to write the result
     * @return the result (store)
     */
	public function worldToLocal(inVec:Vector3f, result:Vector3f = null):Vector3f
	{
		checkDoTransformUpdate();
        return worldTransform.transformInverseVector(inVec, result);
	}
	
	/**
     * <code>getParent</code> retrieve's this node's parent. If the parent is
     * null this is the root node.
     *
     * @return the parent of this node.
     */
	public inline function getParent():Node
	{
		return parent;
	}
	
	/**
     * Called by {@link Node#attachChild(Spatial)} and
     * {@link Node#detachChild(Spatial)} - don't call directly.
     * <code>setParent</code> sets the parent of this node.
     *
     * @param parent
     *            the parent of this node.
     */
	public inline function setParent(parent:Node):Void
	{
		this.parent = parent;
	}
	
	/**
     * <code>removeFromParent</code> removes this Spatial from it's parent.
     *
     * @return true if it has a parent and performed the remove.
     */
	public function removeFromParent():Bool
	{
		if (parent != null) 
		{
            parent.detachChild(this);
            return true;
        }
        return false;
	}
	
	/**
     * determines if the provided Node is the parent, or parent's parent, etc. of this Spatial.
     *
     * @param ancestor
     *            the ancestor object to look for.
     * @return true if the ancestor is found, false otherwise.
     */
	public function hasAncestor(ancestor:Node):Bool
	{
		if (parent == null) 
		{
            return false;
        }
		else if (parent == ancestor) 
		{
            return true;
        } 
		else 
		{
            return parent.hasAncestor(ancestor);
        }
	}
	
	/**
     * <code>getLocalRotation</code> retrieves the local rotation of this
     * node.
     *
     * @return the local rotation of this node.
     */
	public inline function getLocalRotation():Quaternion
	{
		return localTransform.rotation;
	}
	
	/**
     * <code>setLocalRotation</code> sets the local rotation of this node.
     *
     * @param rotation
     *            the new local rotation.
     */
	public inline function setLocalRotationByMatrix3f(rotation:Matrix3f):Void
	{
		localTransform.rotation.fromRotationMatrix(rotation);
        setTransformRefresh();
	}
	
	
	/**
     * <code>setLocalRotation</code> sets the local rotation of this node,
     * using a quaterion to build the matrix.
     *
     * @param quaternion
     *            the quaternion that defines the matrix.
     */
	public inline function setLocalRotation(quat:Quaternion):Void
	{
		localTransform.setRotation(quat);
        setTransformRefresh();
	}
	
	/**
     * <code>getLocalScale</code> retrieves the local scale of this node.
     *
     * @return the local scale of this node.
     */
	public inline function getLocalScale():Vector3f
	{
		return localTransform.scale;
	}
	
	/**
     * <code>setLocalScale</code> sets the local scale of this node.
     *
     * @param localScale
     *            the new local scale, applied to x, y and z
     */
	public function setLocalScale(localScale:Vector3f):Void
	{
		localTransform.setScale(localScale);
        setTransformRefresh();
	}
	
	public function setLocalScaleTo(x:Float,y:Float,z:Float):Void
	{
		localTransform.setScaleTo(x,y,z);
        setTransformRefresh();
	}
	
	/**
     * <code>getLocalTranslation</code> retrieves the local translation of
     * this node.
     *
     * @return the local translation of this node.
     */
	public inline function getLocalTranslation():Vector3f
	{
		return localTransform.translation;
	}
	
	/**
     * <code>setLocalTranslation</code> sets the local translation of this
     * spatial.
     *
     * @param localTranslation
     *            the local translation of this spatial.
     */
	public function setLocalTranslation(localTranslation:Vector3f):Void
	{
		localTransform.setTranslation(localTranslation);
        setTransformRefresh();
	}
	
	public function setLocalTranslationTo(x:Float,y:Float,z:Float):Void
	{
		localTransform.setTranslationTo(x,y,z);
        setTransformRefresh();
	}
	
	/**
     * <code>setLocalTransform</code> sets the local transform of this
     * spatial.
     */
	public inline function setLocalTransform(t:Transform):Void
	{
		localTransform.copyFrom(t);
        setTransformRefresh();
	}
	
	/**
     * <code>getLocalTransform</code> retrieves the local transform of
     * this spatial.
     *
     * @return the local transform of this spatial.
     */
	public inline function getLocalTransform():Transform
	{
		return localTransform;
	}
	
	/**
     * Applies the given material to the Spatial, this will propagate the
     * material down to the geometries in the scene graph.
     *
     * @param material The material to set.
     */
	public function setMaterial(material:Material):Void
	{
		
	}
	
	/**
     * <code>addLight</code> adds the given light to the Spatial; causing
     * all child Spatials to be effected by it.
     *
     * @param light The light to add.
     */
	public function addLight(light:Light):Void
	{
		localLights.addLight(light);
        setLightListRefresh();
	}
	
	/**
     * <code>removeLight</code> removes the given light from the Spatial.
     * 
     * @param light The light to remove.
     * @see Spatial#addLight(org.angle3d.light.Light) 
     */
	public function removeLight(light:Light):Void
	{
		localLights.removeLight(light);
        setLightListRefresh();
	}
	
	/**
     * Translates the spatial by the given translation vector.
     *
     * @return The spatial on which this method is called, e.g <code>this</code>.
     */
	public function move(offset:Vector3f):Void
	{
		localTransform.translation.addLocal(offset);
        setTransformRefresh();
	}
	
	/**
     * Scales the spatial by the given value
     *
     * @return The spatial on which this method is called, e.g <code>this</code>.
     */
	public function scale(sc:Vector3f):Void
	{
		localTransform.scale.multiplyLocal(sc);
        setTransformRefresh();
	}
	
	/**
     * Rotates the spatial by the given rotation.
     *
     * @return The spatial on which this method is called, e.g <code>this</code>.
     */
	public function rotate(rot:Quaternion):Void
	{
		localTransform.rotation.multiplyLocal(rot);
        setTransformRefresh();
	}
	
	/**
     * Rotates the spatial by the yaw, roll and pitch angles (in radians),
     * in the local coordinate space.
     *
     * @return The spatial on which this method is called, e.g <code>this</code>.
     */
	public function rotateYRP(yaw:Float, roll:Float, pitch:Float):Void
	{
		var q:Quaternion = new Quaternion();
		q.fromAngles(yaw, roll, pitch);
		rotate(q);
	}
	
	/**
     * Centers the spatial in the origin of the world bound.
     * @return The spatial on which this method is called, e.g <code>this</code>.
     */
	public function center():Spatial
	{
		var worldTrans:Vector3f = getWorldTranslation();
        var worldCenter:Vector3f = getWorldBound().getCenter();

        var absTrans:Vector3f = worldTrans.subtract(worldCenter);
        setLocalTranslation(absTrans);
		
		return this;
	}
	
	/**
     * Returns this spatial's renderqueue bucket. If the mode is set to inherit,
     * then the spatial gets its renderqueue bucket from its parent.
     *
     * @return The spatial's current renderqueue mode.
     */
	public function getQueueBucket():QueueBucket
	{
		if (queueBucket != QueueBucket.Inherit) 
		{
            return queueBucket;
        } 
		else if (parent != null) 
		{
            return parent.getQueueBucket();
        } 
		else 
		{
            return QueueBucket.Opaque;
        }
	}
	
	/**
     * @return The shadow mode of this spatial, if the local shadow
     * mode is set to inherit, then the parent's shadow mode is returned.
     *
     * @see Spatial#setShadowMode(org.angle3d.renderer.queue.RenderQueue.ShadowMode)
     * @see ShadowMode
     */
	public function getShadowMode():ShadowMode
	{
		if (shadowMode != ShadowMode.Inherit) 
		{
            return shadowMode;
        } 
		else if (parent != null) 
		{
            return parent.getShadowMode();
        } 
		else 
		{
            return ShadowMode.Off;
        }
	}
	
	/**
     * Sets the level of detail to use when rendering this Spatial,
     * this call propagates to all geometries under this Spatial.
     *
     * @param lod The lod level to set.
     */
	public function setLodLevel(lod:Int):Void
	{
		
	}
	
	/**
     * <code>updateModelBound</code> recalculates the bounding object for this
     * Spatial.
     */
	public function updateModelBound():Void
	{
		
	}
	
	/**
     * <code>setModelBound</code> sets the bounding object for this Spatial.
     *
     * @param modelBound
     *            the bounding object for this spatial.
     */
	public function setModelBound(modelBound:BoundingVolume):Void
	{
		
	}
	
	/**
     * @return The sum of all verticies under this Spatial.
     */
	public function getVertexCount():Int
	{
		return 0;
	}
	
	/**
     * @return The sum of all triangles under this Spatial.
     */
	public function getTriangleCount():Int
	{
		return 0;
	}
	
	/**
     * @return A clone of this Spatial, the scene graph in its entirety
     * is cloned and can be altered independently of the original scene graph.
     *
     * Note that meshes of geometries are not cloned explicitly, they
     * are shared if static, or specially cloned if animated.
     *
     * All controls will be cloned using the Control.cloneForSpatial method
     * on the clone.
     *
     * @see Mesh#cloneForAnim() 
     */
	public function clone(cloneMaterial:Bool = true, result:Spatial = null):Spatial
	{
		if (result == null)
		{
			result = new Spatial();
		}
		
		if (worldBound != null)
		{
			result.worldBound = worldBound.clone();
		}
		
		result.worldLights = worldLights.clone();
		result.localLights = localLights.clone();
		
		// Set the new owner of the light lists
		result.localLights.setOwner(result);
		result.worldLights.setOwner(result);
		
		// No need to force cloned to update.
        // This node already has the refresh flags
        // set below so it will have to update anyway.
		result.worldTransform.copyFrom(worldTransform);
		result.localTransform.copyFrom(localTransform);
		
		result.parent = null;
		result.setBoundRefresh();
		result.setTransformRefresh();
		result.setLightListRefresh();
		
        for (i in 0...controls.length) 
		{
			result.controls.push(controls[i].cloneForSpatial(result));
		}

		return result;
	}
	
	public function getWorldBound():BoundingVolume
	{
		checkDoBoundUpdate();
        return worldBound;
	}

	/**
     * <code>setCullHint</code> sets how scene culling should work on this
     * spatial during drawing. NOTE: You must set this AFTER attaching to a 
     * parent or it will be reset with the parent's cullMode value.
     *
     * @param hint
     *            one of CullHint.Dynamic, CullHint.Always, CullHint.Inherit or
     *            CullHint.Never
     */
	public function setCullHint(hint:CullHint):Void
	{
		cullHint = hint;
	}
	
	/**
     * @return the cullmode set on this Spatial
     */
	public function getLocalCullHint():CullHint
	{
		return cullHint;
	}
	
	/**
     * @see #setCullHint(CullHint)
     * @return the cull mode of this spatial, or if set to CullHint.Inherit,
     * the cullmode of it's parent.
     */
	public function getCullHint():CullHint
	{
		if (cullHint != CullHint.Inherit) 
		{
            return cullHint;
        } 
		else if (parent != null) 
		{
            return parent.getCullHint();
        } 
		else 
		{
            return CullHint.Auto;
        }
	}
	
	/**
     * <code>setQueueBucket</code> determines at what phase of the
     * rendering process this Spatial will rendered. See the
     * {@link Bucket} enum for an explanation of the various 
     * render queue buckets.
     * 
     * @param queueBucket
     *            The bucket to use for this Spatial.
     */
	public function setQueueBucket(queueBucket:QueueBucket):Void
	{
		this.queueBucket = queueBucket;
	}
	
	/**
     * Sets the shadow mode of the spatial
     * The shadow mode determines how the spatial should be shadowed,
     * when a shadowing technique is used. See the
     * documentation for the class ShadowMode for more information.
     *
     * @see ShadowMode
     *
     * @param shadowMode The local shadow mode to set.
     */
	public function setShadowMode(shadowMode:ShadowMode):Void
	{
		this.shadowMode = shadowMode;
	}
	
	/**
     * @return The locally set queue bucket mode
     *
     * @see Spatial#setQueueBucket(org.angle3d.renderer.queue.RenderQueue.Bucket)
     */
	public function getLocalQueueBucket():QueueBucket
	{
		return queueBucket;
	}
	
	/**
     * @return The locally set shadow mode
     *
     * @see Spatial#setShadowMode(org.angle3d.renderer.queue.RenderQueue.ShadowMode)
     */
	public function getLocalShadowMode():ShadowMode
	{
		return shadowMode;
	}
	
	/**
     * Returns this spatial's last frustum intersection result. This int is set
     * when a check is made to determine if the bounds of the object fall inside
     * a camera's frustum. If a parent is found to fall outside the frustum, the
     * value for this spatial will not be updated.
     *
     * @return The spatial's last frustum intersection result.
     */
	public function getLastFrustumIntersection():FrustumIntersect
	{
		return frustrumIntersects;
	}
	
	/**
     * Overrides the last intersection result. This is useful for operations
     * that want to start rendering at the middle of a scene tree and don't want
     * the parent of that node to influence culling. (See texture renderer code
     * for example.)
     *
     * @param intersects
     *            the new value
     */
	public function setLastFrustumIntersection(intersects:FrustumIntersect):Void
	{
		 frustrumIntersects = intersects;
	}
	
	public function toString():String
	{
		return name + "(" + Type.getClassName(Type.getClass(this)) + ")";
	}
	
	/**
     * Creates a transform matrix that will convert from this spatials'
     * local coordinate space to the world coordinate space
     * based on the world transform.
     *
     * @param store Matrix where to store the result, if null, a new one
     * will be created and returned.
     *
     * @return store if not null, otherwise, a new matrix containing the result.
     *
     * @see Spatial#getWorldTransform() 
     */
	public function getLocalToWorldMatrix(?result:Matrix4f = null):Matrix4f
	{
		if (result == null) 
		{
            result = new Matrix4f();
        } 
		else 
		{
            result.loadIdentity();
        }
		
        // multiply with scale first, then rotate, finally translate
        result.scaleByVec(getWorldScale());
        result.multLocalQuat(getWorldRotation());
        result.setTranslation(getWorldTranslation());
        return result;
	}
	
	public function setUserData(key:String,data:Dynamic):Void
	{
        if (userData == null) 
		{
            userData = new HashMap<String, Dynamic>();
        }
        userData.setValue(key,data);
    }

    public function getUserData(key:String):Dynamic 
	{
        if (userData == null) 
		{
            return null;
        }

        return userData.getValue(key);
    }
	
	/**
     * Visit each scene graph element ordered by DFS
     * @param visitor
     */
	public function depthFirstTraversal(visitor:SceneGraphVisitor):Void
	{
		
	}
	
	/**
     * Visit each scene graph element ordered by BFS
     * @param visitor
     */
	//public function breadthFirstTraversal(visitor:SceneGraphVisitor):Void
	//{
		//var queue:LinkedQueue<Spatial> = new LinkedQueue<Spatial>();
		//queue.enqueue(this);
//
        //while (!queue.isEmpty()) 
		//{
            //var s:Spatial = queue.dequeue();
            //visitor.visit(s);
            //s.breadthFirstTraversalQueue(visitor, queue);
        //}
	//}
	//
	//private function breadthFirstTraversalQueue(visitor:SceneGraphVisitor,queue:Queue<Spatial>):Void
	//{
		//
	//}
	
	public function collideWith(other:Collidable, results:CollisionResults):Int
	{
		return -1;
	}
}