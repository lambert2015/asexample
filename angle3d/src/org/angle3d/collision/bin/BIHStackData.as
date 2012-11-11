package org.angle3d.collision.bin
{

	public class BIHStackData
	{
		public var node:BIHNode;
		public var min:Number;
		public var max:Number;

		public function BIHStackData(node:BIHNode, min:Number, max:Number)
		{
			this.node = node;
			this.min = min;
			this.max = max;
		}
	}
}
