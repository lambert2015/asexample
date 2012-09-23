package three.lights;
import three.core.Object3D;
import three.math.Color;
import three.math.Matrix4;
import three.cameras.Camera;
/**
 * ...
 * @author andy
 */

class Light extends Object3D
{
	public var target:Object3D;
	
	public var color:Color;
	
	public var onlyShadow:Bool;
	
	public var intensity:Float;
	
	public var distance:Float;
	
	public var shadowCascade:Bool;
	
	public var shadowBias:Float;
	public var shadowDarkness:Float;
	
	public var shadowMapWidth:Int;
	public var shadowMapHeight:Int;
	
	public var shadowMap:Dynamic;
	public var shadowMapSize:Dynamic;
	public var shadowCamera:Camera;
	public var shadowMatrix:Matrix4;

	public function new(hex:Int) 
	{
		super();
		
		this.color = new Color(hex);
	}
	
}