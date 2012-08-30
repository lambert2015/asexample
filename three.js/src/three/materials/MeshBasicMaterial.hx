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
	
	public var vertexColors:Array<Float>;
	public var skinning:Bool;
	public var morphTargets:Dynamic;

	public function new(parameters:Dynamic = null)
	{
		super();
		
		if (parameters != null)
		{
			this.setValues(parameters);
		}
	}
	
	override public function clone(?material:Material = null):Material
	{
		var result:MeshBasicMaterial;
		if (material == null)
			result = new MeshBasicMaterial();
		else
			result = cast(material, MeshBasicMaterial);
		
		super.clone(result);

		result.color.copy(this.color);

		result.map = this.map;

		result.lightMap = this.lightMap;

		result.specularMap = this.specularMap;

		result.envMap = this.envMap;
		result.combine = this.combine;
		result.reflectivity = this.reflectivity;
		result.refractionRatio = this.refractionRatio;

		result.fog = this.fog;

		result.shading = this.shading;

		result.wireframe = this.wireframe;
		result.wireframeLinewidth = this.wireframeLinewidth;
		result.wireframeLinecap = this.wireframeLinecap;
		result.wireframeLinejoin = this.wireframeLinejoin;

		result.vertexColors = this.vertexColors;

		result.skinning = this.skinning;
		result.morphTargets = this.morphTargets;

		return result;
	}
}