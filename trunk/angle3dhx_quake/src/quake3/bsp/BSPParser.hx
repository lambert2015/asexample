package quake3.bsp;

import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.geom.Vector3D;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.utils.RegExp;
import flash.utils.Timer;
import flash.Vector;
import quake3.bsp.BitSet;
import quake3.bsp.BSP;
import quake3.bsp.BSPBezier;
import quake3.bsp.BSPBrush;
import quake3.bsp.BSPBrushSide;
import quake3.bsp.BSPFace;
import quake3.bsp.BSPLeaf;
import quake3.bsp.BSPNode;
import quake3.bsp.BSPShader;
import quake3.bsp.BSPVisData;
import quake3.core.Vertex;
import quake3.events.BSPParseEvent;
import quake3.material.TextureManager;
import quake3.math.AABBox;
import quake3.math.Color;
import quake3.math.Plane3D;
import quake3.core.SubGeometry;

class BSPParser extends EventDispatcher
{
	private var _currentStep:Int;
	private var _timer:Timer;

	private var _directory:String;
	private var _byteArray:ByteArray;
	
	private var _bsp:BSP;
	private var _shaders:Vector<BSPShader>;
	private var _vertices:Vector<Vertex>;
	private var _meshIndices:Vector<Int>;
	private var _lumps : Vector<BSPLump>;

	private var _curveTessellation:Int;
	private var _bezier:BSPBezier;

	/**
	 * 
	 * @param	directory 资源所在目录
	 * @param	curveTessellation 
	 */
	public function new(directory:String, ?curveTessellation:Int = 5)
	{
		super();
		_directory = directory;
		_curveTessellation = curveTessellation;
		_bezier = new BSPBezier();
	}

