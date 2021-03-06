package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;


	/**
	 * ...
	 * @author andy
	 */
	public class VaryingReg extends RegNode
	{
		public function VaryingReg(dataType:String, name:String)
		{
			super(RegType.VARYING, dataType, name);
		}

		override public function clone():LeafNode
		{
			return new VaryingReg(dataType, name);
		}
	}
}

