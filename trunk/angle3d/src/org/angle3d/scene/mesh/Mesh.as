package org.angle3d.scene.mesh
{
	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.collision.bin.BIHTree;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.scene.CollisionData;

	public class Mesh implements IMesh
	{
		/**
		 * The bounding volume that contains the mesh entirely.
		 * By default a BoundingBox (AABB).
		 */
		protected var mBound:BoundingVolume;

		protected var mBoundDirty:Boolean;

		protected var collisionTree:CollisionData;

		protected var mSubMeshList:Vector.<SubMesh>;

		protected var mType:String;

		public function Mesh()
		{
			mType=MeshType.MT_STATIC;

			mBound=new BoundingBox();

			mSubMeshList=new Vector.<SubMesh>();
		}

		public function get type():String
		{
			return mType;
		}

		public function setSubMeshList(subMeshs:Vector.<SubMesh>):void
		{
			mSubMeshList=subMeshs;
			mBoundDirty=true;
		}

		public function addSubMesh(subMesh:SubMesh):void
		{
			mSubMeshList.push(subMesh);
			subMesh.mesh=this;

			mBoundDirty=true;
		}

		public function removeSubMesh(subMesh:SubMesh):void
		{
			var index:int=mSubMeshList.indexOf(subMesh);
			if (index > -1)
			{
				mSubMeshList.splice(index, 1);
				mBoundDirty=true;
			}
		}

		public function get subMeshList():Vector.<SubMesh>
		{
			return mSubMeshList;
		}

		public function validate():void
		{
			updateBound();
		}

		/**
		 * Updates the bounding volume of this mesh.
		 * The method does nothing if the mesh has no Position buffer.
		 * It is expected that the position buffer is a float buffer with 3 components.
		 */
		public function updateBound():void
		{
			if (!mBoundDirty)
				return;

			var length:int=mSubMeshList.length;
			for (var i:int=0; i < length; i++)
			{
				var subMesh:SubMesh=mSubMeshList[i];
				mBound.mergeLocal(subMesh.getBound());
			}

			mBoundDirty=false;
		}

		/**
		 * Sets the {@link BoundingVolume} for this Mesh.
		 * The bounding volume is recomputed by calling {@link #updateBound() }.
		 *
		 * @param modelBound The model bound to set
		 */
		public function setBound(bound:BoundingVolume):void
		{
			mBound=bound;
			mBoundDirty=false;
		}

		/**
		 * Returns the {@link BoundingVolume} of this Mesh.
		 * By default the bounding volume is a {@link BoundingBox}.
		 *
		 * @return the bounding volume of this mesh
		 */
		public function getBound():BoundingVolume
		{
			return mBound;
		}

		/**
		 * Generates a collision tree for the mesh.
		 */
		private function createCollisionData():void
		{
			var tree:BIHTree=new BIHTree(this);
			tree.construct();
			collisionTree=tree;
		}

		public function collideWith(other:Collidable, worldMatrix:Matrix4f, worldBound:BoundingVolume, results:CollisionResults):int
		{
			if (collisionTree == null)
			{
				createCollisionData();
			}

			return collisionTree.collideWith(other, worldMatrix, worldBound, results);
		}
	}
}

