package org.angle3d.scene.mesh;

import org.angle3d.bounding.BoundingBox;
import org.angle3d.bounding.BoundingVolume;
import org.angle3d.collision.Collidable;
import org.angle3d.collision.CollisionResults;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Triangle;
import haxe.ds.Vector;
import org.angle3d.utils.ArrayUtil;

class Mesh implements IMesh
{
	/**
	 * The bounding volume that contains the mesh entirely.
	 * By default a BoundingBox (AABB).
	 */
	private var mBound:BoundingVolume;

	private var mBoundDirty:Bool;

	private var mSubMeshList:Array<SubMesh>;

	private var mType:MeshType;

	public function new()
	{
		mType = MeshType.STATIC;

		mBound = new BoundingBox();

		mSubMeshList = new Array<SubMesh>();
	}

	public function getTriangle(index:Int, store:Triangle):Void
	{

	}

	public var type(get, null):MeshType;
	public function get_type():MeshType
	{
		return mType;
	}

	public var subMeshList(get,set):Array<SubMesh>;
	public function set_subMeshList(subMeshs:Array<SubMesh>):Array<SubMesh>
	{
		mSubMeshList = subMeshs;
		mBoundDirty = true;
		
		return mSubMeshList;
	}
	
	public function get_subMeshList():Array<SubMesh>
	{
		return mSubMeshList;
	}

	public function addSubMesh(subMesh:SubMesh):Void
	{
		mSubMeshList.push(subMesh);
		subMesh.mesh = this;

		mBoundDirty = true;
	}

	public function removeSubMesh(subMesh:SubMesh):Void
	{
		var index:Int = ArrayUtil.indexOf(mSubMeshList, subMesh);
		if (index > -1)
		{
			mSubMeshList.splice(index, 1);
			mBoundDirty = true;
		}
	}

	

	public function validate():Void
	{
		updateBound();
	}

	/**
	 * Updates the bounding volume of this mesh.
	 * The method does nothing if the mesh has no Position buffer.
	 * It is expected that the position buffer is a float buffer with 3 components.
	 */
	public function updateBound():Void
	{
		if (!mBoundDirty)
			return;

		var length:Int = mSubMeshList.length;
		for (i in 0...length)
		{
			var subMesh:SubMesh = mSubMeshList[i];
			mBound.mergeLocal(subMesh.getBound());
		}

		mBoundDirty = false;
	}

	/**
	 * Sets the {@link BoundingVolume} for this Mesh.
	 * The bounding volume is recomputed by calling {@link #updateBound() }.
	 *
	 * @param modelBound The model bound to set
	 */
	public function setBound(bound:BoundingVolume):Void
	{
		mBound = bound;
		mBoundDirty = false;
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

	public function collideWith(other:Collidable, worldMatrix:Matrix4f, worldBound:BoundingVolume, results:CollisionResults):Int
	{
		var size:Int = 0;
		var count:Int = subMeshList.length;
		for (i in 0...count)
		{
			size += subMeshList[i].collideWith(other, worldMatrix, worldBound, results);
		}
		return size;
	}
}

