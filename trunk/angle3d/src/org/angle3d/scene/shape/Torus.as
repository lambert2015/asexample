package org.angle3d.scene.shape
{
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.MeshHelper;
	import org.angle3d.scene.mesh.SubMesh;

	public class Torus extends Mesh
	{
		public function Torus(radius:Number = 100.0, tubeRadius:Number = 40.0, segmentsR:uint = 8, segmentsT:uint = 6, yUp:Boolean = false)
		{
			super();

			_createTorus(radius, tubeRadius, segmentsR, segmentsT, yUp);
		}

		private function _createTorus(radius:Number, tubeRadius:Number, segmentsR:uint, segmentsT:uint, yUp:Boolean):void
		{

			var _vertices:Vector.<Number> = new Vector.<Number>();
			var _indices:Vector.<uint> = new Vector.<uint>();
			var _verticesIndex:int = 0;
			var _indiceIndex:int = 0;
			var _grid:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(segmentsR, true);


			for (var i:int = 0; i < segmentsR; i++)
			{
				_grid[i] = new Vector.<int>(segmentsT, true);
				for (var j:int = 0; j < segmentsT; j++)
				{
					var u:Number = i / segmentsR * 2 * Math.PI;
					var v:Number = j / segmentsT * 2 * Math.PI;
					if (yUp)
					{
						_vertices[_verticesIndex] = (radius + tubeRadius * Math.cos(v)) * Math.cos(u);
						_vertices[_verticesIndex + 1] = tubeRadius * Math.sin(v);
						_vertices[_verticesIndex + 2] = (radius + tubeRadius * Math.cos(v)) * Math.sin(u);

						_grid[i][j] = _indiceIndex;
						_indiceIndex++;
						_verticesIndex += 3;
					}
					else
					{
						_vertices[_verticesIndex] = (radius + tubeRadius * Math.cos(v)) * Math.cos(u);
						_vertices[_verticesIndex + 1] = -(radius + tubeRadius * Math.cos(v)) * Math.sin(u);
						_vertices[_verticesIndex + 2] = tubeRadius * Math.sin(v);

						_grid[i][j] = _indiceIndex;
						_indiceIndex++;
						_verticesIndex += 3;
					}
				}
			}

			var _uvt:Vector.<Number> = new Vector.<Number>(_indiceIndex * 2, true);

			for (i = 0; i < segmentsR; ++i)
			{
				for (j = 0; j < segmentsT; ++j)
				{

					var ip:int = (i + 1) % segmentsR;
					var jp:int = (j + 1) % segmentsT;
					var a:uint = _grid[i][j];
					var b:uint = _grid[ip][j];
					var c:uint = _grid[i][jp];
					var d:uint = _grid[ip][jp];

					// uvt
					_uvt[a * 2] = i / segmentsR;
					_uvt[a * 2 + 1] = j / segmentsT;

					_uvt[b * 2] = (i + 1) / segmentsR;
					_uvt[b * 2 + 1] = j / segmentsT;

					_uvt[c * 2] = i / segmentsR;
					_uvt[c * 2 + 1] = (j + 1) / segmentsT;

					_uvt[d * 2] = (i + 1) / segmentsR;
					_uvt[d * 2 + 1] = (j + 1) / segmentsT;

					//indices
					_indices.push(a, c, b);
					_indices.push(d, b, c);

				}
			}

			var _normals:Vector.<Number> = MeshHelper.buildVertexNormals(_indices, _vertices);

			var subMesh:SubMesh = new SubMesh();
			subMesh.setVertexBuffer(BufferType.POSITION, 3, _vertices);
			subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, _uvt);
			subMesh.setVertexBuffer(BufferType.NORMAL, 3, _normals);
			subMesh.setIndices(_indices);
			subMesh.validate();
			this.addSubMesh(subMesh);
		}
	}
}

