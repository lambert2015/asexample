package org.angle3d.material.sgsl.node
{
	import org.angle3d.material.sgsl.parser.TokenType;

	/**
	 * ...
	 * @author
	 */
	public class ConditionIfNode extends AgalNode
	{
		public var compareMethod:String;

		public function ConditionIfNode(name:String)
		{
			super();
			this.name = name;
		}

		override public function clone():LeafNode
		{
			var node:ConditionIfNode = new ConditionIfNode(this.name);
			node.compareMethod = this.compareMethod;
			cloneChildren(node);
			return node;
		}

		override public function toString(level:int = 0):String
		{
			var space:String = getSpace(level++);

			var result:Array = [];

			var m:LeafNode;
			var length:int = _children.length;
			for (var i:int = 0; i < length; i++)
			{
				m = _children[i];
				result.push(m.toString(level));
			}
			return space + this.name + "(" + result[0] + " " + this.compareMethod + " " + result[1] + "){\n";
		}

	}

}
