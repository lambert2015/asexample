package org.angle3d.material.sgsl.node
{

	final class ConstantNode extends AtomNode
	{
		public var value:Float;

		public function ConstantNode(value:Float)
		{
			super(value.toString());
			this.value = value;
		}

		override public function clone():LeafNode
		{
			return new ConstantNode(this.value);
		}

		override public function toString(level:Int = 0):String
		{
			var out:String = value + "";

			return out;
		}
	}
}

