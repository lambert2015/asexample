package org.angle3d.material.sgsl2.node.reg
{
	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;

	/**
	 * UniformReg
	 * @author andy
	 */
	public class UniformReg extends RegNode
	{
		/**
		 * 数组大小
		 */
		public var arraySize:int;

		public function UniformReg(dataType:String, name:String, arraySize:int = 1)
		{
			super(RegType.UNIFORM, dataType, name);
			this.arraySize = arraySize;
		}

		override public function clone():LeafNode
		{
			return new UniformReg(dataType, name, arraySize);
		}

		override public function get size():uint
		{
			return arraySize * DataType.getSize(dataType);
		}
	}
}

