package three.core;

import three.math.Vector3;
/**
 * ...
 * @author andy
 */

class BoundingSphere 
{
	public var radius:Float;

	public function new(radius:Float = 0) 
	{
		this.radius = radius;
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
	
	public function computeFromVertexs(vertexs:Array<Vector3>):Void
	{
		if (vertexs.length == 0)
		{
			this.radius = 0;
			return;
		}
		
		var p:Vector3;
		var radiusSq:Float, maxRadiusSq:Float = 0;
		for(i in 0...vertexs.length)
		{
			p = vertexs[i];

			radiusSq = p.lengthSq;
			if (radiusSq > maxRadiusSq)
				maxRadiusSq = radiusSq;
		}
		this.radius = Math.sqrt(maxRadiusSq);
	}
	
}