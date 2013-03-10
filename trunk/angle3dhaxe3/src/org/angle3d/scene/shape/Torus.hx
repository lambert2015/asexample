package org.angle3d.scene.shape;

import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.MeshHelper;
import org.angle3d.scene.mesh.SubMesh;

class Torus extends Mesh
{
	public function new(radius:Float = 100.0, tubeRadius:Float = 40.0, segmentsR:uint = 8, segmentsT:uint = 6, yUp:Bool = false)
	{
		super();

		_createTorus(radius, tubeRadius, segmentsR, segmentsT, yUp);
	}

	private function _createTorus(radius:Float, tubeRadius:Float, segmentsR:uint, segmentsT:uint, yUp:Bool):Void
	{

		var _vertices:Vector<Float> = new Vector<Float>();
		var _indices:Vector<UInt> = new Vector<UInt>();
		var _verticesIndex:Int = 0;
		var _indiceIndex:Int = 0;
		var _grid:Vector<Vector<Int>> = new Vector<Vector<Int>>(segmentsR, true);


		for (var i:Int = 0; i < segmentsR; i++)
		{
			_grid[i] = new Vector<Int>(segmentsT, true);
			for (var j:Int = 0; j < segmentsT; j++)
			{
				var u:Float = i / segmentsR * 2 * Math.PI;
				var v:Float = j / segmentsT * 2 * Math.PI;
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

		var _uvt:Vector<Float> = new Vector<Float>(_indiceIndex * 2, true);

		for (i = 0; i < segmentsR; ++i)
		{
			for (j = 0; j < segmentsT; ++j)
			{

				var ip:Int = (i + 1) % segmentsR;
				var jp:Int = (j + 1) % segmentsT;
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

		var _normals:Vector<Float> = MeshHelper.buildVertexNormals(_indices, _vertices);

		var subMesh:SubMesh = new SubMesh();
		subMesh.setVertexBuffer(BufferType.POSITION, 3, _vertices);
		subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, _uvt);
		subMesh.setVertexBuffer(BufferType.NORMAL, 3, _normals);
		subMesh.setIndices(_indices);
		subMesh.validate();
		this.addSubMesh(subMesh);
		validate();
	}
}
