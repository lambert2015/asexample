package quake3.bsp;
/**
* The visdata lump stores bit vectors that provide cluster-to-cluster visibility information.
* There is exactly one visdata record, with a length equal to that specified in the lump directory.
* Cluster x is visible from cluster y if the(1 <<y % 8) bit of vecs[x * sz_vecs + y / 8] is set.
* Note that clusters are associated with leaves.
*/

class BSPVisData
{
	public var size : Int;
	public var buffer : Array<Int>;
	
	public function new()
	{
	}
}
