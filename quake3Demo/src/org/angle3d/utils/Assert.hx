package org.angle3d.utils;
import flash.errors.Error;

#if (!debug) extern #end
class Assert
{
    #if debug
    inline public static function assert(condition:Bool, info:String):Void
    {
        if (!condition) throw new Error(info);
    }
    #else
    inline public static function assert(condition:Bool, info:String):Void
    {
    }
    #end
}