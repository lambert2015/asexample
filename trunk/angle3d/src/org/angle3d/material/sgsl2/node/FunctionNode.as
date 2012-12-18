package org.angle3d.material.sgsl2.node
{
	import flash.utils.Dictionary;

	import org.angle3d.material.sgsl.node.reg.RegNode;
	import org.angle3d.material.sgsl.node.agal.AgalNode;

	/**
	 * FunctionNode的Child只有两种
	 * 一个是临时变量定义
	 * 另外一个就是StatementNode
	 * 自定义方法内使用参数部分不能带后缀，如.x,[abc.x+10].z
	 */
	public class FunctionNode extends BranchNode
	{
		public static var TEPM_VAR_COUNT:int = 0;

		public static function getTempName(name:String, funcName:String):String
		{
			return name + "_" + funcName + "_" + (TEPM_VAR_COUNT++);
		}

		private var mParams:Vector.<ParameterNode>;

		private var mNeedReplace:Boolean = true;

		/**
		 * 返回类型
		 */
		public var dataType:String;

		//函数返回值
		public var returnNode:LeafNode;

		public function FunctionNode()
		{
			super();

			mParams = new Vector.<ParameterNode>();
		}

		/**
		 * 需要替换自定义函数
		 */
		public function get needReplace():Boolean
		{
			return mNeedReplace;
		}

		public function renameTempVar():void
		{
			var map:Dictionary = new Dictionary();

			var child:LeafNode;
			var cLength:int = mChildren.length;
			for (var i:int = 0; i < cLength; i++)
			{
				child = mChildren[i];
				if (child is RegNode)
				{
					map[child.name] = getTempName(child.name, this.name);
					child.name = map[child.name];
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
		public function replaceCustomFunction(functionMap:Dictionary):void
		{
			if (!mNeedReplace)
				return;

			//children
			var newChildren:Vector.<LeafNode> = new Vector.<LeafNode>();

			var child:LeafNode;
			var agalNode:AgalNode;
			var callNode:FunctionCallNode;

			var cLength:int = mChildren.length;
			for (var i:int = 0; i < cLength; i++)
			{
				child = mChildren[i];

				if (child is AgalNode)
				{
					agalNode = child as AgalNode;

					//condition end
					if (agalNode.numChildren == 0)
					{
						newChildren.push(child);
						continue;
					}

					if (agalNode.numChildren == 1)
					{
						callNode = agalNode.children[0] as FunctionCallNode;
					}
					else
					{
						callNode = agalNode.children[1] as FunctionCallNode;
					}

					if (isCustomFunctionCall(callNode, functionMap))
					{
						var customFunc:FunctionNode = callNode.cloneCustomFunction(functionMap);
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
			callNode = returnNode as FunctionCallNode;
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
		private function isCustomFunctionCall(node:FunctionCallNode, functionMap:Dictionary):Boolean
		{
			return node != null && (functionMap[node.name] != undefined);
		}

		override public function replaceLeafNode(paramMap:Dictionary):void
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

			var i:int;

			cloneChildren(node);

			//clone Param
			var m:ParameterNode;
			var pLength:int = mParams.length;
			for (i = 0; i < pLength; i++)
			{
				m = mParams[i];
				node.addParam(m.clone() as ParameterNode);
			}

			return node;
		}

		/**
		 * 主函数
		 * @return
		 *
		 */
		public function isMain():Boolean
		{
			return this.name == "main";
		}

		public function addParam(param:ParameterNode):void
		{
			mParams.push(param);
		}

		public function getParams():Vector.<ParameterNode>
		{
			return mParams;
		}

		override public function toString(level:int = 0):String
		{
			var output:String = "";

			output = getSpace(level) + "function " + name + "(";

			var paramStrings:Array = [];
			var length:int = mParams.length;
			for (var i:int = 0; i < length; i++)
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
}

