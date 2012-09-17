package three.lights;
import three.cameras.Camera;
import three.math.Matrix4;
import three.math.Vector3;

/**
 * ...
 * @author 
 */

class DirectionalLight extends Light
{
	public var intensity:Float;
	
	public var distance:Float;

	public var shadowCameraNear:Float;
	public var shadowCameraFar:Float;
	
	public var shadowCameraLeft:Float;
	public var shadowCameraRight:Float;
	public var shadowCameraTop:Float;
	public var shadowCameraBottom:Float;

	public var shadowCameraVisible:Bool;
	
	public var shadowBias:Float;
	public var shadowDarkness:Float;
	
	public var shadowMapWidth:Int;
	public var shadowMapHeight:Int;
	
	public var shadowCascade:Bool;
	
	public var shadowCascadeOffset:Vector3;
	public var shadowCascadeCount:Int;
	
	public var shadowCascadeBias:Array<Float>;
	public var shadowCascadeWidth:Array<Int>;
	public var shadowCascadeHeight:Array<Int>;
	
	public var shadowCascadeNearZ:Array<Float>;
	public var shadowCascadeFarZ:Array<Float>;
	
	public var shadowCascadeArray:Array<Dynamic>;
	
	public var shadowMap:Dynamic;
	public var shadowMapSize:Dynamic;
	public var shadowCamera:Camera;
	public var shadowMatrix:Matrix4;
	public function new(hex:Int, intensity:Float = 1, distance:Float = 0) 
	{
		super(hex);
		
		this.position = new Vector3(0, 1, 0);
		
		this.intensity = intensity;
		this.distance = distance;

		this.castShadow = false;
		this.onlyShadow = false;

		//

		this.shadowCameraNear = 50;
		this.shadowCameraFar = 5000;

		this.shadowCameraLeft = -500;
		this.shadowCameraRight = 500;
		this.shadowCameraTop = 500;
		this.shadowCameraBottom = -500;

		this.shadowCameraVisible = false;

		this.shadowBias = 0;
		this.shadowDarkness = 0.5;

		this.shadowMapWidth = 512;
		this.shadowMapHeight = 512;

		//

		this.shadowCascade = false;

		this.shadowCascadeOffset = new Vector3(0, 0, -1000);
		this.shadowCascadeCount = 2;

		this.shadowCascadeBias = [0, 0, 0];
		this.shadowCascadeWidth = [512, 512, 512];
		this.shadowCascadeHeight = [512, 512, 512];

		this.shadowCascadeNearZ = [-1.000, 0.990, 0.998];
		this.shadowCascadeFarZ = [0.990, 0.998, 1.000];

		this.shadowCascadeArray = [];

		//

		this.shadowMap = null;
		this.shadowMapSize = null;
		this.shadowCamera = null;
		this.shadowMatrix = null;

	}
	
}