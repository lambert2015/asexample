package org.angle3d.utils
{

	public class StringUtil
	{

		private static const _formatRegExp:RegExp = new RegExp("{(\\d+)}", "g");

		public static function format(input:String, ... values):String
		{
			return getFormat(input, values);
		}

		public static function getFormat(input:String, values:Array):String
		{
			if (input == null)
				return "";
			var result:String = input.replace(_formatRegExp, function():String
			{
				return values[parseInt(arguments[1])];
			});
			return result;
		}

		/**
		 * 拆分并删除空行
		 * @param	str
		 * @param	p
		 * @return
		 */
		public static function splitAndTrim(str:String, p:String):Array
		{
			var result:Array = [];

			var list:Array = str.split(p);
			var length:int = list.length;
			for (var i:int = 0; i < length; i++)
			{
				var s:String = list[i];
				//非空行
				if (s != "")
				{
					result.push(s);
				}
			}

			return result;
		}

		/**
		 * 删除前后的空格
		 * @param	source
		 * @return
		 */
		public static function trim(source:String):String
		{
			return source.replace(/^\s*|\s*$/g, "");
		}

		/**
		 * 删除所有空格
		 * @param	source
		 * @return
		 */
		public static function removeSpace(source:String):String
		{
			return source.replace(/\s+/g, "");
		}

		/**
		 * 判断一个字符串是否是数字
		 */
		public static function isDigit(str:*):Boolean
		{
			return !isNaN(str);
		}
	}
}

