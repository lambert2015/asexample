package org.angle3d.scene.shape;

import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.MeshHelper;
import org.angle3d.scene.mesh.SubMesh;

class Cone extends Mesh
{
	public function new(_radius:Float = 5.0, _height:Float = 10.0, _meridians:Int = 16)
	{
		super();

		createCone(_radius, _height, _meridians);
	}

	private function createCone(_radius:Float, _height:Float, _meridians:Int):Void
	{
		var _vertex_no:Int = 0;

		var _verticesLength:Int = _meridians + 2;
		var _indicesLength:Int = _meridians * 2;

		var _vertices:Vector<Float> = new Vector<Float>();
		var _indices:Vector<UInt> = new Vector<UInt>();
		var _uvt:Vector<Float> = new Vector<Float>();

		_vertices[0] = 0;
		_vertices[1] = 0;
		_vertices[2] = 0;

		for (var i:Int = 0; i < _meridians; i++)
		{
			_vertices.push(_radius * Math.cos(Math.PI * 2 / _meridians * _vertex_no));
			_vertices.push(0);
			_vertices.push(_radius * Math.sin(Math.PI * 2 / _meridians * _vertex_no));
			_vertex_no++;
		}

		_vertices.push(0);
		_vertices.push(_height);
		_vertices.push(0);

		_vertex_no = 0;

		for (i = 0; i < _meridians - 1; i++)
		{
			_indices.push(0);
			_indices.push(_vertex_no + 1);
			_indices.push(_vertex_no + 2);
			_vertex_no++;
		}

		_indices.push(0);
		_indices.push(_vertex_no + 1);
		_indices.push(1);

		_vertex_no = 1;

		for (i = 0; i < _meridians - 1; i++)
		{
			_indices.push(_vertex_no);
			_indices.push(_meridians + 1);
			_indices.push(_vertex_no + 1);
			_vertex_no++;
		}

		_indices.push(_vertex_no);
		_indices.push(_meridians + 1);
		_indices.push(1);

		_uvt.push(0.5);
		_uvt.push(0.5);
		//_uvt.push(0);

		for (i = 0; i < _verticesLength / 2; i++)
		{
			_uvt.push(1);
			_uvt.push(0);
				//_uvt.push(0);
		}

		for (i = 0; i < _verticesLength / 2; i++)
		{
			_uvt.push(i / _meridians);
			_uvt.push(0);
				//_uvt.push(0);
		}

		_uvt.push(0.5);
		_uvt.push(1);
		//_uvt.push(0);

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

