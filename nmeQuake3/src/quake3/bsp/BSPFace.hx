package quake3.bsp;
import nme.geom.Point;
import nme.geom.Vector3D;
import nme.utils.ByteArray;
import nme.Vector;
import quake3.core.IGeometry;
/**
* A Quake3 face
* Because a face may protrude out of the leaf, the same face may be in multiple leaves
*/
class BSPFace
{
	public static inline var POLYGON  :Int = 1;
	public static inline var PATCH    :Int = 2;
	public static inline var MESH     :Int = 3;
	public static inline var BILLBOARD:Int = 4;
	
	public var shader : Int;// The index into the texture array
	public var effect : Int;// The index for the effects(or -1 = n/a)
	public var type : Int;// 1=polygon, 2=patch, 3=mesh, 4=billboard
	public var firstVertexIndex : Int;// The index into this face's first vertex
	public var numVertices : Int;// The number of vertices for this face
	public var firstMeshIndex : Int;// The index into the first meshvertex
	public var numMeshIndices : Int;// The number of mesh vertices
	public var lightmapIndex : Int;// The texture index for the lightmap
	
	//public var lmStart:Point;
	//public var lmSize:Point;
	//public var lmOrigin:Vector3D;
	//public var sTangent:Vector3D;
	//public var tTangent:Vector3D;
	//public var normal:Vector3D;
	public var width:Int;
	public var height:Int;

	public var geometry:IGeometry;

	public function new()
	{
	}
	
	public function setVisible(value:Bool):Void
	{
		if (geometry != null)
		    geometry.setVisible(value);
	}
	
	public function isVisible():Bool
	{
		if (geometry != null)
		    return geometry.isVisible();
		return false;
	}
}
