package three.lights;
import three.core.Object3D;
import three.math.Color;

/**
 * ...
 * @author andy
 */

class Light extends Object3D
{
	public var target:Object3D;
	
	public var color:Color;

	public function new() 
	{
		super();
		
		this.color = new Color();
	}
	
}