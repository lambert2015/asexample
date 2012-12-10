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
			this.name = "elf";
		}

		override public function clone():LeafNode
		{
			var node:ConditionEndNode = new ConditionEndNode();
			node.name = this.name;
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
