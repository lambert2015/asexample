package org.angle3d.material.sgsl.node
{
	import flash.utils.Dictionary;

	/**
	 * 如果是自定义函数的话，最终需要替换
	 * @author andy
	 *
	 */
	public class FunctionCallNode extends BranchNode
	{
		public function FunctionCallNode(name:String)
		{
			super(name);
		}

		/**
		 * 克隆一个FunctionNode,并替换参数
		 * 只有自定义函数才能调用此方法
		 */
		public function cloneCustomFunction(functionMap:Dictionary):FunctionNode
		{
			var functionNode:FunctionNode = functionMap[this.name].clone();
			if (functionNode.needReplace)
			{
				functionNode.replaceCustomFunction(functionMap);
			}

			var params:Vector.<ParameterNode> = functionNode.getParams();
			var length:int = params.length;
			var paramMap:Dictionary = new Dictionary();
			for (var i:int = 0; i < length; i++)
			{
				var param:ParameterNode = params[i];
				paramMap[param.name] = children[i];
			}

			functionNode.replaceLeafNode(paramMap);

			return functionNode;
		}

		override public function clone():LeafNode
		{
			var node:FunctionCallNode = new FunctionCallNode(name);
			cloneChildren(node);
			return node;
		}

		override public function toString(level:int = 0):String
		{
			var result:String = "";

			result = name + "(" + getChildrenString(level) + ")";

			return result;
		}

		override protected function getChildrenString(level:int):String
		{
			var results:Array = [];
			var m:LeafNode;
			var length:int = _children.length;
			for (var i:int = 0; i < length; i++)
			{
				m = _children[i];
				results.push(m.toString(level));
			}
			return results.join(", ");
		}
	}
}

