package org.angle3d.scene.shape
{
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.MeshHelper;
	import org.angle3d.scene.mesh.SubMesh;

	/**
	 * A simple cylinder, defined by it's height and radius.
	 */
	public class Cylinder extends Mesh
	{

		public function Cylinder(radius : Number = 5.0, height : Number = 10.0, parallels : int = 1, meridians : int = 16)
		{
			super();

			createCylinder(radius, height, parallels, meridians);
		}

		private function createCylinder(radius : Number, height : Number, parallels : int, meridians : int) : void
		{
			//		var _verticesLength : int										= _meridians * (_parallels + 1) + 2;

			var _vertices : Vector.<Number> = new Vector.<Number>();
			var _indices : Vector.<uint> = new Vector.<uint>();
			var _uvt : Vector.<Number> = new Vector.<Number>();

			_vertices[0] = 0;
			_vertices[1] = 0;
			_vertices[2] = 0;

			for (var j : int = 0; j <= parallels; j++)
			{
				for (var i : int = 0; i < meridians; i++)
				{
					_vertices.push(radius * Math.cos(Math.PI * 2 / meridians * i));
					_vertices.push(j * (height / parallels));
					_vertices.push(radius * Math.sin(Math.PI * 2 / meridians * i));
				}
			}

			_vertices.push(0);
			_vertices.push(height);
			_vertices.push(0);


			for (i = 0; i < _vertices.length; i++)
			{
				_vertices[i] = int(_vertices[i] * 100) / 100;
			}

			////////
			for (i = 0; i < meridians - 1; i++)
			{
				_indices.push(0);
				_indices.push(i + 1);
				_indices.push(i + 2);
			}

			_indices.push(0);
			_indices.push(meridians);
			_indices.push(1);

			////////

			for (j = 0; j < parallels; j++)
			{
				for (i = 0; i < meridians - 1; i++)
				{
					_indices.push(i + 1 + (j * meridians));
					_indices.push(i + meridians + 1 + (j * meridians));
					_indices.push(i + 2 + (j * meridians));
				}

				_indices.push(meridians + (j * meridians));
				_indices.push(meridians * 2 + (j * meridians));
				_indices.push(1 + (j * meridians));


				for (i = 0; i < meridians - 1; i++)
				{
					_indices.push(i + meridians + 2 + (j * meridians));
					_indices.push(i + 2 + (j * meridians));
					_indices.push(i + meridians + 1 + (j * meridians));
				}

				_indices.push(meridians + 1 + (j * meridians));
				_indices.push(1 + (j * meridians));
				_indices.push(meridians * 2 + (j * meridians));
			}

			//////////
			for (i = 0; i < meridians - 1; i++)
			{
				_indices.push((meridians * (parallels + 1)) + 1);
				_indices.push((meridians * parallels) + i + 2);
				_indices.push((meridians * parallels) + i + 1);
			}

			_indices.push((meridians * (parallels + 1)) + 1);
			_indices.push(meridians * parallels + 1);
			_indices.push(meridians * (parallels + 1));



			//	trace(_indices);
			//	trace(i);

			_uvt.push(0.5);
			_uvt.push(0.5);
			//_uvt.push(0);

			for (j = 0; j <= parallels; j++)
			{
				for (i = 0; i < meridians; i++)
				{
					_uvt.push(i / meridians);
					_uvt.push(j / parallels);
						//_uvt.push(0);
				}
			}

			_uvt.push(0.5);
			_uvt.push(0.5);
			//_uvt.push(0);

			/*for(i = 0; i < _vertices.length; i++)
			{
			_uvt.push(i/_vertices.length);
			_uvt.push(i/_vertices.length);
			_uvt.push(0);
			}*/

			var _normals : Vector.<Number> = MeshHelper.buildVertexNormals(_indices, _vertices);

			var subMesh : SubMesh = new SubMesh();
			subMesh.setVertexBuffer(BufferType.POSITION, 3, _vertices);
			subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, _uvt);
			subMesh.setVertexBuffer(BufferType.NORMAL, 3, _normals);
			subMesh.setIndices(_indices);
			subMesh.validate();
			this.addSubMesh(subMesh);
		}
	}
}

