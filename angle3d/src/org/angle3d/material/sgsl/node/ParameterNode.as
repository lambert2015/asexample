package org.angle3d.material.sgsl.node
{

	/**
	 * 自定义方法参数
	 */
	public class ParameterNode extends LeafNode
	{
		public var dataType:String;

		public function ParameterNode(dataType:String, name:String)
		{
			super(name);
			this.dataType = dataType;
		}

		override public function clone():LeafNode
		{
			return new ParameterNode(dataType, name);
		}

		override public function toString(level:int = 0):String
		{
			return dataType + " " + name;
		}
	}
}

