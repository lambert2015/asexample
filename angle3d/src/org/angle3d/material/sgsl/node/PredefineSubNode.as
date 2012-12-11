package org.angle3d.material.sgsl.node
{

	public class PredefineSubNode extends BranchNode
	{
		private var _keywords:Vector.<String>;

		private var _arrangeList:Vector.<Vector.<String>>;

		public function PredefineSubNode(name:String)
		{
			super(name);

			_keywords = new Vector.<String>();
		}

		override public function clone():LeafNode
		{
			var node:PredefineSubNode = new PredefineSubNode(name);
			node._keywords = _keywords.slice();

			cloneChildren(node);

			return node;
		}

		/**
		 * 整理分类keywords，根据'||'划分为多个数组
		 */
		private function arrangeKeywords():void
		{
			if (_arrangeList != null)
				return;

			_arrangeList = new Vector.<Vector.<String>>();

			_arrangeList[0] = new Vector.<String>();
			_arrangeList[0].push(_keywords[0]);

			var length:int = _keywords.length;
			for (var i:int = 1; i < length; i++)
			{
				if (_keywords[i] == "||")
				{
					_arrangeList[_arrangeList.length] = new Vector.<String>();
				}
				else if (_keywords[i] != "&&")
				{
					_arrangeList[_arrangeList.length - 1].push(_keywords[i]);
				}
			}
		}

		public function isMatch(defines:Vector.<String>):Boolean
		{
			//到达这里时必定符合条件
			if (name == PredefineType.ELSE)
			{
				return true;
			}

			arrangeKeywords();

			var length:int = _arrangeList.length;
			for (var i:int = 0; i < length; i++)
			{
				if (matchDefines(defines, _arrangeList[i]))
				{
					return true;
				}
			}

			return false;
		}

		/**
		 * conditions是否包含了所有list中的字符串
		 * @param conditions 条件
		 * @param target
		 * @return
		 *
		 */
		private function matchDefines(defines:Vector.<String>, list:Vector.<String>):Boolean
		{
			var length:int = list.length;
			for (var i:int = 0; i < length; i++)
			{
				if (defines.indexOf(list[i]) == -1)
				{
					return false;
				}
			}
			return true;
		}

		public function addKeyword(value:String):void
		{
			_keywords.push(value);
		}

		override public function toString(level:int = 0):String
		{
			var result:String = "";

			result += getSelfString(level);
			var space:String = getSpace(level);
			result += space + "{\n";
			result += getChildrenString(level);
			result += space + "}\n";
			return result;
		}

		override protected function getSelfString(level:int):String
		{
			var result:String = "";

			result += getSpace(level) + name;

			if (name != PredefineType.ELSE)
			{
				result += "(" + _keywords.join(" ") + ")";
			}

			result += "\n";

			return result;
		}
	}
}

