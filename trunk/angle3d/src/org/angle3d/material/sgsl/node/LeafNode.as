package org.angle3d.material.sgsl.node
{
	import flash.utils.Dictionary;

	public class LeafNode
	{
		public var name:String;

		public function LeafNode(name:String = "")
		{
			this.name = name;
		}

		public function renameLeafNode(map:Dictionary):void
		{
			if (map[this.name] != undefined)
			{
				this.name = map[this.name];
			}
		}

		public function replaceLeafNode(paramMap:Dictionary):void
		{

		}

		public function clone():LeafNode
		{
			return new LeafNode(name);
		}

		public function toString(level:int = 0):String
		{
			return name;
		}

		protected function getSpace(level:int):String
		{
			var space:String = "";
			for (var i:int = 0; i < level; i++)
				space += "   ";
			return space;
		}
	}

}


