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
		protected var _bound : BoundingVolume;

		protected var _boundDirty : Boolean;

		protected var collisionTree : CollisionData;

		protected var _subMeshList : Vector.<SubMesh>;

		protected var _type : String;

		public function Mesh()
		{
			_type = MeshType.MT_STATIC;

			_bound = new BoundingBox();

			_subMeshList = new Vector.<SubMesh>();
		}

		public function get type() : String
		{
			return _type;
		}

		public function setSubMeshList(subMeshs : Vector.<SubMesh>) : void
		{
			_subMeshList = subMeshs;
			_boundDirty = true;
		}

		public function addSubMesh(subMesh : SubMesh) : void
		{
			_subMeshList.push(subMesh);
			subMesh.mesh = this;

			_boundDirty = true;
		}
		
		public function removeSubMesh(subMesh:SubMesh):void
		{
			var index:int = _subMeshList.indexOf(subMesh);
			if(index > -1)
			{
				_subMeshList.splice(index,1);
				_boundDirty = true;
			}
		}

		public function get subMeshList() : Vector.<SubMesh>
		{
			return _subMeshList;
		}

		public function validate() : void
		{
			updateBound();
		}

		/**
		 * Updates the bounding volume of this mesh.
		 * The method does nothing if the mesh has no Position buffer.
		 * It is expected that the position buffer is a float buffer with 3 components.
		 */
		public function updateBound() : void
		{
			if (!_boundDirty)
				return;

			var length : int = _subMeshList.length;
			for (var i : int = 0; i < length; i++)
			{
				var subMesh : SubMesh = _subMeshList[i];
				_bound.mergeLocal(subMesh.getBound());
			}

			_boundDirty = false;
		}

		/**
		 * Sets the {@link BoundingVolume} for this Mesh.
		 * The bounding volume is recomputed by calling {@link #updateBound() }.
		 *
		 * @param modelBound The model bound to set
		 */
		public function setBound(bound : BoundingVolume) : void
		{
			_bound = bound;
			_boundDirty = false;
		}

		/**
		 * Returns the {@link BoundingVolume} of this Mesh.
		 * By default the bounding volume is a {@link BoundingBox}.
		 *
		 * @return the bounding volume of this mesh
		 */
		public function getBound() : BoundingVolume
		{
			return _bound;
		}

		/**
		 * Generates a collision tree for the mesh.
		 */
		private function createCollisionData() : void
		{
			var tree : BIHTree = new BIHTree(this);
			tree.construct();
			collisionTree = tree;
		}

		public function collideWith(other : Collidable, worldMatrix : Matrix4f,
			worldBound : BoundingVolume, results : CollisionResults) : int
		{
			if (collisionTree == null)
			{
				createCollisionData();
			}

			return collisionTree.collideWith(other, worldMatrix, worldBound, results);
		}
	}
}

