package three.renderers.renderables;
import three.materials.Material;
/**
 * ...
 * @author 
 */

class RenderableLine 
{
	public var v1:RenderableVertex;
	public var v2:RenderableVertex;

	public var material:Material;

	public var z:Float;

	public function new() 
	{
		this.z = null;

		this.v1 = new RenderableVertex();
		this.v2 = new RenderableVertex();

		this.material = null;
	}
	
}