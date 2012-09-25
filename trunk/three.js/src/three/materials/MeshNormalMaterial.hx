package three.materials;
import three.ThreeGlobal;
/**
 * ...
 * @author 
 */

class MeshNormalMaterial extends Material
{
	//public var shading:Int;
	
	public var wireframe:Bool;
	public var wireframeLinewidth:Float;

	public function new(parameters:Dynamic = null)
	{
		super();
		
		this.shading = ThreeGlobal.FlatShading;

		this.wireframe = false;
		this.wireframeLinewidth = 1;

		if(parameters != null)
			this.setValues(parameters);
	}
	
	override public function clone(?material:Material = null):Material
	{
		var result:MeshNormalMaterial;
		if (material == null)
			result = new MeshNormalMaterial();
		else
			result = cast(material, MeshNormalMaterial);
		
		super.clone(result);
		
		result.shading = this.shading;

		result.wireframe = this.wireframe;
		result.wireframeLinewidth = this.wireframeLinewidth;
		
		return result;
	}
	
}