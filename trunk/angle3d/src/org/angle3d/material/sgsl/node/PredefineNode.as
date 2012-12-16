package org.angle3d.material.sgsl.node
{

	/**
	 * 预定义条件
	 */
	public class PredefineNode extends BranchNode
	{
		public function PredefineNode()
		{
			super();
		}

		override public function clone():LeafNode
		{
			var node:PredefineNode = new PredefineNode();
			cloneChildren(node);
			return node;
		}

		/**
		 * 符合预定义条件
		 */
		public function isMatch(defines:Vector.<String>):Boolean
		{
			var subNode:PredefineSubNode;
			var cLength:int = mChildren.length;
			for (var i:uint = 0; i < cLength; i++)
			{
				subNode = mChildren[i] as PredefineSubNode;
				if (subNode.isMatch(defines))
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * 返回符合条件的AstNode数组
		 * @param defines
		 * @return
		 *
		 */
		public function getMatchChildren(defines:Vector.<String>):Vector.<LeafNode>
		{
			var subNode:PredefineSubNode;
			var cLength:int = mChildren.length;
			for (var i:int = 0; i < cLength; i++)
			{
				subNode = mChildren[i] as PredefineSubNode;
				//只执行最先符合条件的
				if (subNode.isMatch(defines))
				{
					subNode.filter(defines);
					return subNode.children.slice();
				}
			}

			return null;
		}

		override public function toString(level:int = 0):String
		{
			var result:String = "";
			result += getChildrenString(level - 1);
			return result;
		}
	}
}

