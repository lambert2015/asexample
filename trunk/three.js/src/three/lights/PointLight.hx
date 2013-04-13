package three.lights;
import three.math.Vector3;

/**
 * ...
 * @author 
 */

class PointLight extends Light
{
	public function new(hex:Int = 0x0, intensity:Float = 1, distance:Float = 0) 
	{
		super(hex);
		position = new Vector3();
		this.intensity = intensity;
		this.distance = distance;
	}
	
}