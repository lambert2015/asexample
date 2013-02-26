package quake3.bsp;
import flash.geom.Vector3D;
import flash.utils.ByteArray;
import flash.Vector;
import quake3.math.AABBox;
/**
* The nodes lump stores all of the nodes in the map's BSP tree.
* The BSP tree is used primarily as a spatial subdivision scheme,
* dividing the world into convex regions called leafs.
* The first node in the lump is the tree's root node.
*/
class BSPNode
{
	public var plane : Int;// The index into the planes array
	
	public var front:Int;
	
	public var back:Int;
	
	public var boundingBox:AABBox;
	
	public function new()
	{
	}
}
