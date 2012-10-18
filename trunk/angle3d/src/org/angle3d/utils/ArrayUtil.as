package org.angle3d.utils
{

	/**
	 * ...
	 * @author andy
	 */
	public class ArrayUtil
	{
		static public function contain(array:Array, item:*):Boolean
		{
			return array.indexOf(item) != -1;
		}

		static public function remove(array:Array, item:*):void
		{
			var index:int = array.indexOf(item);

			if (index > -1)
			{
				array.splice(index, 1);
			}
		}
	}
}

