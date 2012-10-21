package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;

	/**
	 * ...
	 * @author andy
	 */
	public class TextureReg extends RegNode
	{
		public function TextureReg(dataType:String, name:String)
		{
			super(RegType.UNIFORM, dataType, name);
		}

		override public function clone():LeafNode
		{
			return new TextureReg(dataType, name);
		}
	}
}

