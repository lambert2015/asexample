package three.lights;

/**
 * ...
 * @author 
 */

class AmbientLight extends Light
{

	public function new(hex:Int = 0x0) 
	{
		super(hex);
	}
	
	override public function clone(?light:Light):Light
	{
		if (light == null)
			light = new AmbientLight();
		
		super.clone(light);
		
		return light;
	}
	
}