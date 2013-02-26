package org.angle3d.material;
import org.angle3d.shader.basic.VertexColorShader;


/**
 * 顶点颜色着色的Material
 * @author andy
 */
class VertexColorMaterial extends Material
{
	public function new() 
	{
		super();

		setShader(new VertexColorShader());
		setLightMode(LightMode.Disable);
	}
}