package org.angle3d.material.sgsl
{
	import org.angle3d.utils.StringUtil;

	/**
	 * ...
	 * @author andy
	 */

	internal class TexFlag
	{
		public var type:Int;

		public var bias:Int;

		public var dimension:Int;

		public var mipmap:Int;

		public var filter:Int;

		public var wrap:Int;

		public var special:Int;

		public function TexFlag()
		{
			type = 0;
			bias = 0;
			dimension = 0;
			special = 4;
			wrap = 0;
			mipmap = 0;
			filter = 1;
		}

		public function getTexFlagsBits():uint
		{
			return type | (dimension << 4) | (special << 8) | (wrap << 12) | (mipmap << 16) | (filter << 20);
		}

		public function get lod():Int
		{
			var v:Int = int(bias * 8);
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

		public function parseFlags(list:Array):Void
		{
			var length:Int = list.length;
			for (var i:Int = 0; i < length; i++)
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
						case "rgba":
							type = 0;
							break;
						case "dxt1":
							type = 1;
							break;
						case "dxt5":
							type = 2;
							break;
						case "2d":
							dimension = 0;
							break;
						case "cube":
							dimension = 1;
							break;
						case "3d":
							dimension = 2;
							break;
						case "clamp":
							wrap = 0;
							break;
						case "wrap":
						case "repeat":
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
						case "centroid":
							special = 0;
							break;
						case "single":
							special = 2;
							break;
						case "ignore":
							special = 4;
							break;
					}
				}
			}
		}
	}
}

