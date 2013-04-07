package starling.utils;

import flash.utils.RegExp;

/**
 * ...
 * @author 
 */
class StringUtil
{
	
	
	/** Formats a String in .Net-style, with curly braces ("{0}"). Does not support any 
     *  number formatting options yet. */
    public static function formatString(format:String, args:Array<String>):String
    {
        for (i in 0...args.length)
            format = untyped format.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
        
        return format;
    }
	
}