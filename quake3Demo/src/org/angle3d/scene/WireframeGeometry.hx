package org.angle3d.scene;
import org.angle3d.material.WireframeMaterial;
import org.angle3d.scene.debug.WireframeShape;

/**
 * ...
 * @author andy
 */

class WireframeGeometry extends Geometry
{

	public function new(name:String,mesh:WireframeShape) 
	{
		super(name, mesh);
		
	    this.material = new WireframeMaterial();
	}
	
}