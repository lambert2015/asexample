package three.core;

/**
 * ...
 * @author andy
 */

class BoundingSphere 
{
	public var radius:Float;

	public function new() 
	{
		radius = 0;
	}
	
	public function computeFromPoints(points:Array<Float>):Void
	{
		var x:Float, y:Float, z:Float;
		var radiusSq:Float, maxRadiusSq:Float = 0;
		var i:Int = 0;
		var pSize:Int = points.length;
		while(i < pSize)
		{
			x = points[i];
			y = points[i + 1];
			z = points[i + 2];

			radiusSq = x * x + y * y + z * z;
			if (radiusSq > maxRadiusSq)
				maxRadiusSq = radiusSq;
			
			i += 3;
		}
		this.radius = Math.sqrt(maxRadiusSq);
	}
	
}