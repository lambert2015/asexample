package org.angle3d.io.parser.max3ds
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import org.angle3d.io.parser.ParserOptions;
	import org.angle3d.material.MaterialFill;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.MeshHelper;
	import org.angle3d.scene.mesh.SubMesh;

	public class Max3DSParser extends AbstractMax3DSParser //implements IParser
	{
		protected var _materials:Object;
		protected var _options:ParserOptions;

		private var _mesh:Mesh;

		public function Max3DSParser()
		{
			super();
		}

		public function get mesh():Mesh
		{
			return _mesh;
		}

		override protected function initialize():void
		{
			super.initialize();

			parseFunctions[Max3DSChunk.PRIMARY] = parsePrimary;
			parseFunctions[Max3DSChunk.SCENE] = enterChunk;
			parseFunctions[Max3DSChunk.MATERIAL] = parseMaterial;
			parseFunctions[Max3DSChunk.OBJECT] = parseObject;
		}

		public function parse(data:ByteArray, options:ParserOptions):Mesh
		{
			data.endian = Endian.LITTLE_ENDIAN;
			data.position = 0;

			if (data.readUnsignedShort() != Max3DSChunk.PRIMARY)
				return null;

			_materials = new Object();
			_options = options;

			_mesh = new Mesh();

			data.position = 0;
			parseChunk(new Max3DSChunk(data));

			return _mesh;
		}

		protected function parsePrimary(chunk:Max3DSChunk):void
		{
			// throw an error if the first chunk is not a primary chunk
		/*if (chunk.identifier != Max3DSChunk.PRIMARY)
			throw new Error("Wrong file format!");*/
		}

		protected function parseObject(chunk:Max3DSChunk):void
		{
			var name:String = chunk.readString();

			trace("object name:" + name);

			chunk = new Max3DSChunk(chunk.data);

			if (chunk.identifier == Max3DSChunk.MESH)
			{
				var parser:Max3DSMeshParser = new Max3DSMeshParser(chunk, name);

				var objectMaterials:Object = parser.materials;

				for (var materialName:String in objectMaterials)
				{
					var subMesh:SubMesh = new SubMesh();

					subMesh.setVertexBuffer(BufferType.POSITION, 3, parser.vertices);
					subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, parser.uvData);
					var indices:Vector.<uint> = objectMaterials[materialName];
					var normals:Vector.<Number> = MeshHelper.buildVertexNormals(indices, parser.vertices);
					subMesh.setVertexBuffer(BufferType.NORMAL, 3, normals);
					subMesh.setIndices(indices);
					subMesh.validate();
					_mesh.addSubMesh(subMesh);

//					var group : IGroup = getMaterialGroup(materialName);
//
//					if (!group)
//					{
//						throw new Error("Unable to find material named '"
//							+ materialName + "'.");
//					}
//
//					var textureFilename : String = _materials[materialName].textureFilename;
//					var vstream : VertexStream = VertexStream.fromPositionsAndUVs(parser.vertices, parser.uvData, _options.keepStreamsDynamic);
//					var scene : IScene = new Max3DSMesh(new VertexStreamList(vstream),
//						new IndexStream(objectMaterials[materialName], 0, _options.keepStreamsDynamic),
//						name,
//						materialName,
//						textureFilename);
//
//					scene = _options.replaceNodeFunction(scene);
//					group.addChild(scene);
				}
			}
			else
			{
				chunk.skip();
			}
		}

//		protected function getMaterialGroup(materialName : String) : Group
//		{
//			for (var i : int = 0; i < _data.length && _data[i].name != materialName; ++i)
//				continue;
//
//			return i < _data.length ? Group(_data[i]) : null;
//		}

		protected function parseMaterial(chunk:Max3DSChunk):void
		{

			var material:Max3DSMaterialParser = new Max3DSMaterialParser(chunk);
			trace("material:" + material.name);
			trace("material.textureFilename:" + material.textureFilename);

			if (_materials[material.name] == undefined)
				_materials[material.name] = material;

			var loadTextures:Boolean = _options ? _options.loadTextures : false;
//			var group : Group = getMaterialGroup(material.name);
//			var texture : IScene = null;
//
//			if (!group)
//			{
//				if (loadTextures)
//				{
//					var textureFilename : String = material.textureFilename;
//
//					if (textureFilename != null)
//						textureFilename = _options.rewritePathFunction(textureFilename);
//
//					if (textureFilename)
//					{
//						texture = _options.loadFunction(new URLRequest(textureFilename), _options);
//
//						texture.name = material.name;
//						if (texture is LoaderGroup)
//						{
//							var loader : LoaderGroup = texture as LoaderGroup;
//
//							if (!_markedLoader[loader] && loader.numLoadedItems != loader.numTotalItems)
//							{
//								_markedLoader[loader] = true;
//								loader.addEventListener(Event.COMPLETE, textureCompleteHandler);
//								++_total;
//							}
//						}
//					}
//				}
//
//				group = _options.replaceNodeFunction(new StyleGroup());
//				if (texture)
//					group.addChild(texture);
//
//				group.name = material.name;
//				_data.push(group);
//
//				_materials[material.name] = material;
//			}
		}

		override protected function finalize():void
		{
//			if (_options && _options.mergeMeshes)
//			{
//				var numMaterials : int = _data.length;
//				var meshes : Vector.<IMesh> = new Vector.<IMesh>();
//
//				for (var i : int = 0; i < numMaterials; ++i)
//				{
//					var materialGroup : Group = _data[i] as Group;
//					var texture : IScene = materialGroup.getChildAt(0);
//
//					meshes.length = 0;
//
//					for each (var child : IScene in materialGroup)
//						if (child is IMesh)
//							meshes.push(child as IMesh);
//
//					materialGroup.removeAllChildren();
//					if (texture && !(texture is IMesh))
//						materialGroup.addChild(texture);
//					if (meshes.length)
//					{
//						var mergedMesh : IMesh = Mesh.merge(meshes);
//
//						mergedMesh = _options.replaceNodeFunction(mergedMesh);
//						materialGroup.addChild(mergedMesh);
//					}
//				}
//			}
		}
	}
}
