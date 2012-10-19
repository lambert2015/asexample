package org.angle3d.utils
{

	/**
	 * ...
	 * @author andy
	 */
	public class ArrayUtil
	{
		[Inline]
		static public function contain(array:Array, item:*):Boolean
		{
			return array.indexOf(item) != -1;
		}

		[Inline]
		static public function remove(array:Array, item:*):Boolean
		{
			var index:int = array.indexOf(item);

			if (index > -1)
			{
				array.splice(index, 1);
				return true;
			}
			return false;
		}
	}
}

