package three.scenes;
import three.math.Color;
/**
 * ...
 * @author 
 */

class FogExp2 implements IFog
{
	public var color:Color;
	
	public var density:Float;

	public function new(hex:Int, density:Float = 0.00025)
	{
		this.color = new Color(hex);
		this.density = density;
	}
	
}