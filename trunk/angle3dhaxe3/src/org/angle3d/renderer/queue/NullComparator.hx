package org.angle3d.renderer.queue
{

	import org.angle3d.renderer.Camera3D;
	import org.angle3d.scene.Geometry;

	/**
	 * <code>NullComparator</code> does not sort geometries. They will be in
	 * arbitrary order.
	 *
	 * @author Kirill Vainer
	 */
	public class NullComparator implements GeometryComparator
	{

		public function NullComparator()
		{
		}

		public function compare(o1:Geometry, o2:Geometry):int
		{
			return 0;
		}

		public function setCamera(cam:Camera3D):void
		{

		}
	}
}

