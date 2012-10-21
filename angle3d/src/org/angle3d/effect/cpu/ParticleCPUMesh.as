package org.angle3d.effect.cpu
{

	import org.angle3d.math.Color;
	import org.angle3d.math.Matrix3f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;
	import org.angle3d.scene.mesh.VertexBuffer;

	/**
	 * The <code>ParticleMesh</code> is the underlying visual implementation of a particle emitter.
	 *
	 */
	public class ParticleCPUMesh extends Mesh
	{
		private var imageX:int;
		private var imageY:int;
		private var uniqueTexCoords:Boolean;
		private var _emitter:ParticleEmitter;

		private var _subMesh:SubMesh;

		public function ParticleCPUMesh()
		{
			super();

			imageX = 1;
			imageY = 1;
			uniqueTexCoords = false;

			_subMesh = new SubMesh();
			this.addSubMesh(_subMesh);
		}

		/**
		 * a particle use 2 triangle,4 point
		 */
		public function initParticleData(emitter:ParticleEmitter, numParticles:int):void
		{
			_emitter = emitter;

			// set positions
			var posVector:Vector.<Number> = new Vector.<Number>(numParticles * 4 * 3, true);
			_subMesh.setVertexBuffer(BufferType.POSITION, 3, posVector);

			// set colors
			var colorVector:Vector.<Number> = new Vector.<Number>(numParticles * 4 * 4, true);
			_subMesh.setVertexBuffer(BufferType.COLOR, 4, colorVector);

			// set texcoords
			uniqueTexCoords = false;
			var texVector:Vector.<Number> = new Vector.<Number>(numParticles * 4 * 2, true);
			for (var i:int = 0; i < numParticles; i++)
			{
				texVector[i * 8 + 0] = 0;
				texVector[i * 8 + 1] = 1;

				texVector[i * 8 + 2] = 1;
				texVector[i * 8 + 3] = 1;

				texVector[i * 8 + 4] = 0;
				texVector[i * 8 + 5] = 0;

				texVector[i * 8 + 6] = 1;
				texVector[i * 8 + 7] = 0;
			}

			_subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, texVector);

			// set indices
			var indices:Vector.<uint> = new Vector.<uint>(numParticles * 6, true);
			for (i = 0; i < numParticles; i++)
			{
				var idx:int = i * 6;

				var startIdx:int = i * 4;

				// triangle 1
				indices[idx + 0] = startIdx + 1;
				indices[idx + 1] = startIdx + 0;
				indices[idx + 2] = startIdx + 2;

				// triangle 2
				indices[idx + 3] = startIdx + 1;
				indices[idx + 4] = startIdx + 2;
				indices[idx + 5] = startIdx + 3;
			}

			_subMesh.setIndices(indices);
			_subMesh.validate();
			//this.validate();
		}

		public function setImagesXY(imageX:int, imageY:int):void
		{
			this.imageX = imageX;
			this.imageY = imageY;

			if (imageX != 1 || imageX != 1)
			{
				uniqueTexCoords = true;
			}
		}

		private var _color:Color = new Color();

		public function updateParticleData(particles:Vector.<Particle>, cam:Camera3D, inverseRotation:Matrix3f):void
		{
			var pvb:VertexBuffer = _subMesh.getVertexBuffer(BufferType.POSITION);
			var positions:Vector.<Number> = pvb.getData();

			var cvb:VertexBuffer = _subMesh.getVertexBuffer(BufferType.COLOR);
			var colors:Vector.<Number> = cvb.getData();

			var tvb:VertexBuffer = _subMesh.getVertexBuffer(BufferType.TEXCOORD);
			var texcoords:Vector.<Number> = tvb.getData();

			var camUp:Vector3f = cam.getUp();
			var camLeft:Vector3f = cam.getLeft();
			var camDir:Vector3f = cam.getDirection();

			inverseRotation.multVecLocal(camUp);
			inverseRotation.multVecLocal(camLeft);
			inverseRotation.multVecLocal(camDir);

			var facingVelocity:Boolean = _emitter.isFacingVelocity();

			var up:Vector3f = new Vector3f();
			var left:Vector3f = new Vector3f();

			if (!facingVelocity)
			{
				up.copyFrom(camUp);
				left.copyFrom(camLeft);
			}

			var faceNormal:Vector3f = _emitter.getFaceNormal();

			//update data in vertex buffers
			var p:Particle;
			var numParticle:int = particles.length;
			for (var i:int = 0; i < numParticle; i++)
			{
				p = particles[i];

				if (p.life == 0)
				{
					for (var j:int = 0; j < 12; j++)
					{
						positions[i * 12 + j] = 0;
					}
					continue;
				}

				if (facingVelocity)
				{
					left.copyFrom(p.velocity);
					left.normalizeLocal();
					camDir.cross(left, up);
					up.scaleLocal(p.size);
					left.scaleLocal(p.size);
				}
				else if (faceNormal != null)
				{
					up.copyFrom(faceNormal);
					up.crossLocal(Vector3f.X_AXIS);
					faceNormal.cross(up, left);
					up.scaleLocal(p.size);
					left.scaleLocal(p.size);
				}
				else if (p.angle != 0)
				{
					var fcos:Number = Math.cos(p.angle) * p.size;
					var fsin:Number = Math.sin(p.angle) * p.size;

					left.x = camLeft.x * fcos + camUp.x * fsin;
					left.y = camLeft.y * fcos + camUp.y * fsin;
					left.z = camLeft.z * fcos + camUp.z * fsin;

					up.x = camLeft.x * -fsin + camUp.x * fcos;
					up.y = camLeft.y * -fsin + camUp.y * fcos;
					up.z = camLeft.z * -fsin + camUp.z * fcos;
				}
				else
				{
					up.copyFrom(camUp);
					left.copyFrom(camLeft);
					up.scaleLocal(p.size);
					left.scaleLocal(p.size);
				}

				var px:Number = p.position.x;
				var py:Number = p.position.y;
				var pz:Number = p.position.z;
				var lx:Number = left.x;
				var ly:Number = left.y;
				var lz:Number = left.z;
				var ux:Number = up.x;
				var uy:Number = up.y;
				var uz:Number = up.z;

				positions[i * 12 + 0] = px + lx + ux;
				positions[i * 12 + 1] = py + ly + uy;
				positions[i * 12 + 2] = pz + lz + uz;

				positions[i * 12 + 3] = px - lx + ux;
				positions[i * 12 + 4] = py - ly + uy;
				positions[i * 12 + 5] = pz - lz + uz;

				positions[i * 12 + 6] = px + lx - ux;
				positions[i * 12 + 7] = py + ly - uy;
				positions[i * 12 + 8] = pz + lz - uz;

				positions[i * 12 + 9] = px - lx - ux;
				positions[i * 12 + 10] = py - ly - uy;
				positions[i * 12 + 11] = pz - lz - uz;

				if (uniqueTexCoords)
				{
					var imgX:int = p.frame % imageX;
					var imgY:int = (p.frame - imgX) / imageY;

					var startX:Number = imgX / imageX;
					var startY:Number = imgY / imageY;
					var endX:Number = startX + 1 / imageX;
					var endY:Number = startY + 1 / imageY;

					texcoords[i * 8 + 0] = startX;
					texcoords[i * 8 + 1] = endY;

					texcoords[i * 8 + 2] = endX;
					texcoords[i * 8 + 3] = endY;

					texcoords[i * 8 + 4] = startX;
					texcoords[i * 8 + 5] = startY;

					texcoords[i * 8 + 6] = endX;
					texcoords[i * 8 + 7] = startY;
				}

				_color.setColor(p.color);
				var pr:Number = _color.r;
				var pg:Number = _color.g;
				var pb:Number = _color.b;
				var pa:Number = p.alpha;
				for (var m:int = 0; m < 4; m++)
				{
					colors[i * 16 + m * 4 + 0] = pr;
					colors[i * 16 + m * 4 + 1] = pg;
					colors[i * 16 + m * 4 + 2] = pb;
					colors[i * 16 + m * 4 + 3] = pa;
				}

			}

			// force renderer to re-send data to GPU
			pvb.updateData(positions);
			cvb.updateData(colors);
			if (uniqueTexCoords)
			{
				tvb.updateData(texcoords);
			}

			//this.validate();
		}
	}
}


