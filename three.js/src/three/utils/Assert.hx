package three.utils;

class Assert
{
	public static function assert(condition:Bool, info:String):Void
	{
		if (!condition)
			trace(info);
	}
	
	public function new()
	{
		
	}
}

