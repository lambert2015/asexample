package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;

	/**
	 * fragment depth output
	 * @author andy
	 */
	//需要测试是否正确可用
	public class DepthReg extends RegNode
	{
		public function DepthReg(index:int = 0)
		{
			super(RegType.DEPTH, DataType.VEC4, "depth" + index);

			this.index = index;
		}

		override public function clone():LeafNode
		{
			return new DepthReg(this.index);
		}
	}
}


