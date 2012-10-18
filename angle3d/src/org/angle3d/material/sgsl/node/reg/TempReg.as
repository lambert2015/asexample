package org.angle3d.material.sgsl.node.reg
{

	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;

	/**
	 * 临时变量
	 * @author andy
	 */
	public class TempReg extends RegNode
	{
		/**
		 * 寄存器中的偏移量(0-3)
		 */
		public var offset : int;

		public function TempReg(dataType : String, name : String)
		{
			super(RegType.TEMP, dataType, name);

			offset = 0;
		}

		override public function clone() : LeafNode
		{
			return new TempReg(dataType, name);
		}
	}
}

