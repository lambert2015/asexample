package org.angle3d.scene.shape;
import flash.Vector;
import org.angle3d.math.Spline;
import org.angle3d.math.SplineType;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.shape.LineSet;
import org.angle3d.scene.shape.WireframeShape;

/**
 * A <code>Curve</code> is a visual, line-based representation of a {@link Spline}.
 * The underlying Spline will be sampled N times where N is the number of 
 * segments as specified in the constructor. Each segment will represent
 * one line in the generated mesh.
 * 
 * @author andy
 */
class CurveShape extends WireframeShape
{
	private var spline:Spline;
	private var temp:Vector3f;

	public function new(spline:Spline, nbSubSegments:Int = 0) 
	{
		super();
		
		this.spline = spline;
		
		switch(spline.getType())
		{
			case SplineType.CatmullRom:
				this.createCatmullRomMesh(nbSubSegments);
			case SplineType.Bezier:
				this.createBezierMesh(nbSubSegments);
			case SplineType.Nurb:
				this.createNurbMesh(nbSubSegments);
			default:
				this.createLinearMesh();
		}
	}
	
	private function createCatmullRomMesh(nbSubSegments:Int):Void
	{
		var points:Vector<Vector3f> = spline.getControlPoints();
		var point:Vector3f;
		var start:Vector3f = new Vector3f();
		var end:Vector3f = new Vector3f();
		var cptCP:Int = 0;
		for (i in 0...(points.length-1))
		{
			start.copyFrom(points[i]);
			for (j in 1...nbSubSegments)
			{
				spline.interpolate(j / nbSubSegments, cptCP, end);
				
				addSegment(new LineSet(start.x, start.y, start.z, end.x, end.y, end.z));
				
				start.copyFrom(end);
					
				if (j == nbSubSegments - 1)
				{
					end.copyFrom(points[i + 1]);
					addSegment(new LineSet(start.x, start.y, start.z, end.x, end.y, end.z));
				}
			}
			cptCP++;
		}
		build();
	}
	
	private function createBezierMesh(nbSubSegments:Int):Void
	{
		//TODO implement
	}
	
	private function createNurbMesh(nbSubSegments:Int):Void
	{
		//TODO implement
	}
	
	private function createLinearMesh():Void
	{
		var points:Vector<Vector3f> = spline.getControlPoints();
		
		for (i in 0...(points.length - 1))
		{
			var p0:Vector3f = points[i];
			var p1:Vector3f = points[i+1];
			addSegment(new LineSet(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z));
		}
		build();
	}
	
}