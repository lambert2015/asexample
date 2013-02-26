package org.angle3d.shader;

/**
 * An attribute is a shader variable mapping to a VertexBuffer data
 * on the CPU.
 *
 * @author Andy
 */
class AttributeVar extends ShaderVar
{
	public function new(name:String,size:Int) 
	{
		super(name,size);
	}
}