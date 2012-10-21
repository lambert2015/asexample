package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.node.LeafNode;
	import org.angle3d.utils.Assert;


	/**
	 * SGSL中的变量
	 * @author andy
	 */
	public class RegNode extends LeafNode
	{
		public var regType:String;

		public var dataType:String;

		//注册地址
		public var index:int;

		public function RegNode(regType:String, dataType:String, name:String)
		{
			super(name);

			this.regType = regType;
			this.dataType = dataType;

			index = -1;
		}

		override public function clone():LeafNode
		{
			return new RegNode(regType, dataType, name);
		}

		override public function toString(level:int = 0):String
		{
			return getSpace(level) + regType + " " + dataType + " " + name + ";\n";
		}

		public function get registered():Boolean
		{
			return index > -1;
		}

		/**
		 * 在寄存器中的大小
		 */
		public function get size():uint
		{
			return DataType.getSize(dataType);
		}
	}
}

