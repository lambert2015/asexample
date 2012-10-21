package org.angle3d.scene.shape
{

	import org.angle3d.math.Spline;
	import org.angle3d.math.SplineType;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.shape.WireframeLineSet;
	import org.angle3d.scene.shape.WireframeShape;

	/**
	 * A <code>Curve</code> is a visual, line-based representation of a {@link Spline}.
	 * The underlying Spline will be sampled N times where N is the number of
	 * segments as specified in the constructor. Each segment will represent
	 * one line in the generated mesh.
	 *
	 * @author andy
	 */
	public class WireframeCurve extends WireframeShape
	{
		private var spline:Spline;
		private var temp:Vector3f;

		public function WireframeCurve(spline:Spline, nbSubSegments:int = 0)
		{
			super();

			this.spline = spline;

			switch (spline.type)
			{
				case SplineType.CatmullRom:
					createCatmullRomMesh(nbSubSegments);
					break;
				case SplineType.Bezier:
					createBezierMesh(nbSubSegments);
					break;
				case SplineType.Nurb:
					createNurbMesh(nbSubSegments);
					break;
				default:
					createLinearMesh();
					break;
			}
		}

		private function createCatmullRomMesh(nbSubSegments:int):void
		{
			var points:Vector.<Vector3f> = spline.getControlPoints();
			var point:Vector3f;
			var start:Vector3f = new Vector3f();
			var end:Vector3f = new Vector3f();
			var cptCP:int = 0;
			var pLength:int = (points.length - 1);
			for (var i:int = 0; i < pLength; i++)
			{
				start.copyFrom(points[i]);
				for (var j:int = 1; j < nbSubSegments; j++)
				{
					spline.interpolate(j / nbSubSegments, cptCP, end);

					addSegment(new WireframeLineSet(start.x, start.y, start.z, end.x, end.y, end.z));

					start.copyFrom(end);

					if (j == nbSubSegments - 1)
					{
						end.copyFrom(points[i + 1]);
						addSegment(new WireframeLineSet(start.x, start.y, start.z, end.x, end.y, end.z));
					}
				}
				cptCP++;
			}
			build();
		}

		private function createBezierMesh(nbSubSegments:int):void
		{
			//TODO implement
		}

		private function createNurbMesh(nbSubSegments:int):void
		{
			//TODO implement
		}

		private function createLinearMesh():void
		{
			var points:Vector.<Vector3f> = spline.getControlPoints();

			var pLength:int = (points.length - 1);
			for (var i:int = 0; i < pLength; i++)
			{
				var p0:Vector3f = points[i];
				var p1:Vector3f = points[i + 1];
				addSegment(new WireframeLineSet(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z));
			}
			build();
		}
	}
}

