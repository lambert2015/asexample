package org.angle3d.material.shader
{

	/**
	 * An attribute is a shader variable mapping to a VertexBuffer data
	 * on the CPU.
	 *
	 * @author Andy
	 */
	public class AttributeVar extends ShaderVariable
	{
		public var index : int;

		public var format : String;

		public function AttributeVar(name : String, size : int)
		{
			super(name, size);
		}
	}
}

