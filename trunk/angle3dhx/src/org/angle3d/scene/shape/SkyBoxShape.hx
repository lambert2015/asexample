package org.angle3d.scene.shape;
import flash.Vector;
import org.angle3d.math.VectorUtil;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.Mesh;

/**
 * ...
 * @author andy
 */
//TODO 重新整理
class SkyBoxShape extends Mesh
{

	public function new(size:Float = 100.0) 
	{
		super();
		
		size *= 0.5;
		
		var vertices:Vector<Float> = Vector.ofArray([-size, -size, size,
			                                         -size, size, size,
			                                         size, -size, size,
			                                         size, size, size,
			                                         -size, size, -size, 
			                                         size, size, -size,
			                                         -size, -size, -size,
			                                         size, -size, -size,
			                                         -size, -size, size,
			                                         size, -size, size,
			                                         size, -size, -size,
			                                         size, size, -size,
			                                         -size, -size, -size,
			                                         -size, size, -size]);
		setVertexBuffer(BufferType.Position, 3, vertices);
		
		var normals:Vector<Float> = Vector.ofArray([0.0,  0.0, -1.0,  
		                                            0.0,  0.0, -1.0,  
		                                            0.0,  0.0, -1.0,  
		                                            0.0,  0.0, -1.0, 
                                                    1.0,  0.0,  0.0,  
		                                            1.0,  0.0,  0.0,  
		                                            1.0,  0.0,  0.0,  
		                                            1.0,  0.0,  0.0,
                                                    0.0,  0.0,  1.0, 
		                                            0.0,  0.0,  1.0, 
		                                            0.0,  0.0,  1.0,  
		                                            0.0,  0.0,  1.0,
                                                   -1.0,  0.0,  0.0, 
	                                               -1.0,  0.0,  0.0]);
		setVertexBuffer(BufferType.Normal, 3, normals);
		
		var indices:Vector<UInt> = VectorUtil.array2UInt([0, 1, 2, 2, 1, 3, 
		                                                  1, 4, 3, 3, 4, 5, 
		                                                  4, 6, 5, 5, 6, 7, 
		                                                  6, 8, 7, 7, 8, 9, 
		                                                  2, 3, 10, 10, 3, 11, 
		                                                  12, 13, 0, 0, 13, 1]);
		var indexBuffer:IndexBuffer = new IndexBuffer();
		indexBuffer.setData(indices);
		setIndexBuffer(indexBuffer);
		
		updateBound();
	}
	
}