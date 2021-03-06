package org.angle3d.material.sgsl.node;

import haxe.ds.StringMap;
import org.angle3d.material.sgsl.node.agal.AgalNode;
import org.angle3d.material.sgsl.node.reg.RegNode;

/**
 * FunctionNode的Child只有两种
 * 一个是临时变量定义
 * 另外一个就是StatementNode
 * 自定义方法内使用参数部分不能带后缀，如.x,[abc.x+10].z
 */
class FunctionNode extends BranchNode
{
	public static var TEPM_VAR_COUNT:Int = 0;

	public static function getTempName(name:String, funcName:String):String
	{
		return name + "_" + funcName + "_" + (TEPM_VAR_COUNT++);
	}

	private var mParams:Array<ParameterNode>;

	private var mNeedReplace:Bool;

	/**
	 * 返回类型
	 */
	public var dataType:String;

	//函数返回值
	public var returnNode:LeafNode;

	public function new()
	{
		super();

		mParams = new Array<ParameterNode>();
		mNeedReplace = true;
	}

	/**
	 * 需要替换自定义函数
	 */
	public var needReplace(get, null):Bool;
	private function get_needReplace():Bool
	{
		return mNeedReplace;
	}

	public function renameTempVar():Void
	{
		var map:StringMap<String> = new StringMap<String>();

		var child:LeafNode;
		var cLength:Int = mChildren.length;
		for (i in 0...cLength)
		{
			child = mChildren[i];
			if (Std.is(child,RegNode))
			{
				map.set(child.name, getTempName(child.name, this.name));
				child.name = map.get(child.name);
			}
			else
			{
				child.renameLeafNode(map);
			}
		}

		if (returnNode != null)
		{
			returnNode.renameLeafNode(map);
		}
	}

	/**
	 * 方式感觉不太好
	 * 替换自定义函数
	 * @param map 自定义函数Map <functionName,fcuntionNode>
	 */
	public function replaceCustomFunction(functionMap:StringMap<FunctionNode>):Void
	{
		if (!mNeedReplace)
			return;

		//children
		var newChildren:Array<LeafNode> = new Array<LeafNode>();

		var child:LeafNode;
		var agalNode:AgalNode;
		var callNode:FunctionCallNode;
		var customFunc:FunctionNode; 
		var cLength:Int = mChildren.length;
		for (i in 0...cLength)
		{
			child = mChildren[i];

			if (Std.is(child,AgalNode))
			{
				agalNode = cast(child,AgalNode);

				//condition end
				if (agalNode.numChildren == 0)
				{
					newChildren.push(child);
					continue;
				}

				if (agalNode.numChildren == 1)
				{
					callNode = cast(agalNode.children[0],FunctionCallNode);
				}
				else
				{
					if (Std.is(agalNode.children[1], FunctionCallNode))
					{
						callNode = cast(agalNode.children[1],FunctionCallNode);
					}
					else
					{
						callNode = null;
					}
				}

				if (isCustomFunctionCall(callNode, functionMap))
				{
					customFunc = callNode.cloneCustomFunction(functionMap);
					//复制customFunc的children到这里
					newChildren = newChildren.concat(customFunc.children);
					//如果自定义函数有返回值，用返回值替换agalNode.children[1]
					if (customFunc.returnNode != null && agalNode.numChildren > 1)
					{
						agalNode.children[1] = customFunc.returnNode;
						newChildren.push(agalNode);
					}
				}
				else
				{
					newChildren.push(child);
				}
			}
			else
			{
				newChildren.push(child);
			}
		}

		//check returnNode
		callNode = cast(returnNode,FunctionCallNode);
		if (isCustomFunctionCall(callNode, functionMap))
		{
			customFunc = callNode.cloneCustomFunction(functionMap);
			//复制customFunc的children到这里
			newChildren = newChildren.concat(customFunc.children);
			//如果自定义函数有返回值，这时应该用返回值替换函数的returnNode
			if (customFunc.returnNode != null)
			{
				returnNode = customFunc.returnNode;
			}
		}

		mChildren = newChildren;

		mNeedReplace = false;
	}

	/**
	 * 是否是自定义函数调用,检查自已定义的函数和系统默认自定义的函数
	 */
	private function isCustomFunctionCall(node:FunctionCallNode, functionMap:StringMap<FunctionNode>):Bool
	{
		return node != null && functionMap.exists(node.name);
	}

	override public function replaceLeafNode(paramMap:StringMap<LeafNode>):Void
	{
		super.replaceLeafNode(paramMap);

		if (returnNode != null)
		{
			returnNode.replaceLeafNode(paramMap);
		}

		renameTempVar();
	}

	override public function clone():LeafNode
	{
		var node:FunctionNode = new FunctionNode();
		node.name = this.name;
		node.mNeedReplace = mNeedReplace;

		if (returnNode != null)
		{
			node.returnNode = returnNode.clone();
		}

		var i:Int;

		cloneChildren(node);

		//clone Param
		var m:ParameterNode;
		var pLength:Int = mParams.length;
		for (i in 0...pLength)
		{
			m = mParams[i];
			node.addParam(cast(m.clone(), ParameterNode));
		}

		return node;
	}

	/**
	 * 主函数
	 * @return
	 *
	 */
	public function isMain():Bool
	{
		return this.name == "main";
	}

	public function addParam(param:ParameterNode):Void
	{
		mParams.push(param);
	}

	public function getParams():Array<ParameterNode>
	{
		return mParams;
	}

	override public function toString(level:Int = 0):String
	{
		var output:String = "";

		output = getSpace(level) + "function " + name + "(";

		var paramStrings:Array<String> = [];
		var length:Int = mParams.length;
		for (i in 0...length)
		{
			paramStrings.push(mParams[i].name);
		}

		output += paramStrings.join(",") + ")\n";

		var space:String = getSpace(level);
		output += space + "{\n";
		output += getChildrenString(level);
		if (returnNode != null)
		{
			output += getSpace(level + 1) + "return " + returnNode.toString(level) + ";\n";
		}
		output += space + "}\n";
		return output;
	}
}

