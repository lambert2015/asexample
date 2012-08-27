package three.core;
import three.math.Color;
import three.math.Vector3;

/**
 * ...
 * @author andy
 */

class Face3 
{
	public function new(a:Vector3, b:Vector3, c:Vector3, normal:Dynamic = null, color:Dynamic = null, materialIndex:Int = 0) 
	{
		super();
		
		this.a = a;
		this.b = b;
		this.c = c;
		
		this.normal = Std.is(normal, Vector3) ? normal : new Vector3();
		this.vertexNormals = Std.is(normal, Array<Vector3>) ? normal : [];
		
		this.color = Std.is(color, Color) ? color : new Color();
		this.vertexColors = Std.is(color, Array<Vector3>) ? color : [];
		
		this.vertexTangents = [];
		
		this.materialIndex = materialIndex;
		
		this.centroid = new Vector3();
	}
	
	public function clone():Face3
	{
		var face:Face3 = new Face3(this.a, this.b, this.c);

		face.normal.copy(this.normal);
		face.color.copy(this.color);
		face.centroid.copy(this.centroid);

		face.materialIndex = this.materialIndex;

		for ( i in 0...this.vertexNormals.length)
		{
			face.vertexNormals[i] = this.vertexNormals[i].clone();
		}
		for ( i in 0...this.vertexColors.length) 
		{
			face.vertexColors[i] = this.vertexColors[i].clone();
		}
		for ( i in 0...this.vertexTangents.length)
		{
			face.vertexTangents[i] = this.vertexTangents[i].clone();
		}

		return face;
	}
	
}