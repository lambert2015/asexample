package org.angle3d.math
{

	public class VectorUtil
	{
		public static function fillNumber(target:Vector.<Number>, value:Number):void
		{
			var length:int=target.length;
			for (var i:int=0; i < length; i++)
			{
				target[i]=value;
			}
		}

		public static function fillInt(target:Vector.<int>, value:int):void
		{
			var length:int=target.length;
			for (var i:int=0; i < length; i++)
			{
				target[i]=value;
			}
		}

		public static function insert(target:Vector.<Number>, position:int, inserts:Vector.<Number>):void
		{
			var lefts:Vector.<Number>=target.splice(position, target.length - position);

			var length:int=inserts.length;
			for (var i:int=0; i < length; i++)
			{
				target.push(inserts[i]);
			}

			length=lefts.length;
			for (i=0; i < length; i++)
			{
				target.push(lefts[i]);
			}
		}
	}
}

