package org.angle3d.io.parser.max3ds
{
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;

	internal class Max3DSMeshParser extends AbstractMax3DSParser
	{
		private static const TRANSFORM:Matrix3D=new Matrix3D(Vector.<Number>([1., 0., 0., 0., 0., 0., -1., 0., 0., 1., 0., 0., 0., 0., 0., 1.]));

		private var _vertices:Vector.<Number>=null;
		private var _indices:Vector.<uint>=null;
		private var _uvData:Vector.<Number>=null;
		private var _matrix:Matrix3D=new Matrix3D();

		private var _materials:Object=new Object();

		private var _mappedFaces:Vector.<int>=new Vector.<int>();

		private var _name:String;

		public function Max3DSMeshParser(chunk:Max3DSChunk, name:String)
		{
			super(chunk);
			this.name=name;
		}


		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name=value;
		}

		public function get vertices():Vector.<Number>
		{
			return _vertices;
		}

		public function get uvData():Vector.<Number>
		{
			return _uvData;
		}

		public function get indices():Vector.<uint>
		{
			return _indices;
		}

		public function get materials():Object
		{
			return _materials;
		}

		override protected function initialize():void
		{
			super.initialize();

			parseFunctions[Max3DSChunk.MESH]=enterChunk;
			parseFunctions[Max3DSChunk.MESH_VERTICES]=parseVertices;
			parseFunctions[Max3DSChunk.MESH_INDICES]=parseIndices;
			parseFunctions[Max3DSChunk.MESH_MAPPING]=parseUVData;
			parseFunctions[Max3DSChunk.MESH_MATERIAL]=parseMaterial;
			parseFunctions[Max3DSChunk.MESH_MATRIX]=parseMatrix;
		}

		override protected function finalize():void
		{
			super.finalize();

			var tmpVertices:Vector.<Number>=new Vector.<Number>();

			TRANSFORM.transformVectors(_vertices, tmpVertices);
			/*_vertices.length = 0;
			_matrix.transformVectors(tmpVertices, _vertices);*/
			_vertices=tmpVertices;
		}

		private function parseVertices(chunk:Max3DSChunk):void
		{
			var data:ByteArray=chunk.data;

			var nbVertices:int=data.readUnsignedShort() * 3;

			_vertices=new Vector.<Number>(nbVertices);
			for (var i:int=0; i < nbVertices; i+=3)
			{
				_vertices[i]=data.readFloat();
				_vertices[int(i + 1)]=data.readFloat();
				_vertices[int(i + 2)]=data.readFloat();
			}
		}

		private function parseIndices(chunk:Max3DSChunk):void
		{
			var data:ByteArray=chunk.data;
			var nbFaces:int=data.readUnsignedShort() * 3;

			_indices=new Vector.<uint>(nbFaces, true)
			for (var i:int=0; i < nbFaces; i+=3)
			{
				_indices[i]=data.readUnsignedShort();
				_indices[int(i + 1)]=data.readUnsignedShort();
				_indices[int(i + 2)]=data.readUnsignedShort();

				data.position+=2;
			}
		}

		private function parseUVData(chunk:Max3DSChunk):void
		{
			var data:ByteArray=chunk.data;

			var nbCoordinates:int=data.readUnsignedShort() * 2;

			_uvData=new Vector.<Number>(nbCoordinates, true);
			for (var i:int=0; i < nbCoordinates; i+=2)
			{
				_uvData[i]=data.readFloat();
				_uvData[int(i + 1)]=1. - data.readFloat();
			}
		}

		private function parseMaterial(chunk:Max3DSChunk):void
		{
			var data:ByteArray=chunk.data;

			var name:String=chunk.readString();

			var nbFaces:int=data.readUnsignedShort();
			var indices:Vector.<uint>=new Vector.<uint>();
			for (var i:int=0; i < nbFaces; i++)
			{
				var faceId:int=data.readUnsignedShort() * 3;

				indices.push(_indices[faceId], _indices[int(faceId + 1)], _indices[int(faceId + 2)]);
			}

			if (nbFaces)
				_materials[name]=indices;
		}

		private function parseMatrix(chunk:Max3DSChunk):void
		{
			var data:ByteArray=chunk.data;
			var tmp:Vector.<Number>=new Vector.<Number>(16, true);

			for (var j:int=0; j < 12; j++)
				tmp[j]=data.readFloat();

			tmp[15]=1.;
			_matrix.copyRawDataFrom(tmp);
			//_matrix.transpose();
		}
	}
}
