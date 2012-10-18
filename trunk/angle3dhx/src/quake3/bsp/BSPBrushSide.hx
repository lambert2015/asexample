package quake3.bsp;
import flash.utils.ByteArray;
/**
* The brushsides lump stores descriptions of brush bounding surfaces.
* There are a total of length / sizeof(brushsides) records in the lump,
* where length is the size of the lump itself, as specified in the lump directory.
*/
class BSPBrushSide
{
	public var planeIndex : Int;// The plane index
	public var shaderIndex : Int;// The shader index

	public function new()
	{
	}
}
