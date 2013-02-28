package org.angle3d.material.shader
{

	/**
	 * An attribute is a shader variable mapping to a VertexBuffer data
	 * on the CPU.
	 *
	 * @author Andy
	 */
	class AttributeVar extends ShaderVariable
	{
		public var index:Int;

		public var format:String;

		public function AttributeVar(name:String, size:Int)
		{
			super(name, size);
		}
	}
}

