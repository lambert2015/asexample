package org.angle3d.scene;
import flash.Lib;
import org.angle3d.material.Material;
import org.angle3d.material.MaterialWireframe;
import org.angle3d.scene.shape.WireframeShape;
import org.angle3d.utils.Assert;

/**
 * ...
 * @author andy
 */

class WireframeGeometry extends Geometry
{

	public function new(name:String,mesh:WireframeShape) 
	{
		super(name, mesh);
		
	    this.material = new MaterialWireframe();
	}
	
	override public function setMaterial(material:Material):Void
	{
		#if debug
		Assert.assert(Std.is(material, MaterialWireframe), "material should be WireframeMaterial");
		#end
		
		super.setMaterial(material);
	}
	
	public function getWireMaterial():MaterialWireframe
	{
		return Lib.as(this.material, MaterialWireframe);
	}
	
}