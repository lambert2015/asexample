package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;
	import org.angle3d.material.shader.ShaderType;

	/**
	 * ...
	 * @author andy
	 */
	public class AttributeReg extends RegNode
	{
		public function AttributeReg(dataType:String, name:String)
		{
			super(RegType.ATTRIBUTE, dataType, name);
		}

		override public function clone() : LeafNode
		{
			return new AttributeReg(dataType, name);
		}
	}
}
