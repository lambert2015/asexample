package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.node.LeafNode;

	/**
	 * ...
	 * @author andy
	 */

	public class UniformReg extends RegNode
	{
		/**
		 * 是否是数组
		 */
		public var isArray : Boolean;

		/**
		 * 数组大小
		 */
		public var arraySize : int;

		public function UniformReg(dataType : String, name : String, isArray : Boolean = false, arraySize : int = 0)
		{
			super(RegType.UNIFORM, dataType, name);
			this.isArray = isArray;
			this.arraySize = arraySize;
		}

		override public function clone() : LeafNode
		{
			return new UniformReg(dataType, name, isArray, arraySize);
		}

		override public function get size() : uint
		{
			if (isArray)
			{
				return arraySize * DataType.getSize(dataType);
			}
			else
			{
				return DataType.getSize(dataType);
			}
		}
	}
}

