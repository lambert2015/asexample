package org.angle3d.scene;

import flash.geom.Vector3D;
import flash.Vector;
import org.angle3d.material.Material;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Transform;
import org.angle3d.mesh.BufferType;
import org.angle3d.mesh.Mesh;
import org.angle3d.mesh.VertexBuffer;
import org.angle3d.utils.Assert;
import org.angle3d.utils.HashMap;
/**
 * BatchNode holds geometrie that are batched version of all geometries that are in its sub scenegraph.
 * There is one geometry per different material in the sub tree.
 * this geometries are directly attached to the node in the scene graph.
 * usage is like any other node except you have to call the {@link #batch()} method once all geoms have been attached to the sub scene graph and theire material set
 * (see todo more automagic for further enhancements)
 * all the geometry that have been batched are set to {@link CullHint#Always} to not render them.
 * the sub geometries can be transformed as usual their transforms are used to update the mesh of the geometryBatch.
 * sub geoms can be removed but it may be slower than the normal spatial removing
 * Sub geoms can be added after the batch() method has been called but won't be batched and will be rendered as normal geometries.
 * To integrate them in the batch you have to call the batch() method again on the batchNode.
 * 
 * TODO normal or tangents or both looks a bit weird
 * TODO more automagic (batch when needed in the updateLigicalState)
 * @author Nehon
 */
class BatchNode extends Node
{
	/**
     * the map of geometry holding the batched meshes
     */
	private var batches:HashMap<Material,Batch>;

	public function new(name:String) 
	{
		super(name);
		
		batches = new HashMap<Material,Batch>();
	}
	
	override public function updateGeometricState():Void
	{
		if (needLightListUpdate())
		{
			updateWorldLightList();
		}
		
		if (needTransformUpdate())
		{
			// combine with parent transforms- same for all spatial
            // subclasses.
			updateWorldTransforms();
		}
		
		if (children.length > 0)
		{
			for (i in 0...children.length)
			{
				children[i].updateGeometricState();
			}
			
			
			var list:Vector<Batch> = batches.toVector();
			for (i in 0...list.length)
			{
				var batch:Batch = list[i];
				if (batch.needMeshUpdate)
				{
					batch.geometry.getMesh().updateBound();
					batch.geometry.updateWorldBound();
					batch.needMeshUpdate = false;
				}
			}
		}
		
		if (needBoundUpdate())
		{
			updateWorldBound();
		}
		
		Assert.assert(refreshFlags == 0, "refreshFlags should equal to 0");
	}
	
	public function getTransforms(geom:Geometry):Transform
	{
		return geom.getWorldTransform();
	}
	
	public function updateSubBatch(bg:Geometry):Void
	{
		var batch:Batch = batches.getValue(bg.getMaterial());
		if (batch != null)
		{
			var mesh:Mesh = batch.geometry.getMesh();
			
			var buffer:VertexBuffer = mesh.getVertexBuffer(BufferType.Position);
			var data:Vector<Float> = buffer.getData();
			doTransformVerts(data, 0, bg.startIndex, bg.startIndex + bg.getVertexCount(), data, bg.cachedOffsetMat);
			buffer.updateData(data);
			
			buffer = mesh.getVertexBuffer(BufferType.Normal);
			if (buffer != null)
			{
				data = buffer.getData();
				doTransformNorm(data, 0, bg.startIndex, bg.startIndex + bg.getVertexCount(), data, bg.cachedOffsetMat);
				buffer.updateData(data);
			}
			
			buffer = mesh.getVertexBuffer(BufferType.Tangent);
			if (buffer != null)
			{
				data = buffer.getData();
				doTransformNorm(data, 0, bg.startIndex, bg.startIndex + bg.getVertexCount(), data, bg.cachedOffsetMat);
				buffer.updateData(data);
			}
			
			batch.needMeshUpdate = true;
		}
	}
	
	/**
     * Batch this batchNode
     * every geometry of the sub scene graph of this node will be batched into a single mesh that will be rendered in one call
     */
	public function batch():Void
	{
		doBatch();
		//we set the batch geometries to ignore transforms to avoid transforms of parent nodes to be applied twice   
		var list:Vector<Batch> = batches.toVector();
		for (i in 0...list.length)
		{
			var batch:Batch = list[i];
			batch.geometry.setIgnoreTransform(true);
		}
	}
	
	private function doBatch():Void
	{
		
	}
	
	private function doTransformVerts(inBuf:Vector<Float>, offset:Int,
	                                  start:Int, end:Int, outBuf:Vector<Float>, 
									  transform:Matrix4f):Void
	{
        var pos:Vector3D = new Vector3D();

        // offset is given in element units
        // convert to be in component units
        offset *= 3;

		var i:Int = start;
        while (i++ < end)
		{
            var index:Int = i * 3;
			
            pos.x = inBuf[index];
            pos.y = inBuf[index + 1];
            pos.z = inBuf[index + 2];

            transform.multVec(pos, pos);
			
            index += offset;
			
            outBuf[index]     = pos.x;
            outBuf[index + 1] = pos.y;
            outBuf[index + 2] = pos.z;
        }
    }

    private function doTransformNorm(inBuf:Vector<Float>, offset:Int,
	                                  start:Int, end:Int, outBuf:Vector<Float>, 
									  transform:Matrix4f):Void
	{
		var pos:Vector3D = new Vector3D();

        // offset is given in element units
        // convert to be in component units
        offset *= 3;

		var i:Int = start;
        while (i++ < end)
		{
            var index:Int = i * 3;
			
            pos.x = inBuf[index];
            pos.y = inBuf[index + 1];
            pos.z = inBuf[index + 2];

            transform.multNormal(pos, pos);
			
            index += offset;
			
            outBuf[index]     = pos.x;
            outBuf[index + 1] = pos.y;
            outBuf[index + 2] = pos.z;
        }
    }

    private function doCopyVector(inVec:Vector<Float>, offset:Int, 
	                              outVec:Vector<Float>):Void
	{
		// offset is given in element units
        // convert to be in component units
        offset *= 3;

		var capacity:Int = Std.int(inVec.length / 3);
		var i:Int = 0;
        while (i++ < capacity)
		{
            var index:Int = i * 3;

            outVec[offset + index]     = inVec[index];
            outVec[offset + index + 1] = inVec[index + 1];
            outVec[offset + index + 2] = inVec[index + 2];
        }
    }
	
}