package three.lights;

import three.math.Vector3;
import three.math.Matrix4;
import three.cameras.Camera;
/**
 * ...
 * @author 
 */

class SpotLight extends Light
{
	public var angle:Float;
	
	public var exponent:Float;

	public var shadowCameraNear:Float;
	public var shadowCameraFar:Float;
	public var shadowCameraFov:Float;

	public var shadowCameraVisible:Bool;

	public function new(hex:Int = 0x0, intensity:Float = 1, distance:Float = 0, angle:Float = 1.57, exponent:Int = 10)
	{
		super(hex);
		
		this.position = new Vector3(0, 1, 0);

		this.intensity = intensity;
		this.distance = distance;
		this.angle = angle;
		this.exponent = exponent;

		this.castShadow = false;
		this.onlyShadow = false;

		//

		this.shadowCameraNear = 50;
		this.shadowCameraFar = 5000;
		this.shadowCameraFov = 50;

		this.shadowCameraVisible = false;

		this.shadowBias = 0;
		this.shadowDarkness = 0.5;

		this.shadowMapWidth = 512;
		this.shadowMapHeight = 512;

		//

		this.shadowMap = null;
		this.shadowMapSize = null;
		this.shadowCamera = null;
		this.shadowMatrix = null;
	}
	
}