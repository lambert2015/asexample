package org.angle3d.material.sgsl
{
	import org.angle3d.utils.StringUtil;

	/**
	 * ...
	 * @author andy
	 */

	internal class TexFlag
	{
		public var bias:int;

		public var dimension:int;

		public var mipmap:int;

		public var filter:int;

		public var wrap:int;

		public var special:int;

		public function TexFlag()
		{
			bias = 0;
			dimension = 0;
			special = 0;
			wrap = 0;
			mipmap = 0;
			filter = 1;
		}

		public function getTexFlagsBits():uint
		{
			return (dimension << 4) | (special << 8) | (wrap << 12) | (mipmap << 16) | (filter << 20);
		}

		public function get lod():int
		{
			var v:int = int(bias * 8);
			if (v < -128)
			{
				v = -128;
			}
			else if (v > 127)
			{
				v = 127;
			}

			if (v < 0)
				v = 0x100 + v;

			return v;
		}

		public function parseFlags(list:Array):void
		{
			var length:int = list.length;
			for (var i:int = 0; i < length; i++)
			{
				var str:String = list[i];

				if (StringUtil.isDigit(str))
				{
					bias = parseInt(str);
				}
				else
				{
					switch (str.toLowerCase())
					{
						case "2d":
							dimension = 0;
							break;
						case "cube":
							dimension = 1;
							break;
//						case "3d":
//							dimension = 2;
//						break;
						case "clamp":
							wrap = 0;
							break;
						case "wrap":
							wrap = 1;
							break;
						case "nomip":
						case "mipnone":
							mipmap = 0;
							break;
						case "mipnearest":
							mipmap = 1;
							break;
						case "miplinear":
							mipmap = 2;
							break;
						case "nearest":
							filter = 0;
							break;
						case "linear":
							filter = 1;
							break;
					}
				}
			}
		}
	}
}

