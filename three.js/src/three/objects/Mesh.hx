package three.objects;
import three.core.Geometry;
import three.core.Object3D;
import three.core.BufferGeometry;
import three.materials.Material;
/**
 * ...
 * @author andy
 */

class Mesh extends Object3D
{
	public var geometry:BufferGeometry;
	public var material:Material;

	public function new() 
	{
		super();
	}
	
}