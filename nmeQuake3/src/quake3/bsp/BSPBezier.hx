package quake3.bsp;
import quake3.core.BSPGeometry;
import quake3.core.IGeometry;
import quake3.core.Vertex;
import nme.Vector;
import quake3.core.SubGeometry;
class BSPBezier 
{
    private var geometry:SubGeometry;
	private var vertices:Vector<Vertex>;
	
	public var control:Vector<Vertex>;
	private var level:Int;
	private var column:Vector<Vector<Vertex>> ;
	
	public function new() 
	{
		control = new Vector<Vertex>(9, true);
		for(i in 0...9)
		{
			control[i] = new Vertex();
		}
		column = new Vector<Vector<Vertex>>(3, true);
		for(i in 0...3)
		{
			column[i] = new Vector<Vertex>();
		}
	}
	
	public function setData(geometry:SubGeometry, vertices:Vector<Vertex>):Void
	{
		this.geometry = geometry;
		this.vertices = vertices;
	}
	
	public function tesselate(level:Int):Void
	{
		if (level < 1) level = 1;
		
		var level1:Int = level + 1;
		
		//Calculate how many vertices across/down there are
		column[0].length = level1;
		column[1].length = level1;
		column[2].length = level1;
		
		var w:Float = (1.0 / level);
		
		//Tesselate along the columns
		for(j in 0...level1)
		{
			var dist:Float = w * j;
			
			column[0][j] = getQuadraticInterpolated(control[0],control[3], control[6], dist);
			column[1][j] = getQuadraticInterpolated(control[1],control[4], control[7], dist);
			column[2][j] = getQuadraticInterpolated(control[2],control[5], control[8], dist);
		}
		
		
		var currentLength:Int = vertices.length;
		for(j in 0...level1)
		{
			for(k in 0...level1)
			{
				var vertex:Vertex = getQuadraticInterpolated(column[0][j],column[1][j], column[2][j], w * k);
				vertices.push(vertex);
			}
		}
		
		var indices:Vector<UInt> = geometry.indices;
		//connect
		for(j in 0...level)
		{
			for(k in 0...level)
			{
				var pos:Int = currentLength + k * level1 + j;
				
				indices.push(pos);
				indices.push(pos + level1);
				indices.push(pos + level1 + 1);
				
				indices.push(pos);
				indices.push(pos + level1 + 1);
				indices.push(pos + 1);
			}
		}
	}
	
	public inline function getQuadraticInterpolated(v1:Vertex,v2 : Vertex, v3 : Vertex, dist : Float) : Vertex
	{
		// v1*(1-d)*(1-d) + 2 * v2 *(1-d) + v3 * d * d;
		var b: Float = 1.0 - dist;
    	var b1: Float = b * b;
    	var b2: Float = 2 * b * dist;
    	var b3: Float = dist * dist;

		var vertex:Vertex = new Vertex();
		vertex.x = v1.x * b1 + v2.x * b2 + v3.x * b3;
		vertex.y = v1.y * b1 + v2.y * b2 + v3.y * b3;
		vertex.z = v1.z * b1 + v2.z * b2 + v3.z * b3;
		vertex.nx = v1.nx * b1 + v2.nx * b2 + v3.nx * b3;
		vertex.ny = v1.ny * b1 + v2.ny * b2 + v3.ny * b3;
		vertex.nz = v1.nz * b1 + v2.nz * b2 + v3.nz * b3;
		vertex.a = v1.a * b1 + v2.a * b2 + v3.a * b3;
		vertex.r = v1.r * b1 + v2.r * b2 + v3.r * b3;
		vertex.g = v1.g * b1 + v2.g * b2 + v3.g * b3;
		vertex.b = v1.b * b1 + v2.b * b2 + v3.b * b3;
		vertex.u = v1.u * b1 + v2.u * b2 + v3.u * b3;
		vertex.v = v1.v * b1 + v2.v * b2 + v3.v * b3;
		vertex.u2 = v1.u2 * b1 + v2.u2 * b2 + v3.u2 * b3;
		vertex.v2 = v1.v2 * b1 + v2.v2 * b2 + v3.v2 * b3;
		return vertex;
	}
}