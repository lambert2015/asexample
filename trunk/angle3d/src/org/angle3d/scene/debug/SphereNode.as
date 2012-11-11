package org.angle3d.scene.debug
{
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.shape.Sphere;

	public class SphereNode extends Geometry
	{
		public function SphereNode(name:String, radius:Number, segmentsW:int = 15, segmentsH:int = 15, yUp:Boolean = true)
		{
			super(name, new Sphere(radius, segmentsW, segmentsH, yUp));
		}
	}
}
