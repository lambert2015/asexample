package org.angle3d.utils;
import flash.utils.RegExp;

class StringUtil 
{
	public static inline function slice(source:String,start:Int = 0, end:Int = 0x7fffffff):String
	{
	    return untyped source.slice(start, end);
	}
	
	public static inline function match(source:String,regExp:RegExp):Array<String>
	{
	    return untyped source.match(regExp);
	}
	
	public static inline function search(source:String,regExp:RegExp):Int
	{
	    return untyped source.search(regExp);
	}
	
	public static inline function replace(source:String,pattern:Dynamic,repl:Dynamic):String
	{
	    return untyped source.replace(pattern,repl);
	}
	
	/**
	 * 拆分并删除空行
	 * @param	str
	 * @param	p
	 * @return
	 */
	public static function splitAndTrim( str:String, p:String ):Array<String>
	{
		var result:Array<String> = [];
		
		var list:Array<String> = str.split(p);
		for(i in 0...list.length)
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
	public static inline function trim(source:String):String
	{
		return StringUtil.replace(source, new RegExp("^\\s+|\\s+$", "g"), "");
	}
	
	/**
	 * 删除所有空格
	 * @param	source
	 * @return
	 */
	public static inline function removeSpace(source:String):String
	{
		return StringUtil.replace(source, new RegExp("\\s*", "g"), "");
	}
	
	/**
	 * 判断一个字符串是否是数字
	 */
	public static inline function isDigit(str:String):Bool 
	{
		return untyped !__global__["isNaN"](str);
	}
}