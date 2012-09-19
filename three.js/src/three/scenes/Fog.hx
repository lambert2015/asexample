package three.scenes;
import three.math.Color;

/**
 * andy
 * @author 
 */

class Fog implements IFog
{
	public var color:Color;
	
	public var near:Float;
	public var far:Float;

	public function new(hex:Int, ?near:Float = 1, ?far:Float = 1000) 
	{
		this.color = new Color(hex);
		this.near = near;
		this.far = far;
	}
	
}