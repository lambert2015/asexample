package three.core;
import three.math.Vector4;
import three.math.Matrix4;
import three.objects.Mesh;
/**
 * ...
 * @author andy
 */

class Frustum 
{
	public var planes:Array<Vector4>;
	public function new() 
	{
		this.planes = [new Vector4(), new Vector4(), new Vector4(), new Vector4(), new Vector4(), new Vector4()];
	}
	
	public function setFromMatrix(m:Matrix4):Void 
	{
		var plane:Vector4;
		var planes:Array<Vector4> = this.planes;

		var me = m.elements;
		var me0:Float = me[0], me1:Float = me[1], me2:Float = me[2], me3:Float = me[3];
		var me4:Float = me[4], me5:Float = me[5], me6:Float = me[6], me7:Float = me[7];
		var me8:Float = me[8], me9:Float = me[9], me10 = me[10], me11:Float = me[11];
		var me12:Float = me[12], me13:Float = me[13], me14:Float = me[14], me15:Float = me[15];

		planes[0].setTo(me3 - me0, me7 - me4, me11 - me8, me15 - me12);
		planes[1].setTo(me3 + me0, me7 + me4, me11 + me8, me15 + me12);
		planes[2].setTo(me3 + me1, me7 + me5, me11 + me9, me15 + me13);
		planes[3].setTo(me3 - me1, me7 - me5, me11 - me9, me15 - me13);
		planes[4].setTo(me3 - me2, me7 - me6, me11 - me10, me15 - me14);
		planes[5].setTo(me3 + me2, me7 + me6, me11 + me10, me15 + me14);

		for (i in 0...6) 
		{
			plane = planes[i];
			plane.divideScalar(Math.sqrt(plane.x * plane.x + plane.y * plane.y + plane.z * plane.z));
		}
	}

	public function contains(object:Object3D):Bool
	{
		var distance:Float = 0.0;
		var planes:Array<Vector4> = this.planes;
		var matrix:Matrix4 = object.matrixWorld;
		var me = matrix.elements;
		var radius:Float = -object.geometry.boundingSphere.radius * matrix.getMaxScaleOnAxis();

		for (i in 0...6) 
		{
			distance = planes[i].x * me[12] + planes[i].y * me[13] + planes[i].z * me[14] + planes[i].w;
			if (distance <= radius)
				return false;
		}
		return true;
	}
}