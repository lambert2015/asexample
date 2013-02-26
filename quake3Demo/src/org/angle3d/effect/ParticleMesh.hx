package org.angle3d.effect;
import flash.Vector;
import org.angle3d.math.Matrix3f;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.VertexBuffer;
import org.angle3d.renderer.Camera3D;

/**
 * The <code>ParticleMesh</code> is the underlying visual implementation of a 
 * {@link ParticleEmitter particle emitter}.
 * 
 * @author Kirill Vainer
 */
class ParticleMesh extends Mesh
{
	private var imageX:Int;
	private var imageY:Int;
	private var uniqueTexCoords:Bool;
	private var emitter:ParticleEmitter;
	private var particlesCopy:Vector<Particle>;

	public function new() 
	{
		super();
		
		imageX = 1;
		imageY = 1;
		uniqueTexCoords = false;
		
	}
	
	public function initParticleData(emitter:ParticleEmitter, numParticles:Int):Void
	{
		this.emitter = emitter;
		
		particlesCopy  = new Vector<Particle>(numParticles);
		
		// a particle use 2 triangle,4 point
		
		// set positions
		var posVector:Vector<Float> = new Vector<Float>(numParticles * 4 * 3, true);
		
		//if the buffer is already set only update the data
		var buf:VertexBuffer = getVertexBuffer(BufferType.Position);
		if (buf != null)
		{
			buf.updateData(posVector);
		}
		else
		{
			setVertexBuffer(BufferType.Position, 3, posVector);
		}
		
		// set colors
		var colorVector:Vector<Float> = new Vector<Float>(numParticles * 4 * 4, true);
		
		//if the buffer is already set only update the data
		buf = getVertexBuffer(BufferType.Color);
		if (buf != null)
		{
			buf.updateData(colorVector);
		}
		else
		{
			setVertexBuffer(BufferType.Color, 4, colorVector);
		}
		
		// set texcoords
		uniqueTexCoords = false;
		
		var texVector:Vector<Float> = new Vector<Float>(numParticles * 2 * 4, true);
		for (i in 0...numParticles)
		{
            for (j in 0...4)
			{
				texVector[i * 8 + j * 2 + 0] = 0;
				texVector[i * 8 + j * 2 + 1] = 1;
			}
        }
		
		//if the buffer is already set only update the data
		buf = getVertexBuffer(BufferType.TexCoord);
		if (buf != null)
		{
			buf.updateData(texVector);
		}
		else
		{
			setVertexBuffer(BufferType.TexCoord, 2, texVector);
		}
		
		// set indices
		var indices:Vector<UInt> = new Vector<UInt>(numParticles * 6, true);
		for (i in 0...numParticles)
		{
			var idx:Int = i * 6;
			var startIdx:Int = i * 4;
			
			//TODO 好像顺序不对?
			
			// triangle 1
			indices[idx + 0] = startIdx + 1;
			indices[idx + 1] = startIdx + 0;
			indices[idx + 2] = startIdx + 2;
			
			// triangle 2
			indices[idx + 3] = startIdx + 1;
			indices[idx + 4] = startIdx + 2;
			indices[idx + 5] = startIdx + 3;
        }
		
		//if the buffer is already set only update the data
		var indexBuf:IndexBuffer = getIndexBuffer();
		if (indexBuf != null)
		{
			indexBuf.setData(indices);
		}
		else
		{
			indexBuf = new IndexBuffer();
			indexBuf.setData(indices);
			setIndexBuffer(indexBuf);
		}
	}
	
	public function setImagesXY(imageX:Int, imageY:Int):Void
	{
		this.imageX = imageX;
		this.imageY = imageY;
		
		if (imageX != 1 || imageX != 1)
		{
			uniqueTexCoords = true;
		}
	}
	
	public function updateParticleData(particles:Vector<Particle>, cam:Camera3D, inverseRotation:Matrix3f):Void
	{
		particlesCopy = particles.concat();
	}
	
}