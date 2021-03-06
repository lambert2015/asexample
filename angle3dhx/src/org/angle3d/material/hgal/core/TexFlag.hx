package org.angle3d.material.hgal.core;
import org.angle3d.utils.StringUtil;

/**
 * ...
 * @author andy
 */

class TexFlag 
{
	public var bias:Int;
	
	public var dimension:Int;
	
	public var mipmap:Int;
	
	public var filter:Int;
	
	public var wrap:Int;
	
	public var special:Int;

	public function new() 
	{
		bias = 0;
		dimension = 0;
		special = 0;
		wrap = 0;
		mipmap = 0;
		filter = 1;
	}
	
	public function getTexFlagsBits():UInt
	{
		return (dimension << 4) | (wrap << 12) | (mipmap << 16) | (filter << 20);
	}
	
	public inline function getLod():Int
	{
		var v:Int = Std.int(bias * 8);
		if( v < -128 ) v = -128 else if( v > 127 ) v = 127;
		if( v < 0 ) v = 0x100 + v;
		return v;
	}
	
	public function parseFlags(list:Array<String>):Void
	{
		for (i in 0...list.length)
		{
			var str:String = list[i];
			
			if (StringUtil.isDigit(str))
			{
				bias = Std.parseInt(str);
			}
			else
			{
				switch(str.toLowerCase())
				{
					case "2d":
						dimension = 0;
					case "cube":
						dimension = 1;
					//case "3d":
					//	dimension = 2;
					case "clamp":
						wrap = 0;
					case "wrap":
						wrap = 1;
					case "nomip","mipnone":
						mipmap = 0;
					case "mipnearest":
						mipmap = 1;
					case "miplinear":
						mipmap = 2;
					case "nearest":
						filter = 0;
					case "linear":
						filter = 1;
				}
			}
		}
	}
	
	public function toAgal():String
	{
		var arr:Array<String> = [];
		
		switch(dimension)
		{
			case 0:
				arr[0] = "2d";
			case 1:
				arr[0] = "cube";
			//case 2:
			//	arr[0] = "3d";
		}
		
		switch(wrap)
		{
			case 0:
				arr[1] = "clamp";
			case 1:
				arr[1] = "wrap";
		}
		
		switch(mipmap)
		{
			case 0:
				arr[2] = "nomip";
			case 1:
				arr[2] = "mipnearest";
			case 2:
				arr[2] = "miplinear";
		}
		
		switch(filter)
		{
			case 0:
				arr[3] = "nearest";
			case 1:
				arr[3] = "linear";
		}
		
		if (bias > 0)
		{
			arr[4] = bias + "";
		}
		
		return "<" + arr.join(",") + ">";
	}
	
}