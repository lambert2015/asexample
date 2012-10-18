package org.angle3d.scene.mesh;

import flash.Vector;

/**
 * LOD level Mesh
 * @author andy
 */
class LodMesh extends Mesh
{
	private var lodLevels:Vector<IndexBuffer>;

	public function new() 
	{
		super();
	}
	
	/**
     * Set the current LOD (level of detail) index buffers on this mesh.
     * 
     * @param lodLevels The LOD levels to set
     */
	public function setCurrentLod(lod:Int):Void
	{
		setIndexBuffer(lodLevels[lod]);
	}
	
	/**
     * Set the LOD (level of detail) index buffers on this mesh.
     * 
     * @param lodLevels The LOD levels to set
     */
	public function setLodLevels(lodLevels:Vector<IndexBuffer>):Void
	{
		this.lodLevels = lodLevels;
	}
	
	/**
     * @return The number of LOD levels set on this mesh, including the main
     * index buffer, returns zero if there are no lod levels.
     */
    public function getNumLodLevels():Int
	{
        return lodLevels != null ? lodLevels.length : 0;
    }
	
	/**
     * Returns the lod level at the given index.
     * 
     * @param lod The lod level index, this does not include
     * the main index buffer.
     * @return The LOD index buffer at the index
     */
    public function getLodLevel(lod:Int):IndexBuffer
	{
        return lodLevels[lod];
    }
	
	/**
     * Returns the triangle count for the given LOD level.
     * 
     * @param lod The lod level to look up
     * @return The triangle count for that LOD level
     */
	override public function getTriangleCount(lod:Int = -1):Int
	{
		if (lodLevels != null && lod >= 0)
		{
			return Std.int(lodLevels[lod].getCount() / 3);
		}
		else
		{
			return super.getTriangleCount();
		}
    }
}