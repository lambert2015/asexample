package quake3.bsp;
import nme.geom.Vector3D;
import nme.utils.ByteArray;
import nme.Vector;
import quake3.math.AABBox;

/** 
 * The leafs lump stores the leaves of the map's BSP tree.
 * Each leaf is a convex region that contains, among other things,
 * a cluster index(for determining the other leafs potentially visible from within the leaf),
 * a list of faces(for rendering), and a list of brushes(for collision detection).
 * There are a total of length / sizeof(leaf) records in the lump,
 * where length is the size of the lump itself, as specified in the lump directory.
 */
class BSPLeaf
{
	public var cluster : Int;// The visibility cluster
	public var area : Int;// The area portal
	public var firstLeafFace : Int;// The first index into the leafface array
	public var numLeafFace : Int;// The number of faces for this leaf
	public var firstLeafBrush : Int;// The first index for into the brushes
	public var numLeafBrush : Int;// The number of brushes for this leaf

	public var boundingBox:AABBox;
	
	public function new()
	{
		boundingBox = new AABBox();
	}
}
