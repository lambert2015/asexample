package three.renderers.renderables;
import three.materials.Material;
import three.math.Vector3;

/**
 * ...
 * @author 
 */

class RenderableFace3 
{
	public var v1:RenderableVertex;
	public var v2:RenderableVertex;
	public var v3:RenderableVertex;
	
	public var centroidWorld:Vector3;
	public var centroidScreen:Vector3;
	
	public var normalWorld:Vector3;
	public var vertexNormalsWorld:Array<Vector3>;
	
	public var material:Material;
	public var uvs:Array<Array<Float>>;
	
	public var z:Float;

	public function new() 
	{
		this.v1 = new RenderableVertex();
		this.v2 = new RenderableVertex();
		this.v3 = new RenderableVertex();

		this.centroidWorld = new Vector3();
		this.centroidScreen = new Vector3();

		this.normalWorld = new Vector3();
		this.vertexNormalsWorld = [new Vector3(), new Vector3(), new Vector3()];

		this.material = null;
		this.uvs = [[]];

		this.z = null;
	}
	
}