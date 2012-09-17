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
	
	public var onlyShadow:Bool;

	public function new(hex:Int) 
	{
		super();
		
		this.color = new Color(hex);
	}
	
}