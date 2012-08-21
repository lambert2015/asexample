package ;

import js.Lib;
import three.math.Vector2;
import three.scenes.Fog;

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
		
		var fog:Fog = new Fog(0, 2, 3000);
		
	}
	
}