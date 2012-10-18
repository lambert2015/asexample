package org.angle3d.material.sgsl.node
{

	final public class ConstantNode extends AtomNode
	{
		public var value : Number;

		public function ConstantNode(value : Number)
		{
			super(value.toString());
			this.value = value;
		}

		override public function clone() : LeafNode
		{
			return new ConstantNode(this.value);
		}

		override public function toString(level : int = 0) : String
		{
			var out : String = value + "";

			return out;
		}
	}
}

