package org.angle3d.material;
import org.angle3d.shader.basic.WireframeShader;

/**
 * ...
 * @author andy
 */

class WireframeMaterial extends Material
{

	public function new() 
	{
		super();
		
		setShader(new WireframeShader());
		setLightMode(LightMode.Disable);
		
		//mergedRenderState.cullMode = FaceCullMode.Off;
	}
	
}