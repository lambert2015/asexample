package three.core;
import three.math.Vector3;

/**
 * ...
 * @author andy
 */

class BoundingBox 
{
	public var min:Vector3;
	public var max:Vector3;

	public function new() 
	{
		min = new Vector3(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
		max = new Vector3(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
	}
	
	public function resetTo(x:Float,y:Float,z:Float):Void
	{
		min.setTo(x, y, z);
		max.setTo(x, y, z);
	}
	
	public function computeFromPoints(points:Array<Float>):Void
	{
		var x:Float, y:Float, z:Float;
		var i:Int = 0;
		var pSize:Int = points.length;
		while(i < pSize)
		{
			x = points[i];
			y = points[i + 1];
			z = points[i + 2];

			// bounding box
			if (x < min.x) 
			{
				min.x = x;
			} 
			else if (x > max.x) 
			{
				max.x = x;
			}

			if (y < min.y) 
			{
				min.y = y;
			} 
			else if (y > max.y) 
			{
				max.y = y;
			}

			if (z < min.z) 
			{
				min.z = z;
			}
			else if (z > max.z) 
			{
				max.z = z;
			}
			
			i += 3;
		}
	}
}