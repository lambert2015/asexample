package org.angle3d.math;

import flash.Vector;

class VectorUtil 
{

	public static inline function array2UInt(data:Array<Int>):Vector<UInt> 
	{
		return untyped __vector__(data);
	}
	
	public static function fillFloat(target:Vector<Float>,value:Float):Void
	{
		for (i in 0...target.length)
		{
			target[i] = value;
		}
	}
	
	public static function fillInt(target:Vector<Int>,value:Int):Void
	{
		for (i in 0...target.length)
		{
			target[i] = value;
		}
	}
	
	public static function insert(target:Vector<Float>, position:Int, inserts:Vector<Float>):Void
	{
		var lefts:Vector<Float> = target.splice(position, target.length - position);
		
		for (i in 0...inserts.length)
		{
			target.push(inserts[i]);
		}
		
		for (i in 0...lefts.length)
		{
			target.push(lefts[i]);
		}
	}
}