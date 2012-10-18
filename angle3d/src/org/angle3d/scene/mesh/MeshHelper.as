package org.angle3d.scene.mesh
{
	import org.angle3d.math.Vector3f;

	public class MeshHelper
	{
		public function MeshHelper()
		{
		}

		/**
		 * 计算一个Mesh的顶点法向量
		 */
		public static function buildVertexNormals(indices : Vector.<uint>, vertices : Vector.<Number>) : Vector.<Number>
		{
			var normals : Vector.<Number> = new Vector.<Number>(vertices.length, true);

			var adjs : Vector.<Vector.<uint>> = buildVertexAdjancency(indices, vertices);
			var faceNormals : Vector.<Number> = buildFaceNormal(indices, vertices);

			var i : int;
			var index : int;
			var refIndex : int;
			var adj : Vector.<uint>;
			var iLength : int = indices.length;
			for (i = 0; i < iLength; i++)
			{
				adj = adjs[indices[i]];

				_v0.setTo(0.0, 0.0, 0.0);

				for (var n : int = 0, aLength : int = adj.length; n < aLength; n++)
				{
					index = adj[n] * 3;
					_v0.x += faceNormals[index + 0];
					_v0.y += faceNormals[index + 1];
					_v0.z += faceNormals[index + 2];
				}

				_v0.normalizeLocal();

				refIndex = indices[i] * 3;
				normals[refIndex + 0] = _v0.x;
				normals[refIndex + 1] = _v0.y;
				normals[refIndex + 2] = _v0.z;
			}

			return normals;
		}

		public static function buildVertexAdjancency(indices : Vector.<uint>, vertices : Vector.<Number>) : Vector.<Vector.<uint>>
		{
			var i : int, j : int, m : int;

			var adjs : Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>(int(vertices.length / 3), true);

			for (i = 0, j = 0; i < indices.length; i += 3, j++)
			{
				for (m = 0; m < 3; m++)
				{
					var index : int = indices[i + m];
					if (adjs[index] == null)
						adjs[index] = new Vector.<uint>();
					//对应一个三角形
					adjs[index].push(j);
				}
			}

			return adjs;
		}

		private static var _v0 : Vector3f = new Vector3f();
		private static var _v1 : Vector3f = new Vector3f();
		private static var _v2 : Vector3f = new Vector3f();

		public static function buildFaceNormal(indices : Vector.<uint>, vertices : Vector.<Number>) : Vector.<Number>
		{
			var iLength : int = indices.length;
			var faceNormals : Vector.<Number> = new Vector.<Number>(iLength, true);

			var index : int;
			var p0x : Number, p0y : Number, p0z : Number;
			var p1x : Number, p1y : Number, p1z : Number;
			var p2x : Number, p2y : Number, p2z : Number;
			for (var i : int = 0; i < iLength; i += 3)
			{
				index = indices[i] * 3;
				p0x = vertices[index];
				p0y = vertices[index + 1];
				p0z = vertices[index + 2];

				index = indices[i + 1] * 3;
				p1x = vertices[index];
				p1y = vertices[index + 1];
				p1z = vertices[index + 2];

				index = indices[i + 2] * 3;
				p2x = vertices[index];
				p2y = vertices[index + 1];
				p2z = vertices[index + 2];

				_v0.setTo(p1x - p0x, p1y - p0y, p1z - p0z);
				_v1.setTo(p2x - p1x, p2y - p1y, p2z - p1z);

				_v2 = _v0.cross(_v1, _v2);
				_v2.normalizeLocal();

				faceNormals[i + 0] = _v2.x;
				faceNormals[i + 1] = _v2.y;
				faceNormals[i + 2] = _v2.z;
			}

			return faceNormals;
		}


		public static function calculateFaceNormal(v0x : Number, v0y : Number, v0z : Number,
			v1x : Number, v1y : Number, v1z : Number,
			v2x : Number, v2y : Number, v2z : Number) : Vector3f
		{
			_v0.setTo(v1x - v0x, v1y - v0y, v1z - v0z);
			_v1.setTo(v2x - v1x, v2y - v1y, v2z - v1z);

			_v2 = _v0.cross(_v1, _v2);
			_v2.normalizeLocal();

			return _v2.clone();
		}

		public static function buildVerexTangents(normals : Vector.<Number>) : Vector.<Number>
		{
			var normalSize : int = normals.length;

			var tangents : Vector.<Number> = new Vector.<Number>(normalSize, true);

			var tangent : Vector3f = new Vector3f();
			var normal : Vector3f = new Vector3f();
			var c1 : Vector3f = new Vector3f();
			var c2 : Vector3f = new Vector3f();
			for (var i : int = 0; i < normalSize; i += 3)
			{
				normal.setTo(normals[i], normals[i + 1], normals[i + 2]);
				normal.cross(Vector3f.Z_AXIS, c1);
				normal.cross(Vector3f.Y_AXIS, c2);

				if (c1.lengthSquared > c2.lengthSquared)
				{
					tangent.copyFrom(c1);
				}
				else
				{
					tangent.copyFrom(c2);
				}

				tangent.normalizeLocal();

				tangents[i] = tangent.x;
				tangents[i + 1] = tangent.y;
				tangents[i + 2] = tangent.z;
			}
			return tangents;
		}
	}
}
