package org.angle3d.material.sgsl.node;

import flash.Vector;
using org.angle3d.utils.ArrayUtil;

class PredefineSubNode extends BranchNode
{
	private var _keywords:Array<String>;

	private var _arrangeList:Array<Array<String>>;

	public function new(name:String)
	{
		super(name);

		_keywords = new Array<String>();
	}

	override public function clone():LeafNode
	{
		var node:PredefineSubNode = new PredefineSubNode(name);
		node._keywords = _keywords.slice(0);

		cloneChildren(node);

		return node;
	}

	/**
	 * 整理分类keywords，根据'||'划分为多个数组
	 */
	private function arrangeKeywords():Void
	{
		if (_arrangeList != null)
			return;

		_arrangeList = new Array<Array<String>>();

		_arrangeList[0] = new Array<String>();
		_arrangeList[0].push(_keywords[0]);

		var length:Int = _keywords.length;
		for (i in 0...length)
		{
			if (_keywords[i] == "||")
			{
				_arrangeList[_arrangeList.length] = new Array<String>();
			}
			else if (_keywords[i] != "&&")
			{
				_arrangeList[_arrangeList.length - 1].push(_keywords[i]);
			}
		}
	}

	public function isMatch(defines:Array<String>):Bool
	{
		//到达这里时必定符合条件
		if (name == PredefineType.ELSE)
		{
			return true;
		}

		arrangeKeywords();

		var length:Int = _arrangeList.length;
		for (i in 0...length)
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
	private function matchDefines(defines:Array<String>, list:Array<String>):Bool
	{
		var length:Int = list.length;
		for (i in 0...length)
		{
			if (!defines.contain(list[i]))
			{
				return false;
			}
		}
		return true;
	}

	public function addKeyword(value:String):Void
	{
		_keywords.push(value);
	}

	override public function toString(level:Int = 0):String
	{
		var result:String = "";

		result += getSelfString(level);
		var space:String = getSpace(level);
		result += space + "{\n";
		result += getChildrenString(level);
		result += space + "}\n";
		return result;
	}

	override private function getSelfString(level:Int):String
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

