package org.angle3d.material.sgsl.node
{
	import flash.utils.Dictionary;

	import org.angle3d.material.sgsl.node.reg.RegNode;

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

		private var _params:Vector.<ParameterNode>;

		private var _needReplace:Boolean = true;

		//函数返回值
		public var result:LeafNode;

		public function FunctionNode(name:String)
		{
			super(name);

			_params = new Vector.<ParameterNode>();
		}

		/**
		 * 需要替换自定义函数
		 */
		public function get needReplace():Boolean
		{
			return _needReplace;
		}

		public function renameTempVar():void
		{
			var map:Dictionary = new Dictionary();

			var child:LeafNode;
			var cLength:int = _children.length;
			for (var i:int = 0; i < cLength; i++)
			{
				child = _children[i];
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

			if (result != null)
			{
				result.renameLeafNode(map);
			}
		}

		/**
		 * 方式感觉不太好
		 * 替换自定义函数
		 * @param map 自定义函数Map <functionName,fcuntionNode>
		 */
		public function replaceCustomFunction(functionMap:Dictionary):void
		{
			if (!_needReplace)
				return;

			//children
			var newChildren:Vector.<LeafNode> = new Vector.<LeafNode>();

			var child:LeafNode;
			var agalNode:AgalNode;
			var callNode:FunctionCallNode;

			var cLength:int = _children.length;
			for (var i:int = 0; i < cLength; i++)
			{
				child = _children[i];

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
						if (customFunc.result != null && agalNode.numChildren > 1)
						{
							agalNode.children[1] = customFunc.result;
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
			callNode = result as FunctionCallNode;
			if (isCustomFunctionCall(callNode, functionMap))
			{
				customFunc = callNode.cloneCustomFunction(functionMap);
				//复制customFunc的children到这里
				newChildren = newChildren.concat(customFunc.children);
				//如果自定义函数有返回值，这时应该用返回值替换函数的returnNode
				if (customFunc.result != null)
				{
					result = customFunc.result;
				}
			}

			_children = newChildren;

			_needReplace = false;
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

			if (result != null)
			{
				result.replaceLeafNode(paramMap);
			}

			renameTempVar();
		}

		override public function clone():LeafNode
		{
			var node:FunctionNode = new FunctionNode(name);
			node._needReplace = _needReplace;

			if (result != null)
			{
				node.result = result.clone();
			}

			var i:int;

			cloneChildren(node);

			//clone Param
			var m:ParameterNode;
			var pLength:int = _params.length;
			for (i = 0; i < pLength; i++)
			{
				m = _params[i];
				node.addParam(m.clone() as ParameterNode);
			}

			return node;
		}

		/**
		 * 主函数
		 * @return
		 *
		 */
		public function isMainFunction():Boolean
		{
			return this.name == "main";
		}

		public function addParam(param:ParameterNode):void
		{
			_params.push(param);
		}

		public function getParams():Vector.<ParameterNode>
		{
			return _params;
		}

		override public function toString(level:int = 0):String
		{
			var output:String = "";

			output = getSpace(level) + "function " + name + "(";

			var paramStrings:Array = [];
			var length:int = _params.length;
			for (var i:int = 0; i < length; i++)
			{
				paramStrings.push(_params[i].name);
			}

			output += paramStrings.join(",") + ")\n";

			var space:String = getSpace(level);
			output += space + "{\n";
			output += getChildrenString(level);
			if (result != null)
			{
				output += getSpace(level + 1) + "return " + result.toString(level) + ";\n";
			}
			output += space + "}\n";
			return output;
		}
	}
}