	public function parse(data:ByteArray):Void
	{
		if (data == null)
		    return;
			
		_byteArray = data;
		_byteArray.endian = Endian.LITTLE_ENDIAN;
		_byteArray.position = 0;
		
		_bsp = new BSP();
		
		_currentStep = 0;
		if (_timer != null)
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _timerHandler);
		}
		_timer = new Timer(100);
		_timer.addEventListener(TimerEvent.TIMER, _timerHandler,false,0,true);
		_timer.start();
	}
	
	public function getBSP():BSP
	{
		return _bsp;
	}

	private function _timerHandler(e:TimerEvent):Void
	{
		switch(_currentStep)
		{
			case 0:
			      readHeader();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "read bsp header"));
			case 1:
			      _bsp.shaders = readShaders();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "read Shaders"));
			case 2:
				  readLightmaps();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "readLightmaps"));  
			case 3:
			      _vertices = readVertices();
				  _bsp.setVertices(_vertices);
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "readVertices"));
			case 4:
			      _bsp.faces = readFaces();
				  _bsp.planes = readPlanes();
				  _bsp.nodes = readNodes();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "readFaces,Planes And Nodes"));
			case 5:
			      _bsp.leaves = readLeaves();
				  _bsp.leafFaces = readLeafFaces();
				  _bsp.visData = readVisData();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "readLeafs & VisData")); 
			case 6:
			      _bsp.entities = readEntities();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "readEntities"));
			case 7:
			      _meshIndices = readMeshIndices();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "readMeshIndices"));
			case 8:
			      _bsp.brushes = readBrushes();
				  _bsp.brushSides = readBrushSides();
				  _bsp.leafBrushes = readLeafBrushes();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.PROGRESS, "readBrushes"));
			case 9:
			      compileMap();
				  cleanup();
				  dispatchEvent(new BSPParseEvent(BSPParseEvent.COMPLETE, "Parse Complete"));
		}
		_currentStep++;
	}
	
	private function readHeader() : Void
	{
		_byteArray.position = 0;
		
		// Read the Header This should always be 'IBSP' & be 0x2e for Quake 3 files
		if(_byteArray.readInt() != 0x50534249 || _byteArray.readInt() != 0x2E)
		{
			dispatchEvent(new BSPParseEvent(BSPParseEvent.ERROR, "Parse Error,It`s not a Quake 3 file"));
			return;
		}

		// now read the header lumps
		_lumps = new Vector<BSPLump>(17,true);
		for(i in 0...17)
		{
			var lump : BSPLump = new BSPLump();
			lump.offset = _byteArray.readInt();
		    lump.length = _byteArray.readInt();
			_lumps[i] = lump;
		}
	}
	
	private function cleanup() : Void
	{
		if(_timer != null)
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			_timer = null;
			_currentStep = 0;
		}
		_byteArray.clear();
		_byteArray = null;
		_lumps = null;
		_vertices = null;
		_meshIndices = null;
	}
    
	/**
	 * 读取贴图
	 */
	private function readShaders() : Vector<BSPShader>
	{
		var lump:BSPLump = _lumps[LUMPS.Textures];
		var count:Int = Std.int(lump.length / 72);
		
		_byteArray.position = lump.offset;
		
		var elements:Vector<BSPShader> = new Vector<BSPShader>();
		for(i in 0...count)
		{
			var element:BSPShader = new BSPShader();
			element.shaderName = _byteArray.readUTFBytes(64);
			element.flags = _byteArray.readUnsignedInt();
			element.contents = _byteArray.readUnsignedInt();
			element.shader = null;
			element.faces = new Vector<BSPFace>();
			element.indexOffset = 0;
			element.elementCount = 0;
			element.visible = true;
			
			TextureManager.getInstance().loadTexture(_directory+element.shaderName+".png",element.shaderName);
			
			elements[i] = element;
		}
		return elements;
	}
    
	/**
	 * 加载光照图
	 */
	private function readLightmaps() : Void
	{
		var lump:BSPLump = _lumps[LUMPS.Lightmaps];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / (128 * 128 * 3));

		var color:Color = new Color();

		var data:Vector<UInt>=new Vector<UInt>(16384,true);
		for(i in 0...count)
		{
			var bitmapData:BitmapData = new BitmapData(128, 128, false, 0x0);
			for(i in 0...16384)
			{
				// get rgb and brighter
				var r : Float = _byteArray.readUnsignedByte() / 0xFF;
				var g : Float = _byteArray.readUnsignedByte() / 0xFF;
				var b : Float = _byteArray.readUnsignedByte() / 0xFF;
				
				color.setRGBA(r, g, b, 1);
				
				brightnessAdjust(color, 4.0);
				
				data[i] = color.getColor();
			}
			
			bitmapData.setVector(bitmapData.rect, data);
			
			TextureManager.getInstance().addTexture(bitmapData, "lightmap_" + i);
		}
	}
	
	/**
	 * 加载顶点数据
	 */
	private function readVertices() : Vector<Vertex>
	{ 
		var lump:BSPLump = _lumps[LUMPS.Vertices];
		var count:Int = Std.int(lump.length / 44);
		
		_byteArray.position = lump.offset;
		
		var color:Color = new Color();
		
		var vertices:Vector<Vertex> = new Vector<Vertex>();
		for(i in 0...count)
		{
			var vertex : Vertex = new Vertex();
			vertex.x = _byteArray.readFloat();
			vertex.y = _byteArray.readFloat();
			vertex.z = _byteArray.readFloat();

			vertex.u = _byteArray.readFloat();
			vertex.v = _byteArray.readFloat();

			vertex.u2 = _byteArray.readFloat();
			vertex.v2 = _byteArray.readFloat();

			vertex.nx = _byteArray.readFloat();
			vertex.ny = _byteArray.readFloat();
			vertex.nz = _byteArray.readFloat();

			vertex.setColor(_byteArray.readUnsignedInt());
			
			vertices[i] = vertex;
		}
		return vertices;
	}
	
	/**
	 * Read all face structures
	 */
	private function readFaces() : Vector<BSPFace>
	{
		var lump:BSPLump = _lumps[LUMPS.Faces];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 104);
		
		_bsp.facesSet = new BitSet(count);
		
		var faces:Vector<BSPFace> = new Vector<BSPFace>();
		for(i in 0...count)
		{
			var face : BSPFace = new BSPFace();
			face.shader = _byteArray.readInt();//贴图id
			face.effect = _byteArray.readInt();//
			face.type = _byteArray.readInt();//
			face.firstVertexIndex = _byteArray.readInt();//
			face.numVertices = _byteArray.readInt();//顶点数
			face.firstMeshIndex = _byteArray.readInt();//
			face.numMeshIndices = _byteArray.readInt();//
			face.lightmapIndex = _byteArray.readInt();//光照图id
			
			//face.lmStart = new Point(_byteArray.readInt(), _byteArray.readInt());
			//face.lmSize = new Point(_byteArray.readInt(), _byteArray.readInt());
			//face.lmOrigin = new Vector3D(_byteArray.readFloat(), _byteArray.readFloat(), _byteArray.readFloat());
			//face.sTangent = new Vector3D(_byteArray.readFloat(), _byteArray.readFloat(), _byteArray.readFloat());
			//face.tTangent = new Vector3D(_byteArray.readFloat(), _byteArray.readFloat(), _byteArray.readFloat());
			//face.normal = new Vector3D(_byteArray.readFloat(), _byteArray.readFloat(), _byteArray.readFloat());
			
			_byteArray.position += 16 * 4;
			
			face.width = _byteArray.readInt();
			face.height = _byteArray.readInt();
			faces[i] = face;
		}
		
		faces.fixed = true;
		return faces;
	}
	
	/**
	* Read all Plane structures
	*/
	private function readPlanes() : Vector<Plane3D>
	{
		var lump:BSPLump = _lumps[LUMPS.Planes];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 16);
		var planes:Vector<Plane3D> = new Vector<Plane3D>(count,true);
		for(i in 0...count)
		{
			var x : Float = _byteArray.readFloat();
			var y : Float = _byteArray.readFloat();
			var z : Float = _byteArray.readFloat();
			var d : Float = _byteArray.readFloat();
			planes[i] = new Plane3D(new Vector3D(x, y, z) , d);
		}
		return planes;
	}
	/**
	* Read all Node structures
	*/
	private function readNodes() : Vector<BSPNode>
	{
		var lump:BSPLump = _lumps[LUMPS.Nodes];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 36);
		var nodes:Vector<BSPNode> = new Vector<BSPNode>(count,true);
		for(i in 0...count)
		{
			var node : BSPNode = new BSPNode();
			node.plane = _byteArray.readInt();
			
			// The child index for the front node
			node.front = _byteArray.readInt();
			
			// The child index for the back node
			node.back = _byteArray.readInt();
			
			// The bounding box
			node.boundingBox = new AABBox();
			node.boundingBox.addInternalXYZ(_byteArray.readInt(), _byteArray.readInt(), _byteArray.readInt());
			node.boundingBox.addInternalXYZ(_byteArray.readInt(), _byteArray.readInt(), _byteArray.readInt());
			
			nodes[i] = node;
		}
		return nodes;
	}
	/**
	 * Read all Leaf structures
	 * @return
	 */
	private function readLeaves() : Vector<BSPLeaf>
	{
		var lump:BSPLump = _lumps[LUMPS.Leaves];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 48);
		var leaves:Vector<BSPLeaf> = new Vector<BSPLeaf>(count, true);
		for(i in 0...count)
		{
			var leaf : BSPLeaf = new BSPLeaf();

			leaf.cluster = _byteArray.readInt();
			leaf.area = _byteArray.readInt();
			leaf.boundingBox.addInternalXYZ(_byteArray.readInt(), _byteArray.readInt(), _byteArray.readInt());
			leaf.boundingBox.addInternalXYZ(_byteArray.readInt(), _byteArray.readInt(), _byteArray.readInt());
			leaf.firstLeafFace = _byteArray.readInt();
			leaf.numLeafFace = _byteArray.readInt();
			leaf.firstLeafBrush = _byteArray.readInt();
			leaf.numLeafBrush = _byteArray.readInt();
		
			leaves[i] = leaf;
		}
		return leaves;
	}
	/**
 	* Read all Leaf Faces
 	* @return
 	*/
	private function readLeafFaces() : Vector<Int>
	{
		var lump:BSPLump = _lumps[LUMPS.LeafFaces];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 4);
		var leafFaces:Vector<Int> = new Vector<Int>(count,true);
		for(i in 0...count)
		{
			leafFaces[i] = _byteArray.readInt();
		}
		return leafFaces;
	}
	
	/**
	*  function: readEntities
	*  Entities are stored as text in the following format
	* 	{
	* 	"classname" "light"
	* 	"light" "125"
	* 	"_color" "0.75 0.5 0.25"
	* 	"origin" "1920 1344 290"
	* 	}
	*
	*/
	private function readEntities() : Dynamic
	{
		var lump:BSPLump = _lumps[LUMPS.Entities];
		// seek to offset
		_byteArray.position = lump.offset;
		
		var elements:Dynamic = { 
			 targets: {}
			};

		// read entity data into string
		var entitySrc : String = _byteArray.readUTFBytes(lump.length);

		var reg:RegExp = new RegExp("\\{([^}]*)\\}", "mg");
		var list:Dynamic = reg.exec(entitySrc);
		while (list != null)
		{
			// make new entity
			var entity:Dynamic = {
                                  classname: 'unknown'
                                 };

			var reg1:RegExp = new RegExp('"(.+)" "(.+)"$', "mg");
			var list1:Array<String> = reg1.exec(list[1]);
			
			while (list1 != null)
			{
				var key:String = list1[1];
				var value:String = list1[2];
				switch(key)
            	{
                	case 'origin':
						var reg2:RegExp = new RegExp('(.+) (.+) (.+)', "");
						var list2:Array<String> = reg2.exec(list1[2]);
					    var pos:Vector3D = new Vector3D(Std.parseFloat(list2[1]), 
								                        Std.parseFloat(list2[2]), 
														Std.parseFloat(list2[3]));
						untyped entity[key] = pos;
                	case 'angle':
					    untyped entity[key] = Std.parseFloat(value);
                	default:
                        untyped entity[key] = value;
            	}
				
				list1 = reg1.exec(list[1]);
			}
			
			if(entity.targetname != null)
        	{
            	elements.targets[entity.targetname] = entity;
        	}

        	if(elements[entity.classname] == null)
        	{
            	elements[entity.classname] = [];
        	}
			
        	elements[entity.classname].push(entity);
			
			
			list = reg.exec(entitySrc);
		}

		return elements;
	}

	private function readMeshIndices() : Vector<Int>
	{
		var lump:BSPLump = _lumps[LUMPS.MeshIndices];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 4);
		var meshIndices:Vector<Int> = new Vector<Int>(count,true);
		for(i in 0...count)
		{
			meshIndices[i] = _byteArray.readInt();
		}
		return meshIndices;
	}
	/**
	 * Read all Brushes
	 * @return
	 */
	private function readBrushes() : Vector<BSPBrush>
	{
		var lump:BSPLump = _lumps[LUMPS.Brushes];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 12);
		var brushes:Vector<BSPBrush> = new Vector<BSPBrush>(count,true);
		for(i in 0...count)
		{
			var brush : BSPBrush = new BSPBrush();
			brush.firstSide = _byteArray.readInt();
			brush.numSides = _byteArray.readInt();
			brush.shaderIndex = _byteArray.readInt();
			brushes[i] = brush;
		}
		return brushes;
	}
	/**
	 * Read all Leaf Brushes
	 * @return
	 */
	private function readLeafBrushes() : Vector<Int>
	{
		var lump:BSPLump = _lumps[LUMPS.LeafBrushes];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 4);
		var leafBrushes:Vector<Int> = new Vector<Int>(count,true);
		for(i in 0...count)
		{
			leafBrushes[i] = _byteArray.readInt();
		}
		return leafBrushes;
	}
	/**
	 * Read all Brush Sides
	 * @return
	 */
	private function readBrushSides() : Vector<BSPBrushSide>
	{
		var lump:BSPLump = _lumps[LUMPS.BrushSides];
		_byteArray.position = lump.offset;
		
		var count:Int = Std.int(lump.length / 8);
		var brusheSides:Vector<BSPBrushSide> = new Vector<BSPBrushSide>(count,true);
		for(i in 0...count)
		{
			var brushSide : BSPBrushSide = new BSPBrushSide();
			brushSide.planeIndex = _byteArray.readInt();
			brushSide.shaderIndex = _byteArray.readInt();
			brusheSides[i] = brushSide;
		}
		return brusheSides;
	}
	
	private function readVisData() : BSPVisData
	{
		var lump:BSPLump = _lumps[LUMPS.VisData];
		_byteArray.position = lump.offset;
		
		var visData:BSPVisData = new BSPVisData();
		
		var vecCount:Int = _byteArray.readInt();
		var size:Int = _byteArray.readInt();
	
		var byteCount:Int = vecCount * size;
		var elements:Array<Int> = new Array<Int>();
	
		for(i in 0...byteCount) {
			elements[i] = _byteArray.readByte();
		}
	    
		visData.buffer = elements;
		visData.size = size;
		
		return visData;
	}
	
	private function brightnessAdjust(color:Color, factor:Float):Void
	{
		var scale:Float = 1.0; 
		var temp:Float = 0.0;
	
		color.r *= factor;
		color.g *= factor;
		color.b *= factor;
	
		if (color.r > 1 && (temp = 1 / color.r) < scale) scale = temp;
		if (color.g > 1 && (temp = 1 / color.g) < scale) scale = temp;
		if (color.b > 1 && (temp = 1 / color.b) < scale) scale = temp;
	
		color.r *= scale;
		color.g *= scale;
		color.b *= scale;
	}
	
	private function createPolygon(face:BSPFace) : Void
	{
		//skip this face if it has fewer than 3 vertices
		if (face.numVertices < 3)
		{
			return;
		}
			
		var geometry : SubGeometry = new SubGeometry();

		if(face.shader >= 0)
		{
			geometry.material.addTextureNameAt(_bsp.shaders[face.shader].shaderName,0);
		}

		if(face.lightmapIndex >= 0)
		{
			geometry.material.addTextureNameAt("lightmap_"+face.lightmapIndex, 1);
		}

		var g_indices : Vector<UInt> = geometry.indices;
		var vertex:Vertex;
		for(j in 0...face.numMeshIndices)
		{
			g_indices.push(_meshIndices[(face.firstMeshIndex + j)] + face.firstVertexIndex);
		}

		face.geometry = geometry;
		
		_bsp.group.addSubGeometry(geometry);
	}

	private function createMesh(face:BSPFace):Void
	{
		//skip this face if it has fewer than 3 vertices
		if (face.numVertices < 3)
		{
			return;
		}
		
		var geometry : SubGeometry = new SubGeometry();

		if(face.shader >= 0)
		{
			geometry.material.addTextureNameAt(_bsp.shaders[face.shader].shaderName,0);
		}
		
		if(face.lightmapIndex >= 0)
		{
			geometry.material.addTextureNameAt("lightmap_"+face.lightmapIndex, 1);
		}

		var g_indices : Vector<UInt> = geometry.indices;  
		for(j in 0...face.numMeshIndices)
		{
			g_indices.push(_meshIndices[j + face.firstMeshIndex]+face.firstVertexIndex);
		}
		face.geometry = geometry;
		_bsp.group.addSubGeometry(geometry);
	}
	
	private function createPatch(face:BSPFace):Void
	{
		if(face.width == 0 || face.height == 0)
		{
			return;
		}

		var geometry : SubGeometry = new SubGeometry();

		if(face.shader >= 0)
		{
			geometry.material.addTextureNameAt(_bsp.shaders[face.shader].shaderName,0);
		}
		
		if(face.lightmapIndex >= 0)
		{
			geometry.material.addTextureNameAt("lightmap_"+face.lightmapIndex, 1);
		}

		// number of biquadratic patches
		var biquadWidth = Math.round((face.width - 1) / 2);
		var biquadHeight = Math.round((face.height - 1) / 2);

		var len :Int = face.width * face.height;
		var controlPoints:Vector<Vertex> = new Vector<Vertex>(len, true);
		for(j in 0...len)
		{
			controlPoints[j] = _vertices[face.firstVertexIndex + j];
		}
			
		_bezier.setData(geometry, _vertices);
		//Loop through the biquadratic patches
        for( j in 0...biquadHeight)
	    {
		    for( k in 0...biquadWidth)
		   	{
		    	// set up this patch
		    	var inx:Int = j * face.width * 2 + k * 2;

			   	// setup bezier control points for this patch
		    	_bezier.control[0].copy(controlPoints[inx + 0]);
		    	_bezier.control[1].copy(controlPoints[inx + 1]);
		    	_bezier.control[2].copy(controlPoints[inx + 2]);
		    	_bezier.control[3].copy(controlPoints[inx + face.width + 0 ]);
		    	_bezier.control[4].copy(controlPoints[inx + face.width + 1 ]);
		    	_bezier.control[5].copy(controlPoints[inx + face.width + 2 ]);
		    	_bezier.control[6].copy(controlPoints[inx + face.width * 2 + 0]);
		    	_bezier.control[7].copy(controlPoints[inx + face.width * 2 + 1]);
		    	_bezier.control[8].copy(controlPoints[inx + face.width * 2 + 2]);

		    	_bezier.tesselate(_curveTessellation);
		   	}
	    }

		face.geometry = geometry;
		_bsp.group.addSubGeometry(geometry);
	}
	
	private function createBillboard(face:BSPFace):Void
	{
		//TODO
	}
	
	/**
	 * 生成最终渲染需要的数据
	 */
	private function compileMap():Void
	{
		var faces:Vector<BSPFace> = _bsp.faces;
		for(i in 0...faces.length)
		{
			var face : BSPFace = faces[i];

			switch(face.type)
			{
				case BSPFace.POLYGON:
					createPolygon(face);
				case BSPFace.MESH:
					createMesh(face);
				case BSPFace.PATCH:
					createPatch(face);
				case BSPFace.BILLBOARD:
					createBillboard(face);
			}
		}
	}
}

