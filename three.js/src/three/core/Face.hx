package three.core;
import three.math.Vector3;
import three.math.Color;
/**
 * ...
 * @author andy
 */

class Face 
{
	public var a:Int;
	public var b:Int;
	public var c:Int;
	
	public var normal:Vector3;
	public var vertexNormals:Array<Vector3>;
	
	public var color:Color;
	public var vertexColors:Array<Vector3>;
	
	public var vertexTangents:Array<Vector3>;

	public var materialIndex:Int;
	
	public var centroid:Vector3;

	public function new() 
	{
		
	}
	
}