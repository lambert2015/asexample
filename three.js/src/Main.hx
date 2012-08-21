package ;

import js.Lib;
import three.math.Vector2;

/**
 * ...
 * @author 
 */

class Main 
{
	
	static function main() 
	{
		var vec2:Vector2 = new Vector2();
		vec2.setTo(100, 200);
		
		var vec22:Vector2 = vec2.clone();
		Lib.alert(vec22);
	}
	
}