class LUMPS
{
	public static inline var Entities     : Int = 0;// Stores player/object positions, etc...
	public static inline var Textures     : Int = 1;// Stores texture information
	public static inline var Planes       : Int = 2;// Stores the splitting planes
	public static inline var Nodes        : Int = 3;// Stores the BSP nodes
	public static inline var Leaves       : Int = 4;// Stores the leafs of the nodes
	public static inline var LeafFaces    : Int = 5;// Stores the leaf's indices into the faces
	public static inline var LeafBrushes  : Int = 6;// Stores the leaf's indices into the brushes
	public static inline var Models       : Int = 7;// Stores the info of world models
	public static inline var Brushes      : Int = 8;// Stores the brushes info(for collision)
	public static inline var BrushSides   : Int = 9;// Stores the brush surfaces info
	public static inline var Vertices     : Int = 10;// Stores the level vertices
	public static inline var MeshIndices  : Int = 11;// Stores the model vertices offsets
	public static inline var Shaders      : Int = 12;// Stores the shader files(blend(ing, anims..)
	public static inline var Faces        : Int = 13;// Stores the faces for the level
	public static inline var Lightmaps    : Int = 14;// Stores the lightmaps for the level
	public static inline var LightVolumes : Int = 15;// Stores extra world lighting information
	public static inline var VisData      : Int = 16;// Stores PVS and cluster info(visibility)
}

class BSPLump
{
	public var offset : Int;
	public var length : Int;
	public function new()
	{
	}
}