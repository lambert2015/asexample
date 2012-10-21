package org.angle3d.material.sgsl.node
{

	/**
	 * AgalNode最多有两个children
	 */
	public class AgalNode extends BranchNode
	{
		public function AgalNode()
		{
			super();
		}

		override public function clone():LeafNode
		{
			var node:AgalNode=new AgalNode();
			cloneChildren(node);
			return node;
		}

		override public function toString(level:int=0):String
		{
			var space:String=getSpace(level++);
			var result:Array=[];

			var m:LeafNode;
			var length:int=_children.length;
			for (var i:int=0; i < length; i++)
			{
				m=_children[i];
				result.push(m.toString(level));
			}

			if (result.length == 1)
			{
				return space + result[0] + ";\n";
			}
			else
			{
				return space + result[0] + " = " + result[1] + ";\n";
			}
		}
	}
}

