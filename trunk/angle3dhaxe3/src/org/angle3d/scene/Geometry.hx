package org.angle3d.scene
{
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.material.Material;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.utils.Assert;
	import org.angle3d.utils.TempVars;

	/**
	 * Geometry defines a leaf node of the scene graph. The leaf node
	 * contains the geometric data for rendering objects. It manages all rendering
	 * information such as a Material object to define how the surface
	 * should be shaded and the Mesh data to contain the actual geometry.
	 *
	 */
	public class Geometry extends Spatial
	{
		protected var mMesh:Mesh;

		protected var mMaterial:Material;

		/**
		* When true, the geometry's transform will not be applied.
		*/
		protected var mIgnoreTransform:Boolean;

		protected var mCachedWorldMat:Matrix4f;

		public function Geometry(name:String, mesh:Mesh = null)
		{
			super(name);

			mIgnoreTransform = false;
			mCachedWorldMat = new Matrix4f();

			setMesh(mesh);
		}

		/**
		 * 渲染时只使用本地坐标
		 * @return If ignoreTransform mode is set.
		 *
		 * @see Geometry#setIgnoreTransform(boolean)
		 */
		public function isIgnoreTransform():Boolean
		{
			return mIgnoreTransform;
		}

		/**
		 * @param ignoreTransform If true, the geometry's transform will not be applied.
		 */
		public function setIgnoreTransform(value:Boolean):void
		{
			mIgnoreTransform = value;
		}

		/**
		 * Sets the mesh to use for this geometry when rendering.
		 *
		 * @param mesh the mesh to use for this geometry
		 *
		 */
		public function setMesh(mesh:Mesh):void
		{
			if (mesh == null)
			{
				return;
			}

			this.mMesh = mesh;
			setBoundRefresh();
		}

		/**
		 * Returns the mseh to use for this geometry
		 *
		 * @return the mseh to use for this geometry
		 *
		 * @see #setMesh(org.angle3d.scene.Mesh)
		 */
		public function getMesh():Mesh
		{
			return mMesh;
		}

		/**
		 * Sets the material to use for this geometry.
		 *
		 * @param material the material to use for this geometry
		 */
		override public function setMaterial(material:Material):void
		{
			this.mMaterial = material;
		}

		/**
		 * Returns the material that is used for this geometry.
		 *
		 * @return the material that is used for this geometry
		 *
		 * @see #setMaterial(org.angle3d.material.Material)
		 */
		public function getMaterial():Material
		{
			return mMaterial;
		}

		/**
		 * @return The bounding volume of the mesh, in model space.
		 */
		public function getModelBound():BoundingVolume
		{
			return mMesh.getBound();
		}

		/**
		 * Updates the bounding volume of the mesh. Should be called when the
		 * mesh has been modified.
		 */
		override public function updateModelBound():void
		{
			mMesh.updateBound();
			setBoundRefresh();
		}

		/**
		 * <code>updateWorldBound</code> updates the bounding volume that contains
		 * this geometry. The location of the geometry is based on the location of
		 * all this node's parents.
		 *
		 * @see com.jme.scene.Spatial#updateWorldBound()
		 */
		override public function updateWorldBound():void
		{
			super.updateWorldBound();

			if (mMesh == null)
			{
				return;
			}

			if (mMesh.getBound() != null)
			{
				if (mIgnoreTransform)
				{
					// we do not transform the model bound by the world transform,
					// just use the model bound as-is
					mWorldBound = mMesh.getBound().clone(mWorldBound);
				}
				else
				{
					mWorldBound = mMesh.getBound().transform(mWorldTransform, mWorldBound);
				}
			}
		}

		override protected function updateWorldTransforms():void
		{
			super.updateWorldTransforms();

			computeWorldMatrix();

			// geometry requires lights to be sorted
			mWorldLights.sort(true);
		}

		/**
		 * Recomputes the matrix returned by {@link Geometry#getWorldMatrix() }.
		 * This will require a localized transform update for this geometry.
		 */
		public function computeWorldMatrix():void
		{
			// Force a local update of the geometry's transform
			checkDoTransformUpdate();

			// Compute the cached world matrix
			mCachedWorldMat.makeIdentity();
			mCachedWorldMat.setQuaternion(mWorldTransform.rotation);
			mCachedWorldMat.setTranslation(mWorldTransform.translation);

			//TODO 优化这里
			var tempVars:TempVars = TempVars.getTempVars();
			var scaleMat:Matrix4f = tempVars.tempMat4;
			scaleMat.makeIdentity();
			scaleMat.scaleVecLocal(mWorldTransform.scale);
			mCachedWorldMat.multLocal(scaleMat);
			tempVars.release();
		}

		/**
		 * @return A {@link Matrix4f matrix} that transforms the {@link Geometry#getMesh() mesh}
		 * from model space to world space. This matrix is computed based on the
		 * {@link Geometry#getWorldTransform() world transform} of this geometry.
		 * In order to receive updated values, you must call {@link Geometry#computeWorldMatrix() }
		 * before using this method.
		 */
		public function getWorldMatrix():Matrix4f
		{
			return mCachedWorldMat;
		}

		/**
		 * Sets the model bound to use for this geometry.
		 * This alters the bound used on the mesh as well via
		 * {@link Mesh#setBound(org.angle3d.bounding.BoundingVolume) } and
		 * forces the world bounding volume to be recomputed.
		 *
		 * @param modelBound The model bound to set
		 */
		override public function setBound(bound:BoundingVolume):void
		{
			mWorldBound = null;
			mMesh.setBound(bound);
			setBoundRefresh();
		}

		override public function collideWith(other:Collidable, results:CollisionResults):int
		{
			// Force bound to update
			checkDoBoundUpdate();
			// Update transform, and compute cached world matrix
			computeWorldMatrix();

			CF::DEBUG
			{
				Assert.assert((mRefreshFlags & (Spatial.RF_BOUND | Spatial.RF_TRANSFORM)) == 0, "");
			}

			if (mMesh != null)
			{
				// NOTE: BIHTree in mesh already checks collision with the
				// mesh's bound
				var prevSize:int = results.size;
				var added:int = mMesh.collideWith(other, mCachedWorldMat, mWorldBound, results);
				var newSize:int = results.size;
				for (var i:int = prevSize; i < newSize; i++)
				{
					results.getCollisionDirect(i).geometry = this;
				}
				return added;
			}
			return 0;
		}

		override public function depthFirstTraversal(visitor:SceneGraphVisitor):void
		{
			visitor.visit(this);
		}

		//override private function breadthFirstTraversalQueue(visitor:SceneGraphVisitor,queue:Queue<Spatial>):void
		//{
		//
		//}

		override public function clone(newName:String, cloneMaterial:Boolean = true, result:Spatial = null):Spatial
		{
			var geom:Geometry;
			if (result == null)
			{
				geom = new Geometry(newName);
			}
			else
			{
				geom = result as Geometry;
			}

			geom = super.clone(newName, cloneMaterial, geom) as Geometry;

			geom.mCachedWorldMat.copyFrom(mCachedWorldMat);
			if (mMaterial != null)
			{
				if (cloneMaterial)
				{
					geom.mMaterial = mMaterial.clone();
				}
				else
				{
					geom.mMaterial = mMaterial;
				}
			}

			return geom;
		}
	}
}

