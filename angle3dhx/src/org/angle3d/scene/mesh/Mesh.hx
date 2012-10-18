package org.angle3d.scene.mesh;
import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.Lib;
import flash.Vector;
import org.angle3d.bounding.BoundingBox;
import org.angle3d.bounding.BoundingVolume;
import org.angle3d.collision.bin.BIHTree;
import org.angle3d.collision.Collidable;
import org.angle3d.collision.CollisionResults;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Triangle;
import org.angle3d.scene.CollisionData;
import org.angle3d.utils.Assert;
import org.angle3d.utils.HashMap;

/**
 * <code>Mesh</code> is used to store rendering data.
 * <p>
 * All visible elements in a scene are represented by meshes.
 * Meshes may contain three types of geometric primitives:
 * 
 * @author Kirill Vainer
 */
class Mesh 
{
	/**
     * The bounding volume that contains the mesh entirely.
     * By default a BoundingBox (AABB).
     */
	private var meshBound:BoundingVolume;
	
	private var collisionTree:CollisionData;
	
	private var bufferList:Vector<VertexBuffer>;
	private var bufferMap:HashMap<String,VertexBuffer>;
	
	private var indexBuffer:IndexBuffer;

	private var triangleCount:Int;
	private var vertCount:Int;
	private var maxNumWeights:Int;// only if using skeletal animation

	private var _vertexBufferDirty:Bool;
	private var _vertexBuffer3D:VertexBuffer3D;
	
	private var _indexBufferDirty:Bool;
	private var _indexBuffer3D:IndexBuffer3D;
	
	private var _vertexData:Vector<Float>;

	public function new() 
	{
		meshBound = new BoundingBox();
		bufferList = new Vector<VertexBuffer>();
		bufferMap = new HashMap<String,VertexBuffer>();
		
		_vertexBufferDirty = false;
		_indexBufferDirty = false;
	}
	
	/**
	 * 释放VertexBuffer和IndexBuffer数据，减少内存使用
	 * 需要确保不再更改模型数据了
	 */
	public function clean():Void
	{
		
	}
	
	public function getMeshType():Int
	{
		return MeshType.Static_Mesh;
	}
	
	/**
	 * 上传数据到GPU
	 */
	public function upload(context:Context3D):Void
	{
		if (_indexBufferDirty || _indexBuffer3D == null)
		{
			_uploadIndexBuffer(context);
		}
		
		if (_vertexBufferDirty || _vertexBuffer3D == null)
		{
			_uploadVertexBuffer(context);
		}
	}
	
	public function getIndexBuffer3D():IndexBuffer3D
	{
		return _indexBuffer3D;
	}
	
	public function getVertexBuffer3D():VertexBuffer3D
	{
		return _vertexBuffer3D;
	}
	
	private function _uploadVertexBuffer(context:Context3D):Void
	{
		//生成GPU需要的数据
		_vertexData = new Vector<Float>();
		for (i in 0...vertCount)
		{
			for (j in 0...bufferList.length)
			{
				var buffer:VertexBuffer = bufferList[j];
				var data:Vector<Float> = buffer.getData();
				var comps:Int = buffer.getComponents();
				for (k in 0...comps)
				{
					_vertexData.push(data[i * comps + k]);
				}
			}
		}
	
		if (_vertexBuffer3D != null)
		{
			_vertexBuffer3D.dispose();
		}
		_vertexBuffer3D = context.createVertexBuffer(vertCount, _getData32PerVertex());
		//上传数据
		_vertexBuffer3D.uploadFromVector(_vertexData, 0, vertCount);
		
		_vertexBufferDirty = false;
	}
	
	private function _uploadIndexBuffer(context:Context3D):Void
	{
		if (_indexBuffer3D != null)
		{
			_indexBuffer3D.dispose();
		}

		_indexBuffer3D = context.createIndexBuffer(indexBuffer.getCount());
		_indexBuffer3D.uploadFromVector(indexBuffer.getData(), 0, indexBuffer.getCount());
		_indexBufferDirty = false;
	}
	
	private function _getData32PerVertex():Int
	{
		var count:Int = 0;
		for (i in 0...bufferList.length)
		{
			count += bufferList[i].getComponents();
		}
		return count;
	}

	/**
     * Update the {@link #getVertexCount() vertex} and 
     * {@link #getTriangleCount() triangle} counts for this mesh
     * based on the current data. This method should be called
     * after the {@link Buffer#capacity() capacities} of the mesh's
     * {@link VertexBuffer vertex buffers} has been altered.
     * 
     * @throws IllegalStateException If this mesh is in 
     * {@link #setInterleaved() interleaved} format.
     */
    public function updateCounts():Void
	{
		var pb:VertexBuffer = getVertexBuffer(BufferType.Position);
		if (pb != null)
		{
            vertCount = pb.getCount();
        }
		
        if (indexBuffer != null)
		{
            triangleCount = Std.int(indexBuffer.getCount()/3);
        }
	}
	
	
	/**
     * Returns the number of vertices on this mesh.
     * The value is computed based on the position buffer, which 
     * must be set on all meshes.
     * 
     * @return Number of vertices on the mesh
     */
    public function getVertexCount():Int
	{
        return vertCount;
    }
	
	/**
     * Returns the triangle count for the given LOD level.
     * 
     * @param lod The lod level to look up
     * @return The triangle count for that LOD level
     */
	public function getTriangleCount(lod:Int = -1):Int
	{
        return triangleCount;
    }
	
