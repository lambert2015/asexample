package org.angle3d.utils
{
	import flash.utils.Dictionary;

	public final class DictionaryUtil
	{
		public static function containKey(map:Dictionary, key:*):Boolean
		{
			return (map[key] != undefined);
		}

		public static function containValue(map:Dictionary, value:*):Boolean
		{
			for each (var i:* in map)
			{
				if (i === value)
				{
					return true;
				}
			}
			return false;
		}

		public static function getKeys(map:Dictionary):Array
		{
			var result:Array = [];
			for (var i:* in map)
			{
				result.push(i);
			}
			return result;
		}
	}
}

