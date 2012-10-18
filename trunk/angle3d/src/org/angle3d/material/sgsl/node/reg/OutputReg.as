package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;

	/**
	 * output position|color
	 * @author andy
	 */
	public class OutputReg extends RegNode
	{
		public function OutputReg()
		{
			super(RegType.OUTPUT, DataType.VEC4, "output");

			index = 0;
		}

		override public function clone() : LeafNode
		{
			return new OutputReg();
		}
	}
}

