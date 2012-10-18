package org.angle3d.scene
{
	import flash.utils.getQualifiedClassName;
	
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
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.renderer.queue.QueueBucket;
	import org.angle3d.renderer.queue.ShadowMode;
	import org.angle3d.scene.control.Control;
	import org.angle3d.utils.Assert;
	import org.angle3d.utils.Cloneable;
	import org.angle3d.utils.TempVars;

	//TODO 还需要添加更多常用属性
	//例如：是否可拾取，是否显示鼠标
	/**
	 * Spatial defines the base public class for scene graph nodes. It
	 * maintains a link to a parent, it's local transforms and the world's
	 * transforms. All other nodes, such as Node and
	 * Geometry are subpublic classes of Spatial.
	 * @author andy
	 */
	public class Spatial implements Cloneable, Collidable
	{
		/**
		 * Refresh flag types
		 */
		public static const RF_TRANSFORM : uint = 0x01;
		public static const RF_BOUND : uint = 0x02;
		public static const RF_LIGHTLIST : uint = 0x04;

		/**
		 * This spatial's name.
		 */
		public var name : String;

		public var queueDistance : Number;

		protected var _cullHint : int;

		/**
		 * Spatial's bounding volume relative to the world.
		 */
		protected var _worldBound : BoundingVolume;


		/**
		 * LightList
		 */
		protected var _localLights : LightList;
		protected var _worldLights : LightList;

		// scale values
		protected var _frustrumIntersects : int;
		protected var _queueBucket : int;
		protected var _shadowMode : int;


		protected var _localTransform : Transform;
		protected var _worldTransform : Transform;

		protected var _controls : Vector.<Control>;

		/**
		 * Spatial's parent, or null if it has none.
		 */
		private var _parent : Node;

		/**
		 * Refresh flags. Indicate what data of the spatial need to be
		 * updated to reflect the correct state.
		 */
		protected var _refreshFlags : uint;
		
		protected var _visible:Boolean;


		/**
		 * Constructor instantiates a new <code>Spatial</code> object setting the
		 * rotation, translation and scale value to defaults.
		 *
		 * @param name
		 *            the name of the scene element. This is required for
		 *            identification and comparision purposes.
		 */
		public function Spatial(name : String = "")
		{
			this.name = name;
			_init();
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		/**
		 * 是否真正可见
		 * 自身可能是可见的，但是parent是不可见，所以还是不可见的
		 */
		public function get truelyVisible():Boolean
		{
			if(_parent == null)
				return _visible;
			
			return _visible && _parent.visible;
		}

		protected function _init() : void
		{
			_localTransform = new Transform();
			_worldTransform = new Transform();

			_localLights = new LightList(this);
			_worldLights = new LightList(this);

			_worldBound = new BoundingBox();

			_refreshFlags = 0;
			_refreshFlags |= RF_BOUND;

			_cullHint = CullHint.Inherit;
			_frustrumIntersects = FrustumIntersect.Intersects;
			_queueBucket = QueueBucket.Inherit;
			_shadowMode = ShadowMode.Inherit;
			
			_visible = true;

			queueDistance = Number.NEGATIVE_INFINITY;

			_controls = new Vector.<Control>();
		}

		/**
		 * 是否需要更新LightList
		 * @return
		 */
		public function needLightListUpdate() : Boolean
		{
			return (_refreshFlags & RF_LIGHTLIST) != 0;
		}

		/**
		 * 是否需要更新坐标
		 * @return
		 */
		public function needTransformUpdate() : Boolean
		{
			return (_refreshFlags & RF_TRANSFORM) != 0;
		}

		/**
		 * 是否需要更新包围体
		 * @return
		 */
		public function needBoundUpdate() : Boolean
		{
			return (_refreshFlags & RF_BOUND) != 0;
		}

		/**
		 * Indicate that the transform of this spatial has changed and that
		 * a refresh is required.
		 */
		public function setTransformRefresh() : void
		{
			_refreshFlags |= RF_TRANSFORM;
			setBoundRefresh();
		}

		public function setTransformUpdated() : void
		{
			_refreshFlags &= ~RF_TRANSFORM;
		}

		public function setLightListRefresh() : void
		{
			_refreshFlags |= RF_LIGHTLIST;
		}

		public function setLightListUpdated() : void
		{
			_refreshFlags &= ~RF_LIGHTLIST;
		}

		/**
		 * Indicate that the bounding of this spatial has changed and that
		 * a refresh is required.
		 */
		public function setBoundRefresh() : void
		{
			_refreshFlags |= RF_BOUND;

			// XXX: Replace with a recursive call?
			var p : Spatial = parent;
			while (p != null)
			{
				if (p.needBoundUpdate())
				{
					return;
				}

				p._refreshFlags |= RF_BOUND;
				p = p.parent;
			}
		}

		public function setBoundUpdated() : void
		{
			_refreshFlags &= ~RF_BOUND;
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
		public function checkCulling(cam : Camera3D) : Boolean
		{
			CF::DEBUG
			{
				Assert.assert(_refreshFlags == 0, "Scene graph is not properly updated for rendering.\n"
					+ "Make sure scene graph state was not changed after\n"
					+ " rootNode.updateGeometricState() call. \n"
					+ "Problem spatial name: " + name);
			}

			var cm : int = cullHint;

			CF::DEBUG
			{
				Assert.assert(cm != CullHint.Inherit, "getCullHint() is not CullHint.Inherit");
			}

			if (cm == CullHint.Always)
			{
				lastFrustumIntersection = FrustumIntersect.Outside;
				return false;
			}
			else if (cm == CullHint.Never)
			{
				lastFrustumIntersection = FrustumIntersect.Intersects;
				return true;
			}

			// check to see if we can cull this node
			_frustrumIntersects = (parent != null) ? parent.lastFrustumIntersection : FrustumIntersect.Intersects;

			if (_frustrumIntersects == FrustumIntersect.Intersects)
			{
				if (queueBucket == QueueBucket.Gui)
				{
					return cam.containsGui(worldBound);
				}
				else
				{
					_frustrumIntersects = cam.contains(worldBound);
				}
			}
			return _frustrumIntersects != FrustumIntersect.Outside;
		}

		/**
		 * Returns the local {@link LightList}, which are the lights
		 * that were directly attached to this <code>Spatial</code> through the
		 * {@link #addLight(org.angle3d.light.Light) } and
		 * {@link #removeLight(org.angle3d.light.Light) } methods.
		 *
		 * @return The local light list
		 */
		public function getLocalLightList() : LightList
		{
			return _localLights;
		}

		/**
		 * Returns the world {@link LightList}, containing the lights
		 * combined from all this <code>Spatial's</code> parents up to and including
		 * this <code>Spatial</code>'s lights.
		 *
		 * @return The combined world light list
		 */
		public function getWorldLightList() : LightList
		{
			return _worldLights;
		}

		/**
		 * <code>getWorldRotation</code> retrieves the absolute rotation of the
		 * Spatial.
		 *
		 * @return the Spatial's world rotation matrix.
		 */
		public function getWorldRotation() : Quaternion
		{
			checkDoTransformUpdate();
			return _worldTransform.rotation;
		}

		/**
		* <code>getWorldTranslation</code> retrieves the absolute translation of
		* the spatial.
		*
		* @return the world's tranlsation vector.
		*/
		public function getWorldTranslation() : Vector3f
		{
			checkDoTransformUpdate();
			return _worldTransform.translation;
		}

		/**
		 * <code>getWorldScale</code> retrieves the absolute scale factor of the
		 * spatial.
		 *
		 * @return the world's scale factor.
		 */
		public function getWorldScale() : Vector3f
		{
			checkDoTransformUpdate();
			return _worldTransform.scale;
		}

		/**
		* <code>getWorldTransform</code> retrieves the world transformation
		* of the spatial.
		*
		* @return the world transform.
		*/
		public function getWorldTransform() : Transform
		{
			checkDoTransformUpdate();
			return _worldTransform;
		}

		/**
		 * <code>rotateUpTo</code> is a util function that alters the
		 * localrotation to point the Y axis in the direction given by newUp.
		 *
		 * @param newUp
		 *            the up vector to use - assumed to be a unit vector.
		 */
		public function rotateUpTo(newUp : Vector3f) : void
		{
			// First figure out the current up vector.
			var upY : Vector3f = new Vector3f(0, 1, 0);
			var rot : Quaternion = _localTransform.rotation;
			rot.multVecLocal(upY);

			// get angle between vectors
			var angle : Number = upY.angleBetween(newUp);

			// figure out rotation axis by taking cross product
			upY.crossLocal(newUp);
			var rotAxis : Vector3f = upY;
			rotAxis.normalizeLocal();

			// Build a rotation quat and apply current local rotation.
			var q : Quaternion = new Quaternion();
			q.fromAngleAxis(angle, rotAxis);
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
		public function lookAt(position : Vector3f, upVector : Vector3f) : void
		{
			var worldTranslation : Vector3f = getWorldTranslation();

			var dir : Vector3f = position.subtract(worldTranslation);
			getRotation().lookAt(dir, upVector);

			setTransformRefresh();
		}

		/**
		 * Should be overriden by Node and Geometry.
		 */
		public function updateWorldBound() : void
		{
			// the world bound of a leaf is the same as it's model bound
			// for a node, the world bound is a combination of all it's children
			// bounds
			// -> handled by subpublic class
			_refreshFlags &= ~RF_BOUND;
		}

		protected function updateWorldLightList() : void
		{
			if (parent == null)
			{
				_worldLights.update(_localLights, null);
				setLightListUpdated();
			}
			else
			{
				if (!parent.needLightListUpdate())
				{
					_worldLights.update(_localLights, parent.getWorldLightList());
					setLightListUpdated();
				}
				else
				{
					Assert.assert(false, "updateWorldLightList");
				}
			}
		}

		/**
		 * Should only be called from updateGeometricState().
		 * In most cases should not be subpublic classed.
		 */
		protected function updateWorldTransforms() : void
		{
			if (parent == null)
			{
				_worldTransform.copyFrom(_localTransform);
				setTransformUpdated();
			}
			else
			{
				// check if transform for parent is updated
				Assert.assert(!parent.needTransformUpdate(), "parent transform sould already updated");

				_worldTransform.copyFrom(_localTransform);
				_worldTransform.combineWithParent(parent.getWorldTransform());
				setTransformUpdated();
			}
		}

		/**
		 * Computes the world transform of this Spatial in the most
		 * efficient manner possible.
		 */
		public function checkDoTransformUpdate() : void
		{
			if (!needTransformUpdate())
			{
				return;
			}

			if (parent == null)
			{
				_worldTransform.copyFrom(_localTransform);
				setTransformUpdated();
			}
			else
			{
				//TODO 此处未完全理解
				var stack : Vector.<Spatial> = new Vector.<Spatial>();
				var rootNode : Spatial = this;
				var i : int = 0;
				while (true)
				{
					var hisParent : Spatial = rootNode.parent;
					if (hisParent == null)
					{
						rootNode._worldTransform.copyFrom(rootNode._localTransform);
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
		public function checkDoBoundUpdate() : void
		{
			if (!needBoundUpdate())
			{
				return;
			}

			checkDoTransformUpdate();

			// Go to children recursively and update their bound
			if (this is Node)
			{
				var node : Node = this as Node;
				var length : int = node.numChildren;
				for (var i : int = 0; i < length; i++)
				{
					var child : Spatial = node.getChildAt(i);
					child.checkDoBoundUpdate();
				}
			}

			// All children's bounds have been updated. Update my own now.
			updateWorldBound();
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
		public function runControlRender(rm : RenderManager, vp : ViewPort) : void
		{
			var length : int = _controls.length;
			for (var i : int = 0; i < length; i++)
			{
				_controls[i].render(rm, vp);
			}
		}

		/**
		 * Add a control to the list of controls.
		 * @param control The control to add.
		 *
		 * @see Spatial#removeControl()
		 */
		public function addControl(control : Control) : void
		{
			CF::DEBUG
			{
				Assert.assert(_controls.indexOf(control) == -1, "controls already contain control");
			}

			_controls.push(control);
			control.spatial = this;
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
		public function removeControl(control : Control) : Boolean
		{
			var index : int = _controls.indexOf(control);
			if (index > -1)
			{
				_controls.splice(index, 1);
				control.spatial = null;
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
		public function getControl(index : int) : Control
		{
			return _controls[index];
		}
		
		public function getControlByClass(cls:Class) : Control
		{
			var length : int = _controls.length;
			for (var i : int = 0; i < length; i++)
			{
				if(_controls[i] is cls)
				{
					return _controls[i];
				}
			}
			return null;
		}

		/**
		 * @return The number of controls attached to this Spatial.
		 */
		public function get numControls() : uint
		{
			return _controls.length;
		}

		public function get refreshFlags() : uint
		{
			return _refreshFlags;
		}
		
		public function update(tpf:Number):void
		{
			updateControls(tpf);
			updateGeometricState();
		}

		/**
		 * calls the <code>update()</code> method
		 * for all controls attached to this Spatial.
		 *
		 * @param tpf 每帧运行时间，以秒为单位
		 *
		 * @see Spatial#addControl(org.angle3d.scene.control.Control)
		 */
		public function updateControls(tpf : Number) : void
		{
			var length : int = _controls.length;
			for (var i : int = 0; i < length; i++)
			{
				_controls[i].update(tpf);
			}
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
		public function updateGeometricState() : void
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

			CF::DEBUG
			{
				Assert.assert(_refreshFlags == 0, "Already update all");
			}
		}

		/**
		 * Convert a vector (in) from this spatials' local coordinate space to world
		 * coordinate space.
		 *
		 * @param in
		 *            vector to read from
		 * @param store
		 *            where to write the result (null to create a new vector)
		 * @return the result (store)
		 */
		public function localToWorld(inVec : Vector3f, result : Vector3f = null) : Vector3f
		{
			checkDoTransformUpdate();
			return _worldTransform.transformVector(inVec, result);
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
		public function worldToLocal(inVec : Vector3f, result : Vector3f = null) : Vector3f
		{
			checkDoTransformUpdate();
			return _worldTransform.transformInverseVector(inVec, result);
		}

		/**
		 * <code>getParent</code> retrieve's this node's parent. If the parent is
		 * null this is the root node.
		 *
		 * @return the parent of this node.
		 */
		public function get parent() : Node
		{
			return _parent;
		}

		/**
		 * Called by {@link Node#attachChild(Spatial)} and
		 * {@link Node#detachChild(Spatial)} - don't call directly.
		 * <code>setParent</code> sets the parent of this node.
		 *
		 * @param parent
		 *            the parent of this node.
		 */
		public function set parent(parent : Node) : void
		{
			_parent = parent;
		}

		/**
		 * <code>removeFromParent</code> removes this Spatial from it's parent.
		 *
		 * @return true if it has a parent and performed the remove.
		 */
		public function removeFromParent() : Boolean
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
		public function hasAncestor(ancestor : Node) : Boolean
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
		public function getRotation() : Quaternion
		{
			return _localTransform.rotation;
		}

		/**
		 * <code>setLocalRotation</code> sets the local rotation of this node.
		 *
		 * @param rotation
		 *            the new local rotation.
		 */
		public function setRotationByMatrix3f(rotation : Matrix3f) : void
		{
			_localTransform.rotation.fromMatrix3f(rotation);
			setTransformRefresh();
		}


		/**
		 * <code>setLocalRotation</code> sets the local rotation of this node,
		 * using a quaterion to build the matrix.
		 *
		 * @param quaternion
		 *            the quaternion that defines the matrix.
		 */
		public function setRotation(quat : Quaternion) : void
		{
			_localTransform.setRotation(quat);
			setTransformRefresh();
		}

		/**
		 * <code>getLocalScale</code> retrieves the local scale of this node.
		 *
		 * @return the local scale of this node.
		 */
		public function getScale() : Vector3f
		{
			return _localTransform.scale;
		}

		/**
		 * <code>setLocalScale</code> sets the local scale of this node.
		 *
		 * @param localScale
		 *            the new local scale, applied to x, y and z
		 */
		public function setScale(localScale : Vector3f) : void
		{
			_localTransform.setScale(localScale);
			setTransformRefresh();
		}

		public function setScaleXYZ(x : Number, y : Number, z : Number) : void
		{
			_localTransform.setScaleXYZ(x, y, z);
			setTransformRefresh();
		}

		public function set scaleX(value : Number) : void
		{
			_localTransform.scale.x = value;
			setTransformRefresh();
		}

		public function set scaleY(value : Number) : void
		{
			_localTransform.scale.y = value;
			setTransformRefresh();
		}

		public function set scaleZ(value : Number) : void
		{
			_localTransform.scale.z = value;
			setTransformRefresh();
		}

		public function get scaleX() : Number
		{
			return _localTransform.scale.x;
		}

		public function get scaleY() : Number
		{
			return _localTransform.scale.y;
		}

		public function get scaleZ() : Number
		{
			return _localTransform.scale.z;
		}

		/**
		 * <code>getLocalTranslation</code> retrieves the local translation of
		 * this node.
		 *
		 * @return the local translation of this node.
		 */
		public function getTranslation() : Vector3f
		{
			return _localTransform.translation;
		}

		/**
		 * <code>setLocalTranslation</code> sets the local translation of this
		 * spatial.
		 *
		 * @param localTranslation
		 *            the local translation of this spatial.
		 */
		public function setTranslation(localTranslation : Vector3f) : void
		{
			_localTransform.setTranslation(localTranslation);
			setTransformRefresh();
		}

		public function setTranslationXYZ(x : Number, y : Number, z : Number) : void
		{
			_localTransform.setTranslationXYZ(x, y, z);
			setTransformRefresh();
		}

		public function set x(value : Number) : void
		{
			_localTransform.translation.x = value;
			setTransformRefresh();
		}

		public function set y(value : Number) : void
		{
			_localTransform.translation.y = value;
			setTransformRefresh();
		}

		public function set z(value : Number) : void
		{
			_localTransform.translation.z = value;
			setTransformRefresh();
		}

		public function get x() : Number
		{
			return _localTransform.translation.x;
		}

		public function get y() : Number
		{
			return _localTransform.translation.y;
		}

		public function get z() : Number
		{
			return _localTransform.translation.z;
		}

		/**
		 * <code>setLocalTransform</code> sets the local transform of this
		 * spatial.
		 */
		public function setTransform(t : Transform) : void
		{
			_localTransform.copyFrom(t);
			setTransformRefresh();
		}

		/**
		 * <code>getLocalTransform</code> retrieves the local transform of
		 * this spatial.
		 *
		 * @return the local transform of this spatial.
		 */
		public function getTransform() : Transform
		{
			return _localTransform;
		}

		/**
		 * Applies the given material to the Spatial, this will propagate the
		 * material down to the geometries in the scene graph.
		 *
		 * @param material The material to set.
		 */
		public function setMaterial(material : Material) : void
		{

		}

		/**
		 * <code>addLight</code> adds the given light to the Spatial; causing
		 * all child Spatials to be effected by it.
		 *
		 * @param light The light to add.
		 */
		public function addLight(light : Light) : void
		{
			_localLights.addLight(light);
			setLightListRefresh();
		}

		/**
		 * <code>removeLight</code> removes the given light from the Spatial.
		 *
		 * @param light The light to remove.
		 * @see Spatial#addLight(org.angle3d.light.Light)
		 */
		public function removeLight(light : Light) : void
		{
			_localLights.removeLight(light);
			setLightListRefresh();
		}

		/**
		 * Translates the spatial by the given translation vector.
		 *
		 * @return The spatial on which this method is called, e.g <code>this</code>.
		 */
		public function move(offset : Vector3f) : void
		{
			_localTransform.translation.addLocal(offset);
			setTransformRefresh();
		}

		/**
		 * Scales the spatial by the given value
		 *
		 * @return The spatial on which this method is called, e.g <code>this</code>.
		 */
		public function scale(sc : Vector3f) : void
		{
			_localTransform.scale.multiplyLocal(sc);
			setTransformRefresh();
		}

		/**
		 * Rotates the spatial by the given rotation.
		 *
		 * @return The spatial on which this method is called, e.g <code>this</code>.
		 */
		public function rotate(rot : Quaternion) : void
		{
			_localTransform.rotation.multiplyLocal(rot);
			setTransformRefresh();
		}

		/**
		 * Rotates the spatial by the xAngle, yAngle and zAngle angles (in radians),
		 * (aka pitch, yaw, roll) in the local coordinate space.
		 *
		 * @return The spatial on which this method is called, e.g <code>this</code>.
		 */
		public function rotateAngles(xAngle : Number, yAngle : Number, zAngle : Number) : void
		{
			var tempVars : TempVars = TempVars.getTempVars();
			var q : Quaternion = tempVars.quat1;

			q.fromAngles(xAngle, yAngle, zAngle);
			_localTransform.rotation.multiplyLocal(q);
			setTransformRefresh();

			tempVars.release();
		}

		/**
		 * Centers the spatial in the origin of the world bound.
		 * @return The spatial on which this method is called, e.g <code>this</code>.
		 */
		public function center() : Spatial
		{
			var worldTrans : Vector3f = getWorldTranslation();
			var absTrans : Vector3f = worldTrans.subtract(worldBound.center);
			setTranslation(absTrans);
			return this;
		}

		/**
		 * Returns this spatial's renderqueue bucket. If the mode is set to inherit,
		 * then the spatial gets its renderqueue bucket from its parent.
		 *
		 * @return The spatial's current renderqueue mode.
		 */
		public function get queueBucket() : int
		{
			if (_queueBucket != QueueBucket.Inherit)
			{
				return _queueBucket;
			}
			else if (parent != null)
			{
				return parent.queueBucket;
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
		public function get shadowMode() : int
		{
			if (_shadowMode != ShadowMode.Inherit)
			{
				return _shadowMode;
			}
			else if (parent != null)
			{
				return parent.shadowMode;
			}
			else
			{
				return ShadowMode.Off;
			}
		}

		/**
		 * <code>updateModelBound</code> recalculates the bounding object for this
		 * Spatial.
		 */
		public function updateModelBound() : void
		{

		}

		/**
		 * <code>setModelBound</code> sets the bounding object for this Spatial.
		 *
		 * @param modelBound
		 *            the bounding object for this spatial.
		 */
		public function setBound(modelBound : BoundingVolume) : void
		{

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
		public function clone(newName : String, cloneMaterial : Boolean = true, result : Spatial = null) : Spatial
		{
			if (result == null)
			{
				result = new Spatial(newName);
			}

			if (_worldBound != null)
			{
				result._worldBound = _worldBound.clone();
			}

			result._worldLights = _worldLights.clone();
			result._localLights = _localLights.clone();

			// Set the new owner of the light lists
			result._localLights.setOwner(result);
			result._worldLights.setOwner(result);

			// No need to force cloned to update.
			// This node already has the refresh flags
			// set below so it will have to update anyway.
			result._worldTransform.copyFrom(_worldTransform);
			result._localTransform.copyFrom(_localTransform);

			result.parent = null;
			result.setBoundRefresh();
			result.setTransformRefresh();
			result.setLightListRefresh();

			var length : int = _controls.length;
			for (var i : int = 0; i < length; i++)
			{
				result._controls.push(_controls[i].cloneForSpatial(result));
			}
			return result;
		}

		public function get worldBound() : BoundingVolume
		{
			checkDoBoundUpdate();
			return _worldBound;
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
		public function set localCullHint(hint : int) : void
		{
			_cullHint = hint;
		}

		/**
		 * @return the cullmode set on this Spatial
		 */
		public function get localCullHint() : int
		{
			return _cullHint;
		}

		/**
		 * @see #setCullHint(CullHint)
		 * @return the cull mode of this spatial, or if set to CullHint.Inherit,
		 * the cullmode of it's parent.
		 */
		public function get cullHint() : int
		{
			if (_cullHint != CullHint.Inherit)
			{
				return _cullHint;
			}
			else if (parent != null)
			{
				return parent.cullHint;
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
		public function set localQueueBucket(queueBucket : int) : void
		{
			_queueBucket = queueBucket;
		}

		/**
		 * @return The locally set queue bucket mode
		 *
		 * @see Spatial#setQueueBucket(org.angle3d.renderer.queue.RenderQueue.Bucket)
		 */
		public function get localQueueBucket() : int
		{
			return _queueBucket;
		}

		/**
		 * Sets the shadow mode of the spatial
		 * The shadow mode determines how the spatial should be shadowed,
		 * when a shadowing technique is used. See the
		 * documentation for the public class ShadowMode for more information.
		 *
		 * @see ShadowMode
		 *
		 * @param shadowMode The local shadow mode to set.
		 */
		public function set localShadowMode(shadowMode : int) : void
		{
			_shadowMode = shadowMode;
		}

		/**
		 * @return The locally set shadow mode
		 *
		 * @see Spatial#setShadowMode(org.angle3d.renderer.queue.RenderQueue.ShadowMode)
		 */
		public function get localShadowMode() : int
		{
			return _shadowMode;
		}

		/**
		 * Returns this spatial's last frustum intersection result. This int is set
		 * when a check is made to determine if the bounds of the object fall inside
		 * a camera's frustum. If a parent is found to fall outside the frustum, the
		 * value for this spatial will not be updated.
		 *
		 * @return The spatial's last frustum intersection result.
		 */
		public function get lastFrustumIntersection() : int
		{
			return _frustrumIntersects;
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
		public function set lastFrustumIntersection(intersects : int) : void
		{
			_frustrumIntersects = intersects;
		}

		public function toString() : String
		{
			return name + "(" + getQualifiedClassName(this) + ")";
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
		public function getLocalToWorldMatrix(result : Matrix4f = null) : Matrix4f
		{
			if (result == null)
			{
				result = new Matrix4f();
			}
			else
			{
				result.makeIdentity();
			}

			// multiply with scale first, then rotate, finally translate
			result.scaleVecLocal(getWorldScale());
			result.multQuatLocal(getWorldRotation());
			result.setTranslation(getWorldTranslation());
			return result;
		}

		/**
		 * Visit each scene graph element ordered by DFS
		 * @param visitor
		 */
		public function depthFirstTraversal(visitor : SceneGraphVisitor) : void
		{

		}

		/**
		 * Visit each scene graph element ordered by BFS
		 * @param visitor
		 */
		//public function breadthFirstTraversal(visitor:SceneGraphVisitor):void
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
		//private function breadthFirstTraversalQueue(visitor:SceneGraphVisitor,queue:Queue<Spatial>):void
		//{
		//
		//}

		public function collideWith(other : Collidable, results : CollisionResults) : int
		{
			return -1;
		}
	}
}