	/**
     * Scales the texture coordinate buffer on this mesh by the given
     * scale factor. 
     * <p>
     * Note that values above 1 will cause the 
     * texture to tile, while values below 1 will cause the texture 
     * to stretch.
     * </p>
     * 
     */
    public function scaleTextureCoordinates(sx:Float,sy:Float):Void
	{
		var tc:VertexBuffer = getVertexBuffer(BufferType.TexCoord);
		
		Assert.assert(tc != null, "The mesh has no texture coordinates");
		
		var data:Vector<Float> = tc.getData();
		var count:Int = Std.int(data.length / 2);
		for (i in 0...count)
		{
			data[i * 2] *= sx;
			data[i * 2 + 1] *= sy;
		}
		tc.updateData(data);
	}
	
	/**
     * Updates the bounding volume of this mesh. 
     * The method does nothing if the mesh has no {@link Type#Position} buffer.
     * It is expected that the position buffer is a float buffer with 3 components.
     */
	public function updateBound():Void
	{
		var vb:VertexBuffer = getVertexBuffer(BufferType.Position);
		if (meshBound != null && vb != null)
		{
			meshBound.computeFromPoints(vb.getData());
		}
	}
	
	/**
     * Sets the {@link BoundingVolume} for this Mesh.
     * The bounding volume is recomputed by calling {@link #updateBound() }.
     * 
     * @param modelBound The model bound to set
     */
	public function setBound(bound:BoundingVolume):Void
	{
		meshBound = bound;
	}
	
	/**
     * Returns the {@link BoundingVolume} of this Mesh.
     * By default the bounding volume is a {@link BoundingBox}.
     * 
     * @return the bounding volume of this mesh
     */
	public function getBound():BoundingVolume
	{
		return meshBound;
	}
	
	/**
	 * 获取某个VertexBuffer的偏移量
	 * @param	buffer
	 * @return
	 */
	private function _getOffset(buffer:VertexBuffer):Int
	{
		var index:Int = bufferList.indexOf(buffer);
		if (index == 0)
		{
			return 0;
		}
		
		var offset:Int = 0;
		for (i in 0...index)
		{
			offset += bufferList[i].getComponents();
		}
		return offset;
	}
	
	public function addVertexBuffer(buffer:VertexBuffer):Void
	{
		var type:String = buffer.getType();
		
		var vb:VertexBuffer = Lib.as(buffer, VertexBuffer);
		Assert.assert(!bufferMap.containsValue(vb), type + "已经设置过了");
		
		bufferMap.setValue(type, vb);
		bufferList.push(vb);
			
		buffer.setOffset(_getOffset(vb));
		
		if (type == BufferType.Position)
		{
			updateCounts();
		}
		
		_vertexBufferDirty = true;
	}
	
	public inline function getVertexBuffer(type:String):VertexBuffer
	{
		return bufferMap.getValue(type);
	}
	
	public function setVertexBuffer(type:String, components:Int, data:Vector<Float>):Void
	{
		if (data == null)
		    return;
			
		var vb:VertexBuffer = getVertexBuffer(type);
		if (vb == null)
		{
			vb = new VertexBuffer(type);
			addVertexBuffer(vb);
		}
		
		vb.setData(data, components);

		updateCounts();
		
		_vertexBufferDirty = true;
	}
	
	public function setIndexBuffer(buffer:IndexBuffer):Void
	{
		indexBuffer = buffer;
		updateCounts();
		_indexBufferDirty = true;
	}
	
	/**
     * Returns a map of all buffers on this Mesh.
     * Note that the returned map is a reference to the map used internally, 
     * modifying it will cause undefined results.
     * 
     * @return map of vertex buffers on this mesh.
     */
	//public inline function getBufferMap():HashMap<String,VertexBuffer>
	//{
		//return bufferMap;
	//}
	 
	public inline function getBufferList():Vector<VertexBuffer>
	{
		return bufferList;
	}
	
	public inline function getIndexBuffer():IndexBuffer
	{
		return indexBuffer;
	}
	
	public function getTriangle(index:Int,tri:Triangle):Void
	{
		var pb:VertexBuffer = getVertexBuffer(BufferType.Position);
		if (pb != null && indexBuffer != null)
		{
			var indices:Vector<UInt> = indexBuffer.getData();
			var vertices:Vector<Float> = pb.getData();
			
			var vertIndex:Int = index * 3;
			for (i in 0...3)
			{
				BufferUtils.populateFromBuffer(tri.getPoint(i), vertices, indices[vertIndex + i]);
			}
		}
	}
	
	/**
     * Returns the maximum number of weights per vertex on this mesh.
     * 
     * @return maximum number of weights per vertex
     * 
     * @see #setMaxNumWeights(int) 
     */
    public function getMaxNumWeights():Int
	{
        return maxNumWeights;
    }
	
	/**
     * Set the maximum number of weights per vertex on this mesh.
     * Only relevant if this mesh has bone index/weight buffers.
     * This value should be between 0 and 4.
     * 
     * @param maxNumWeights 
     */
    public function setMaxNumWeights(value:Int):Void
	{
        this.maxNumWeights = value;
    }
	
	/**
     * Generates a collision tree for the mesh.
     * Called automatically by {@link #collideWith(com.jme3.collision.Collidable, 
     * com.jme3.math.Matrix4f, 
     * com.jme3.bounding.BoundingVolume, 
     * com.jme3.collision.CollisionResults) }.
     */
    public function createCollisionData():Void
	{
        var tree:BIHTree = new BIHTree(this);
        tree.construct();
        collisionTree = tree;
    }
	
	public function collideWith(other:Collidable, 
	                            worldMatrix:Matrix4f,
	                            worldBound:BoundingVolume,
								results:CollisionResults):Int
	{
		if (collisionTree == null)
		{
			createCollisionData();
		}
		
		return collisionTree.collideWith(other, worldMatrix, worldBound, results);
	}
	
}