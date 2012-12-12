package org.angle3d.material.sgsl.node
{

	/**
	 * ...
	 * @author
	 */
	public class ConditionEndNode extends AgalNode
	{
		public function ConditionEndNode()
		{
			super();
			this.name = "eif";
		}

		override public function clone():LeafNode
		{
			var node:ConditionEndNode = new ConditionEndNode();
			cloneChildren(node);
			return node;
		}

		override public function toString(level:int = 0):String
		{
			var space:String = getSpace(level++);
			return space + "}\n";
		}

	}

}
