package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import org.angle3d.math.Vector2f;
import org.angle3d.math.Vector3f;
import org.angle3d.math.Color;
import org.angle3d.math.Vector4f;
import org.angle3d.math.VectorUtil;
import org.angle3d.math.Line;
import org.angle3d.math.LineSegment;
import org.angle3d.math.Quaternion;
/**
 * ...
 * @author 
 */

class Main 
{
	
	static function main() 
	{
		trace(new Vector2f(4, 5));
		trace(new Vector3f(4, 5,6));
		trace(new Color(1, 0.5, 0.3, 1));
		trace(new Vector4f(1, 23.3, 4, 4));
		
		var vector:haxe.ds.Vector<Float> = new haxe.ds.Vector(100);
		vector[0] = 100;
		trace(vector);
	}
	
}