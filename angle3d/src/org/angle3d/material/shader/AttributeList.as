package org.angle3d.material.shader
{
	import flash.display3D.Context3DVertexBufferFormat;

	public class AttributeList extends ShaderVariableList
	{
		public function AttributeList()
		{
			super();
		}

		/**
		 *
		 * @param	name
		 * @return
		 */
		private function getFormat(size:int):String
		{
			switch (size)
			{
				case 1:
					return Context3DVertexBufferFormat.FLOAT_1;
				case 2:
					return Context3DVertexBufferFormat.FLOAT_2;
				case 3:
					return Context3DVertexBufferFormat.FLOAT_3;
				case 4:
					return Context3DVertexBufferFormat.FLOAT_4;
				default:
					throw new Error("没有这种类型");
					return "";
			}
		}

		override public function build():void
		{
			var att:AttributeVar;
			var offset:int = 0;
			var length:int = _variables.length;
			for (var i:int = 0; i < length; i++)
			{
				att = _variables[i] as AttributeVar;
				att.index = i;
				att.location = offset;
				att.format = getFormat(att.size);
				offset += att.size;
			}
		}
	}
}

