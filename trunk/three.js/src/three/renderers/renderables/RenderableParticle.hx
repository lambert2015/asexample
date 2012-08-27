package three.renderers.renderables;
import three.core.Object3D;
import three.math.Vector3;
import three.math.Vector2;
import three.materials.Material;
/**
 * ...
 * @author 
 */

class RenderableParticle 
{
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	public var rotation:Float;
	public var scale:Vector2;
	
	public var material:Material;
	
	public var object:Object3D;

	public function new() 
	{
		this.object = null;

		this.x = null;
		this.y = null;
		this.z = null;

		this.rotation = null;
		this.scale = new Vector2();

		this.material = null;
	}
	
}