package org.angle3d.scene
{


	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.material.Material;
	import org.angle3d.utils.Assert;
	import org.angle3d.utils.Logger;

	/**
	 * <code>Node</code> defines an internal node of a scene graph. The internal
	 * node maintains a collection of children and handles merging said children
	 * into a single bound to allow for very fast culling of multiple nodes. Node
	 * allows for any number of children to be attached.
	 *
	 */

	class Node extends Spatial
	{
		/**
		 * This node's children.
		 */
		private var mChildren:Vector<Spatial>;

		/**
		 * Constructor instantiates a new <code>Node</code> with a default empty
		 * list for containing children.
		 *
		 * @param name
		 *            the name of the scene element. This is required for
		 *            identification and comparision purposes.
		 */
		public function Node(name:String)
		{
			super(name);
		}

		override private function _init():Void
		{
			super._init();
			mChildren = new Vector<Spatial>();
		}

		override public function setMaterial(material:Material):Void
		{
			var numChildren:Int = mChildren.length;
			for (var i:Int = 0; i < numChildren; i++)
			{
				mChildren[i].setMaterial(material);
			}
		}

		/**
		 *
		 * <code>getNumChildren</code> returns the number of children this node
		 * maintains.
		 *
		 * @return the number of children this node maintains.
		 */
		public function get numChildren():uint
		{
			return mChildren.length;
		}

		override public function setTransformRefresh():Void
		{
			super.setTransformRefresh();

			//TODO 理解可能有误差

			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				if (child.needTransformUpdate())
				{
					continue;
				}

				child.setTransformRefresh();
			}
		}

		override public function setLightListRefresh():Void
		{
			super.setLightListRefresh();

			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				if (child.needLightListUpdate())
				{
					continue;
				}

				child.setLightListRefresh();
			}
		}

		override public function updateWorldBound():Void
		{
			super.updateWorldBound();

			// for a node, the world bound is a combination of all it's children bounds
			var resultBound:BoundingVolume = null;
			var size:Int = mChildren.length;
			var child:Spatial;
			for (var i:Int = 0; i < size; i++)
			{
				child = mChildren[i];

				CF::DEBUG
				{
					//child bound is assumed to be updated
					Assert.assert(!child.needBoundUpdate(), "child bound is not updated");
				}

				if (resultBound != null)
				{
					// merge current world bound with child world bound
					resultBound.mergeLocal(child.worldBound);
				}
				else
				{
					// set world bound to first non-null child world bound
					if (child.worldBound != null)
					{
						resultBound = child.worldBound.clone(mWorldBound);
					}
				}
			}

			mWorldBound = resultBound;
		}

		override public function updateControls(tpf:Float):Void
		{
			super.updateControls(tpf);

			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				child.updateControls(tpf);
			}
		}

		override public function updateGeometricState():Void
		{
			if (needLightListUpdate())
			{
				updateWorldLightList();
			}

			if (needTransformUpdate())
			{
				// combine with parent transforms- same for all spatial subclasses.
				updateWorldTransforms();
			}

			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				child.updateGeometricState();
			}


			if (needBoundUpdate())
			{
				updateWorldBound();
			}

			CF::DEBUG
			{
				Assert.assert(mRefreshFlags == 0, "refreshFlags == 0");
			}
		}

		/**
		 *
		 * <code>attachChild</code> attaches a child to this node. This node
		 * becomes the child's parent. The current number of children maintained is
		 * returned.
		 * <br>
		 * If the child already had a parent it is detached from that former parent.
		 *
		 * @param child
		 *            the child to attach to this node.
		 * @return the number of children maintained by this node.
		 */
		public function attachChild(child:Spatial):Void
		{
			var cParent:Node = child.parent;
			if (cParent != this && child != this)
			{
				if (cParent != null)
				{
					cParent.detachChild(child);
				}

				child.parent = this;
				mChildren.push(child);

				// XXX: Not entirely correct? Forces bound update up the
				// tree stemming from the attached child. Also forces
				// transform update down the tree-
				child.setTransformRefresh();
				child.setLightListRefresh();

//				CF::DEBUG
//				{
//					Logger.log(child.toString() + " attached to " + this.toString());
//				}
			}
		}

		/**
		 *
		 * <code>attachChildAt</code> attaches a child to this node at an index. This node
		 * becomes the child's parent. The current number of children maintained is
		 * returned.
		 * <br>
		 * If the child already had a parent it is detached from that former parent.
		 *
		 * @param child
		 *            the child to attach to this node.
		 * @return the number of children maintained by this node.
		 */
		public function attachChildAt(child:Spatial, index:Int):Void
		{
			var cParent:Node = child.parent;
			if (cParent != this && child != this)
			{
				if (cParent != null)
				{
					cParent.detachChild(child);
				}

				mChildren[index] = child;
				child.parent = this;
				child.setTransformRefresh();
				child.setLightListRefresh();

				CF::DEBUG
				{
					Logger.log(child.toString() + " attached to " + this.toString());
				}
			}
		}

		/**
		 * <code>detachChild</code> removes a given child from the node's list.
		 * This child will no longe be maintained.
		 *
		 * @param child
		 *            the child to remove.
		 * @return the index the child was at. -1 if the child was not in the list.
		 */
		public function detachChild(child:Spatial):Int
		{
			if (child.parent == this)
			{
				var index:Int = mChildren.indexOf(child);
				if (index != -1)
				{
					detachChildAt(index);
				}
				return index;
			}

			return -1;
		}


		/**
		 * <code>detachChild</code> removes a given child from the node's list.
		 * This child will no longe be maintained. Only the first child with a
		 * matching name is removed.
		 *
		 * @param childName
		 *            the child to remove.
		 * @return the index the child was at. -1 if the child was not in the list.
		 */
		public function detachChildByName(childName:String):Int
		{
			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				if (childName == child.name)
				{
					detachChildAt(i);
					return i;
				}
			}

			return -1;
		}

		/**
		 *
		 * <code>detachChildAt</code> removes a child at a given index. That child
		 * is returned for saving purposes.
		 *
		 * @param index
		 *            the index of the child to be removed.
		 * @return the child at the supplied index.
		 */
		public function detachChildAt(index:Int):Spatial
		{
			var child:Spatial = mChildren[index];
			mChildren.splice(index, 1);

			if (child != null)
			{
				child.parent = null;

				CF::DEBUG
				{
					Logger.log(child.toString() + " removed from " + this.toString());
				}

				// since a child with a bound was detached;
				// our own bound will probably change.
				setBoundRefresh();

				// our world transform no longer influences the child.
				// XXX: Not neccessary? Since child will have transform updated
				// when attached anyway.
				child.setTransformRefresh();
				// lights are also inherited from parent
				child.setLightListRefresh();
			}
			return child;
		}

		/**
		 *
		 * <code>detachAllChildren</code> removes all children attached to this
		 * node.
		 */
		public function detachAllChildren():Void
		{
			var i:Int = mChildren.length;
			while (--i >= 0)
			{
				var child:Spatial = mChildren[i];
				if (child != null)
				{
					child.parent = null;

					CF::DEBUG
					{
						Logger.log(child.toString() + " removed from " + this.toString());
					}

					child.setTransformRefresh();
					child.setLightListRefresh();
				}
			}

			mChildren.length = 0;

			setBoundRefresh();

			CF::DEBUG
			{
				Logger.log("All children removed from " + this.toString());
			}
		}

		/**
		 * <code>getChildIndex</code> returns the index of the given spatial
		 * in this node's list of children.
		 * @param sp
		 *          The spatial to look up
		 * @return
		 *          The index of the spatial in the node's children, or -1
		 *          if the spatial is not attached to this node
		 */
		public function getChildIndex(sp:Spatial):Int
		{
			return mChildren.indexOf(sp);
		}

		/**
		 * More efficient than e.g detaching and attaching as no updates are needed.
		 * @param index1
		 * @param index2
		 */
		public function swapChildren(index1:Int, index2:Int):Void
		{
			var child1:Spatial = mChildren[index1];
			mChildren[index1] = mChildren[index2];
			mChildren[index2] = child1;
		}

		/**
		 *
		 * <code>getChild</code> returns a child at a given index.
		 *
		 * @param i
		 *            the index to retrieve the child from.
		 * @return the child at a specified index.
		 */
		public function getChildAt(index:Int):Spatial
		{
			return mChildren[index];
		}

		/**
		 * <code>getChild</code> returns the first child found with exactly the
		 * given name (case sensitive.)
		 *
		 * @param name
		 *            the name of the child to retrieve. If null, we'll return null.
		 * @return the child if found, or null.
		 */
		public function getChildByName(name:String):Spatial
		{
			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				if (child.name == name)
				{
					return child;
				}
				else if (child is Node)
				{
					var node:Node = (child as Node);
					var out:Spatial = node.getChildByName(name);
					if (out != null)
					{
						return out;
					}
				}
			}
			return null;
		}

		/**
		 * determines if the provided Spatial is contained in the children list of
		 * this node.
		 *
		 * @param spat
		 *            the child object to look for.
		 * @return true if the object is contained, false otherwise.
		 */
		public function hasChild(sp:Spatial):Bool
		{
			if (mChildren.indexOf(sp) != -1)
			{
				return true;
			}

			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				if (child is Node)
				{
					var node:Node = child as Node;
					if (node.hasChild(sp))
					{
						return true;
					}
				}
			}

			return false;
		}

		/**
		 * Returns all children to this node. Note that modifying that given
		 * list is not allowed.
		 *
		 * @return a list containing all children to this node
		 */
		public function get children():Vector<Spatial>
		{
			return mChildren;
		}

		override public function collideWith(other:Collidable, results:CollisionResults):Int
		{
			var total:Int = 0;
			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				total += child.collideWith(other, results);
			}
			return total;
		}

		override public function setBound(bound:BoundingVolume):Void
		{
			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				child.setBound(bound != null ? bound.clone() : null);
			}
		}

		override public function updateModelBound():Void
		{
			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				child.updateModelBound();
			}
		}

		override public function depthFirstTraversal(visitor:SceneGraphVisitor):Void
		{
			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				child.depthFirstTraversal(visitor);
			}
			visitor.visit(this);
		}

		//override private function breadthFirstTraversalQueue(visitor:SceneGraphVisitor,queue:Queue<Spatial>):Void
		//{
		//for (i in 0...children.length)
		//{
		//var child:Spatial = children[i];
		//queue.enqueue(child);
		//}
		//}

		override public function clone(newName:String, cloneMaterial:Bool = true, result:Spatial = null):Spatial
		{
			var node:Node;
			if (result == null || !(result is Node))
			{
				node = new Node(newName);
			}
			else
			{
				node = (result as Node);
			}

			node = super.clone(newName, cloneMaterial, node) as Node;

			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				var child:Spatial = mChildren[i];
				var childClone:Spatial = child.clone(newName, cloneMaterial);
				node.attachChild(childClone);
			}

			return node;
		}
	}
}

