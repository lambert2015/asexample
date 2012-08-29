package three.materials;
import three.math.Color;
import three.textures.Texture;

/**
 * ...
 * @author 
 */

class MeshBasicMaterial extends Material
{
	public var color:Color;
	
	public var map:Texture;
	public var lightMap:Texture;
	public var specularMap:Texture;
	public var envMap:Texture;
	
	public var combine:Int;
	
	public var reflectivity:Float;
	public var refractionRatio:Float;
	
	public var fog:Bool;
	
	public var shading:Int;
	
	public var wireframe:Bool;
	public var wireframeLinewidth:Float;
	public var wireframeLinecap:String;
	public var wireframeLinejoin:String;

	public function new(parameters:Dynamic) 
	{
		super();
	}
	
}