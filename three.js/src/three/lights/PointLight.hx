package three.lights;
import three.math.Vector3;

/**
 * ...
 * @author 
 */

class PointLight extends Light
{
	public var intensity:Float;
	
	public var distance:Float;

	public function new(hex:Int,intensity:Float=1,distance:Float=0) 
	{
		super(hex);
		position = new Vector3();
		this.intensity = intensity;
		this.distance = distance;
	}
	
}