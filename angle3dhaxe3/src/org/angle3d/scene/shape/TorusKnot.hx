package org.angle3d.scene.shape;

import org.angle3d.math.Vector3f;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.MeshHelper;
import org.angle3d.scene.mesh.SubMesh;
import haxe.ds.Vector;

class TorusKnot extends Mesh
{
	public function new(radius:Float = 100.0, tubeRadius:Float = 40.0, 
						segmentsR:Int = 8, segmentsT:Int = 6, 
						yUp:Bool = false, p:Int = 2, 
						q:Int = 3, heightScale:Float = 1)
	{
		super();

		createKnotTorus(radius, tubeRadius, segmentsR, segmentsT, yUp, p, q, heightScale);
	}

	private function createKnotTorus(radius:Float, tubeRadius:Float, 
									segmentsR:Int, segmentsT:Int, 
									yUp:Bool, p:Int, 
									q:Int, heightScale:Float):Void
	{

		var _vertices:Vector<Float> = new Vector<Float>();
		var _indices:Vector<UInt> = new Vector<UInt>();
		var _verticesIndex:Int = 0;
		var _indiceIndex:Int = 0;
		var _grid:Vector<Vector<Int>> = new Vector<Vector<Int>>(segmentsR);
		var _tang:Vector3f = new Vector3f();
		var _n:Vector3f = new Vector3f();
		var _bitan:Vector3f = new Vector3f();

		var i:Int;
		var j:Int;

		for (i in 0...segmentsR)
		{
			_grid[i] = new Vector<Int>(segmentsT);

			for (j in 0...segmentsT)
			{

				var u:Float = i / segmentsR * 2 * p * Math.PI;
				var v:Float = j / segmentsT * 2 * Math.PI;
				var p:Vector3f = getPos(radius, p, q, heightScale, u, v);
				var p2:Vector3f = getPos(radius, p, q, heightScale, u + .01, v);
				var cx:Float, cy:Float;

				_tang.x = p2.x - p.x;
				_tang.y = p2.y - p.y;
				_tang.z = p2.z - p.z;
				_n.x = p2.x + p.x;
				_n.y = p2.y + p.y;
				_n.z = p2.z + p.z;
				_bitan = _n.cross(_tang);
				_n = _tang.cross(_bitan);
				_bitan.normalizeLocal();
				_n.normalizeLocal();

				cx = tubeRadius * Math.cos(v);
				cy = tubeRadius * Math.sin(v);
				p.x += cx * _n.x + cy * _bitan.x;
				p.y += cx * _n.y + cy * _bitan.y;
				p.z += cx * _n.z + cy * _bitan.z;

				if (yUp)
				{
					_vertices[_verticesIndex] = p.x;
					_vertices[_verticesIndex + 1] = p.z;
					_vertices[_verticesIndex + 2] = p.y;

					_grid[i][j] = _indiceIndex;
					_indiceIndex++;
					_verticesIndex += 3;

				}
				else
				{
					_vertices[_verticesIndex] = p.x;
					_vertices[_verticesIndex + 1] = -p.y;
					_vertices[_verticesIndex + 2] = p.z;

					_grid[i][j] = _indiceIndex;
					_indiceIndex++;
					_verticesIndex += 3;

				}

			}
		}

		var _uvt:Vector<Float> = new Vector<Float>(_indiceIndex * 2);

		for (i in 0...segmentsR)
		{
			for (j in 0...segmentsT)
			{

				var ip:Int = (i + 1) % segmentsR;
				var jp:Int = (j + 1) % segmentsT;
				var a:Int = _grid[i][j];
				var b:Int = _grid[ip][j];
				var c:Int = _grid[i][jp];
				var d:Int = _grid[ip][jp];

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

	private function getPos(radius:Float, p:Int, q:Int, heightScale:Float, u:Float, v:Float):Vector3f
	{
		var cu:Float = Math.cos(u);
		var su:Float = Math.sin(u);
		var quOverP:Float = q / p * u;
		var cs:Float = Math.cos(quOverP);
		var pos:Vector3f = new Vector3f();

		pos.x = radius * (2 + cs) * .5 * cu;
		pos.y = radius * (2 + cs) * su * .5;
		pos.z = heightScale * radius * Math.sin(quOverP) * .5;

		return pos;
	}
}

