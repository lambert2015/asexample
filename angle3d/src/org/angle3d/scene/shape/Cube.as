package org.angle3d.scene.shape
{
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;

	public class Cube extends Mesh
	{
		public function Cube(width:Number = 10.0, height:Number = 10.0, depth:Number = 10.0, widthSegments:int = 1, heightSegments:int = 1, depthSegments:int = 1)
		{
			super();
			_createBox(width, height, depth, widthSegments, heightSegments, depthSegments);
		}

		private function _createBox(width:Number, height:Number, depth:Number, widthSegments:int, heightSegments:int, depthSegments:int):void
		{
			var widthSegments1:int = widthSegments + 1;
			var heightSegments1:int = heightSegments + 1;
			var depthSegments1:int = depthSegments + 1;

			var numVertices:uint = (widthSegments1 * heightSegments1 + widthSegments1 * depthSegments1 + heightSegments1 * depthSegments1) * 2;
			var _vertices:Vector.<Number> = new Vector.<Number>(numVertices * 3, true);
			var _normals:Vector.<Number> = new Vector.<Number>(numVertices * 3, true);
			var _tangents:Vector.<Number> = new Vector.<Number>(numVertices * 3, true);

			var _indices:Vector.<uint> = new Vector.<uint>((widthSegments * heightSegments + widthSegments * depthSegments + heightSegments * depthSegments) * 12, true);

			var topLeft:uint, topRight:uint, bottomLeft:uint, bottomRight:uint;
			var vertexIndex:uint = 0, indiceIndex:uint = 0;
			var outerPosition:Number;
			var i:uint, j:uint, increment:uint = 0;

			var deltaW:Number = width / widthSegments;
			var deltaH:Number = height / heightSegments;
			var deltaD:Number = depth / depthSegments;
			var halW:Number = width / 2, halH:Number = height / 2, halD:Number = depth / 2;

			// Front & Back faces
			for (i = 0; i < widthSegments1; i++)
			{
				outerPosition = -halW + i * deltaW;
				for (j = 0; j < heightSegments1; j++)
				{
					_normals[vertexIndex] = 0;
					_normals[vertexIndex + 1] = 0;
					_normals[vertexIndex + 2] = -1;
					_normals[vertexIndex + 3] = 0;
					_normals[vertexIndex + 4] = 0;
					_normals[vertexIndex + 5] = 1;

					_tangents[vertexIndex] = 1;
					_tangents[vertexIndex + 1] = 0;
					_tangents[vertexIndex + 2] = 0;
					_tangents[vertexIndex + 3] = -1;
					_tangents[vertexIndex + 4] = 0;
					_tangents[vertexIndex + 5] = 0;

					_vertices[vertexIndex] = outerPosition;
					_vertices[vertexIndex + 1] = -halH + j * deltaH;
					_vertices[vertexIndex + 2] = -halD;
					_vertices[vertexIndex + 3] = outerPosition;
					_vertices[vertexIndex + 4] = -halH + j * deltaH;
					_vertices[vertexIndex + 5] = halD;

					vertexIndex += 6;

					if (i != 0 && j != 0)
					{
						topLeft = 2 * ((i - 1) * (heightSegments + 1) + (j - 1));

						topRight = 2 * (i * (heightSegments + 1) + (j - 1));

						bottomLeft = topLeft + 2;

						bottomRight = topRight + 2;

						_indices[indiceIndex++] = topLeft;
						_indices[indiceIndex++] = bottomLeft;
						_indices[indiceIndex++] = bottomRight;
						_indices[indiceIndex++] = topLeft;
						_indices[indiceIndex++] = bottomRight;
						_indices[indiceIndex++] = topRight;
						_indices[indiceIndex++] = topRight + 1;
						_indices[indiceIndex++] = bottomRight + 1;
						_indices[indiceIndex++] = bottomLeft + 1;
						_indices[indiceIndex++] = topRight + 1;
						_indices[indiceIndex++] = bottomLeft + 1;
						_indices[indiceIndex++] = topLeft + 1;
					}
				}
			}

			increment += 2 * widthSegments1 * heightSegments1;

			// Top & Bottom faces
			for (i = 0; i < widthSegments1; i++)
			{
				outerPosition = -halW + i * deltaW;
				for (j = 0; j < depthSegments1; j++)
				{
					_normals[vertexIndex] = 0;
					_normals[vertexIndex + 1] = 1;
					_normals[vertexIndex + 2] = 0;
					_normals[vertexIndex + 3] = 0;
					_normals[vertexIndex + 4] = -1;
					_normals[vertexIndex + 5] = 0;

					_tangents[vertexIndex] = 1;
					_tangents[vertexIndex + 1] = 0;
					_tangents[vertexIndex + 2] = 0;
					_tangents[vertexIndex + 3] = 1;
					_tangents[vertexIndex + 4] = 0;
					_tangents[vertexIndex + 5] = 0;

					_vertices[vertexIndex] = outerPosition;
					_vertices[vertexIndex + 1] = halH;
					_vertices[vertexIndex + 2] = -halD + j * deltaD;
					_vertices[vertexIndex + 3] = outerPosition;
					_vertices[vertexIndex + 4] = -halH;
					_vertices[vertexIndex + 5] = -halD + j * deltaD;

					vertexIndex += 6;

					if (i != 0 && j != 0)
					{
						topLeft = increment + 2 * ((i - 1) * (depthSegments + 1) + (j - 1));
						topRight = increment + 2 * (i * (depthSegments + 1) + (j - 1));
						bottomLeft = topLeft + 2;
						bottomRight = topRight + 2;

						_indices[indiceIndex++] = topLeft;
						_indices[indiceIndex++] = bottomLeft;
						_indices[indiceIndex++] = bottomRight;
						_indices[indiceIndex++] = topLeft;
						_indices[indiceIndex++] = bottomRight;
						_indices[indiceIndex++] = topRight;
						_indices[indiceIndex++] = topRight + 1;
						_indices[indiceIndex++] = bottomRight + 1;
						_indices[indiceIndex++] = bottomLeft + 1;
						_indices[indiceIndex++] = topRight + 1;
						_indices[indiceIndex++] = bottomLeft + 1;
						_indices[indiceIndex++] = topLeft + 1;
					}
				}
			}

			increment += 2 * widthSegments1 * depthSegments1;

			//Left & Right faces
			for (i = 0; i < heightSegments1; i++)
			{
				outerPosition = -halH + i * deltaH;
				for (j = 0; j < depthSegments1; j++)
				{
					_normals[vertexIndex] = -1;
					_normals[vertexIndex + 1] = 0;
					_normals[vertexIndex + 2] = 0;
					_normals[vertexIndex + 3] = 1;
					_normals[vertexIndex + 4] = 0;
					_normals[vertexIndex + 5] = 0;

					_tangents[vertexIndex] = 0;
					_tangents[vertexIndex + 1] = 0;
					_tangents[vertexIndex + 2] = -1;
					_tangents[vertexIndex + 3] = 0;
					_tangents[vertexIndex + 4] = 0;
					_tangents[vertexIndex + 5] = 1;

					_vertices[vertexIndex] = -halW;
					_vertices[vertexIndex + 1] = outerPosition;
					_vertices[vertexIndex + 2] = -halD + j * deltaD;
					_vertices[vertexIndex + 3] = halW;
					_vertices[vertexIndex + 4] = outerPosition;
					_vertices[vertexIndex + 5] = -halD + j * deltaD;

					vertexIndex += 6;

					if (i != 0 && j != 0)
					{
						topLeft = increment + 2 * ((i - 1) * (depthSegments + 1) + (j - 1));
						topRight = increment + 2 * (i * (depthSegments + 1) + (j - 1));
						bottomLeft = topLeft + 2;
						bottomRight = topRight + 2;

						_indices[indiceIndex++] = topLeft;
						_indices[indiceIndex++] = bottomLeft;
						_indices[indiceIndex++] = bottomRight;
						_indices[indiceIndex++] = topLeft;
						_indices[indiceIndex++] = bottomRight;
						_indices[indiceIndex++] = topRight;
						_indices[indiceIndex++] = topRight + 1;
						_indices[indiceIndex++] = bottomRight + 1;
						_indices[indiceIndex++] = bottomLeft + 1;
						_indices[indiceIndex++] = topRight + 1;
						_indices[indiceIndex++] = bottomLeft + 1;
						_indices[indiceIndex++] = topLeft + 1;
					}
				}
			}

			//UVTs
			var numUvs:uint = (widthSegments1 * heightSegments1 + widthSegments1 * depthSegments1 + heightSegments1 * depthSegments1) * 4;
			var _uvt:Vector.<Number> = new Vector.<Number>(numUvs, true);
			var uvIndex:uint = 0;
			for (i = 0; i < widthSegments1; i++)
			{
				outerPosition = (i / widthSegments);

				for (j = 0; j < heightSegments1; j++)
				{
					_uvt[uvIndex++] = outerPosition;
					_uvt[uvIndex++] = 1 - (j / heightSegments);
					_uvt[uvIndex++] = 1 - outerPosition;
					_uvt[uvIndex++] = 1 - (j / heightSegments);
				}
			}

			for (i = 0; i < widthSegments1; i++)
			{
				outerPosition = (i / widthSegments);

				for (j = 0; j < depthSegments1; j++)
				{
					_uvt[uvIndex++] = outerPosition;
					_uvt[uvIndex++] = 1 - (j / depthSegments);
					_uvt[uvIndex++] = outerPosition;
					_uvt[uvIndex++] = j / depthSegments;
				}
			}

			for (i = 0; i < heightSegments1; i++)
			{
				outerPosition = (i / heightSegments);
				for (j = 0; j < depthSegments1; j++)
				{
					_uvt[uvIndex++] = 1 - (j / depthSegments);
					_uvt[uvIndex++] = 1 - outerPosition;
					_uvt[uvIndex++] = j / depthSegments;
					_uvt[uvIndex++] = 1 - outerPosition;
				}
			}

			var subMesh:SubMesh = new SubMesh();
			subMesh.setVertexBuffer(BufferType.POSITION, 3, _vertices);
			subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, _uvt);
			subMesh.setVertexBuffer(BufferType.NORMAL, 3, _normals);
			subMesh.setVertexBuffer(BufferType.TANGENT, 3, _tangents);
			subMesh.setIndices(_indices);
			subMesh.validate();
			this.addSubMesh(subMesh);
			validate();
		}
	}
}

