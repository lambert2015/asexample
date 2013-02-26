package quake3.bsp;

/** 
* The brushes lump stores a set of brushes, which are in turn used for collision detection.
* Each brush describes a convex volume as defined by its surrounding surfaces.
* There are a total of length / sizeof(brushes) records in the lump,
* where length is the size of the lump itself, as specified in the lump directory.
*/
class BSPBrush
{
	public var firstSide : Int;// The starting brush side for the brush
	public var numSides : Int;// Number of brush sides for the brush
	public var shaderIndex : Int;// The texture index for the brush

	public function new()
	{
	}
}
