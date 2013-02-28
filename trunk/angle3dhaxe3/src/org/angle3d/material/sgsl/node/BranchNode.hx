package org.angle3d.material.sgsl.node
{
	import flash.utils.Dictionary;

	class BranchNode extends LeafNode
	{
		private var mChildren:Vector<LeafNode>;

		public function BranchNode(name:String = "")
		{
			super(name);

			mChildren = new Vector<LeafNode>();
		}

		public function addChild(node:LeafNode):Void
		{
			mChildren.push(node);
		}

		public function removeChild(node:LeafNode):Void
		{
			var index:Int = mChildren.indexOf(node);
			if (index > -1)
			{
				mChildren.splice(index, 1);
			}
		}

		public function addChildren(list:Vector<LeafNode>):Void
		{
			var count:Int = list.length;
			for (var i:Int = 0; i < count; i++)
			{
				addChild(list[i]);
			}
		}

		public function get children():Vector<LeafNode>
		{
			return mChildren;
		}

		public function get numChildren():uint
		{
			return mChildren.length;
		}

		/**
		 * 筛选条件部分,符合条件的加入到children中，不符合的忽略
		 * @param branchNode
		 * @param defines
		 *
		 */
		public function filter(defines:Vector<String>):Void
		{
			if (defines == null)
			{
				defines = new Vector<String>();
			}

			var results:Vector<LeafNode> = new Vector<LeafNode>();

			var child:LeafNode;
			var predefine:PredefineNode;
			var cLength:Int = mChildren.length;
			for (var i:Int = 0; i < cLength; i++)
			{
				child = mChildren[i];

				//预定义条件
				if (child is PredefineNode)
				{
					predefine = child as PredefineNode;
					//符合条件则替换掉，否则忽略
					if (predefine.isMatch(defines))
					{
						var subList:Vector<LeafNode> = predefine.getMatchChildren(defines);
						if (subList != null && subList.length > 0)
						{
							results = results.concat(subList);
						}
					}
				}
				else
				{
					//在自身内部filter
					if (child is BranchNode)
					{
						(child as BranchNode).filter(defines);
					}
					results.push(child);
				}
			}

			mChildren = results;
		}

		/**
		 * 主要用于替换自定义变量的名称
		 */
		override public function renameLeafNode(map:Dictionary):Void
		{
			var length:Int = mChildren.length;
			for (var i:Int = 0; i < length; i++)
			{
				mChildren[i].renameLeafNode(map);
			}
		}

		/**
		 * 如果LeafNode的名字在map中存在，则替换掉此LeafNode
		 * @param map
		 *
		 */
		override public function replaceLeafNode(paramMap:Dictionary):Void
		{
			var child:LeafNode;
			for (var i:Int = 0, count:Int = mChildren.length; i < count; i++)
			{
				child = mChildren[i];
				child.replaceLeafNode(paramMap);
			}
		}

		override public function clone():LeafNode
		{
			var node:BranchNode = new BranchNode(name);
			cloneChildren(node);
			return node;
		}

		private function cloneChildren(branch:BranchNode):Void
		{
			var m:LeafNode;
			for (var i:Int = 0, count:Int = mChildren.length; i < count; i++)
			{
				m = mChildren[i];
				branch.addChild(m.clone());
			}
		}

		override public function toString(level:Int = 0):String
		{
			var result:String = "";

			result = getSelfString(level) + getChildrenString(level);

			return result;
		}

		private function getSelfString(level:Int):String
		{
			var result:String = getSpace(level) + name + "\n";

			return result;
		}

		private function getChildrenString(level:Int):String
		{
			level++;
			var result:String = "";
			var m:LeafNode;
			var length:Int = mChildren.length;
			for (var i:Int = 0; i < length; i++)
			{
				m = mChildren[i];
				result += m.toString(level);
			}
			return result;
		}
	}
}

