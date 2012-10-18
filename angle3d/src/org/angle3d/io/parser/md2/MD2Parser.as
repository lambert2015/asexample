package org.angle3d.io.parser.md2
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.MeshHelper;
	import org.angle3d.scene.mesh.MorphMesh;
	import org.angle3d.scene.mesh.MorphData;
	import org.angle3d.scene.mesh.MorphSubMesh;
	import org.angle3d.utils.Assert;

	public class MD2Parser
	{
		public static const MD2_MAGIC_NUMBER : int = 844121161;
		public static const MD2_VERSION : int = 8;

		public function MD2Parser()
		{
			_header = new MD2Header();
		}

		private var _data : ByteArray;
		private var _header : MD2Header;
		private var _faces : Vector.<int>;
		private var _globalUVs : Vector.<Number>;

		private var _mesh : MorphMesh;
		private var _subMesh : MorphSubMesh;

		private var _lastFrameName : String;

		public function parse(data : ByteArray) : MorphMesh
		{
			_data = data;
			_data.endian = Endian.LITTLE_ENDIAN;
			_data.position = 0;

			_lastFrameName = "";

			_mesh = new MorphMesh();
			_subMesh = new MorphSubMesh();
			_mesh.addSubMesh(_subMesh);

			parseHeader();
			parseUVs();
			parseFaces();
			parseFrames();
			finalize();

			return _mesh;
		}

		private function parseHeader() : void
		{
			var magic : int = _data.readInt();
			var version : int = _data.readInt();

			if (magic != MD2_MAGIC_NUMBER || version != MD2_VERSION)
			{
				Assert.assert(false, "This is not a md2 model");
				return;
			}

			_header.skinWidth = _data.readInt();
			_header.skinHeight = _data.readInt();
			_header.frameSize = _data.readInt();
			_header.numSkins = _data.readInt();
			_header.numVertices = _data.readInt();
			_header.numTexcoords = _data.readInt();
			_header.numFaces = _data.readInt();
			_header.numGlCommands = _data.readInt();
			_header.numFrames = _data.readInt();
			_header.offsetSkins = _data.readInt();
			_header.offsetTexcoords = _data.readInt();
			_header.offsetFaces = _data.readInt();
			_header.offsetFrames = _data.readInt();
			_header.offsetGlCommands = _data.readInt();
			_header.offsetEnd = _data.readInt();

			_mesh.totalFrame = _header.numFrames;
		}

		private function parseUVs() : void
		{
			_data.position = _header.offsetTexcoords;

			var invWidth : Number = 1.0 / _header.skinWidth;
			var invHeight : Number = 1.0 / _header.skinHeight;

			_globalUVs = new Vector.<Number>();
			for (var i : int = 0; i < _header.numTexcoords; i++)
			{
				_globalUVs.push((0.5 + _data.readShort()) * invWidth);
				_globalUVs.push((0.5 + _data.readShort()) * invHeight);
			}
			_globalUVs.fixed = true;
		}

		private function parseFrames() : void
		{
			_data.position = _header.offsetFrames;

			var numVertices : int = _header.numVertices;

			var intVertices : Vector.<int> = new Vector.<int>(numVertices * 3, true);

			var numFrames : int = _header.numFrames;
			for (var i : int = 0; i < numFrames; i++)
			{
				//z 与  y 进行了交换
				var sx : Number = _data.readFloat();
				var sz : Number = _data.readFloat();
				var sy : Number = _data.readFloat();
				var tx : Number = _data.readFloat();
				var tz : Number = _data.readFloat();
				var ty : Number = _data.readFloat();

				var frameName : String = _data.readUTFBytes(16);
				frameName = frameName.replace(/[0-9]/g, '');
				if (frameName != _lastFrameName)
				{
					CF::DEBUG
					{
						trace(frameName);
					}
					_mesh.addAnimation(frameName, i, i);
					_lastFrameName = frameName;
				}
				else
				{
					//同一个动作，改变结束帧即可
					_mesh.getAnimation(frameName).end = i;
				}

				//x,y,z,normalIndex
				for (var j : int = 0; j < numVertices; j++)
				{
					// read vertex
					var vx : int = _data.readUnsignedByte();
					var vz : int = _data.readUnsignedByte();
					var vy : int = _data.readUnsignedByte();
					//normal index
					_data.readUnsignedByte();

					var j3 : int = j * 3;
					intVertices[j3] = vx;
					intVertices[int(j3 + 1)] = vy;
					intVertices[int(j3 + 2)] = vz;
				}

				var vertices : Vector.<Number> = new Vector.<Number>();

				var numFaces : int = _header.numFaces;
				for (var f : int = 0; f < numFaces; f++)
				{
					var f6 : int = f * 6;
					var index : int = _faces[f6] * 3;
					vertices.push(intVertices[index] * sx + tx);
					vertices.push(intVertices[int(index + 1)] * sy + ty);
					vertices.push(intVertices[int(index + 2)] * sz + tz);

					index = _faces[(f6 + 1)] * 3;
					vertices.push(intVertices[index] * sx + tx);
					vertices.push(intVertices[int(index + 1)] * sy + ty);
					vertices.push(intVertices[int(index + 2)] * sz + tz);

					index = _faces[(f6 + 2)] * 3;
					vertices.push(intVertices[index] * sx + tx);
					vertices.push(intVertices[int(index + 1)] * sy + ty);
					vertices.push(intVertices[int(index + 2)] * sz + tz);
				}

				vertices.fixed = true;

				_subMesh.addVertices(vertices);
			}

			intVertices = null;
		}

		private function parseFaces() : void
		{
			_data.position = _header.offsetFaces;

			_faces = new Vector.<int>();
			var numFaces : int = _header.numFaces;
			for (var i : int = 0; i < numFaces; i++)
			{
				_faces.push(_data.readShort());
				_faces.push(_data.readShort());
				_faces.push(_data.readShort());
				_faces.push(_data.readShort());
				_faces.push(_data.readShort());
				_faces.push(_data.readShort());
			}
			_faces.fixed = true;
		}

		private function finalize() : void
		{
			var count : int = _header.numFaces * 3;
			var indices : Vector.<uint> = new Vector.<uint>(count, true);
			for (var f : int = 0; f < count; f++)
			{
				indices[f] = f;
			}

			_subMesh.setIndices(indices);

			var uvData : Vector.<Number> = new Vector.<Number>();
			var numFaces : int = _header.numFaces;
			for (f = 0; f < numFaces; f++)
			{
				var f6 : int = f * 6;
				var uvIndex : int = _faces[int(f6 + 3)] * 2;
				uvData.push(_globalUVs[uvIndex]);
				uvData.push(_globalUVs[int(uvIndex + 1)]);

				uvIndex = _faces[int(f6 + 4)] * 2;
				uvData.push(_globalUVs[uvIndex]);
				uvData.push(_globalUVs[int(uvIndex + 1)]);

				uvIndex = _faces[int(f6 + 5)] * 2;
				uvData.push(_globalUVs[uvIndex]);
				uvData.push(_globalUVs[int(uvIndex + 1)]);
			}

			uvData.fixed = true;

			_faces = null;
			_globalUVs = null;

			_subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, uvData);
			_subMesh.validate();
		}
	}
}

class MD2Header
{
	public var skinWidth : int;
	public var skinHeight : int;
	public var frameSize : int;
	public var numSkins : int;
	public var numVertices : int;
	public var numTexcoords : int;
	public var numFaces : int;
	public var numGlCommands : int;
	public var numFrames : int;
	public var offsetSkins : int;
	public var offsetTexcoords : int;
	public var offsetFaces : int;
	public var offsetFrames : int;
	public var offsetGlCommands : int;
	public var offsetEnd : int;
}
