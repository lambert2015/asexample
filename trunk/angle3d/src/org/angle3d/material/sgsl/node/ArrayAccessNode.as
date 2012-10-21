package org.angle3d.material.sgsl.node
{
	import flash.utils.Dictionary;

	public class ArrayAccessNode extends AtomNode
	{
		public var access:AtomNode;
		public var offset:int;

		public function ArrayAccessNode(name:String)
		{
			super(name);
			access=null;
			offset=0;
		}

		override public function isRelative():Boolean
		{
			return access != null;
		}

		override public function clone():LeafNode
		{
			var node:ArrayAccessNode=new ArrayAccessNode(name);
			if (access != null)
			{
				node.access=access.clone() as AtomNode;
			}
			node.offset=offset;
			node.mask=mask;
			return node;
		}

		override public function toString(level:int=0):String
		{
			var out:String=this.name + "[";

			if (access != null)
			{
				out+=access.toString(level);
			}

			if (offset >= 0)
			{
				if (access != null)
				{
					out+=" + ";
				}
				out+=offset.toString();
			}

			out+="]";

			if (mask != "")
			{
				out+="." + mask;
			}

			return out;
		}
	}
}

