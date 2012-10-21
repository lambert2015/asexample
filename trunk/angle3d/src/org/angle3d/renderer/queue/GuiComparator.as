package org.angle3d.renderer.queue
{
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.scene.Geometry;

	/**
	 * <code>GuiComparator</code> sorts geometries back-to-front based
	 * on their Z position.
	 *
	 * @author Kirill Vainer
	 */
	public class GuiComparator implements GeometryComparator
	{

		public function GuiComparator()
		{
		}

		public function compare(o1:Geometry, o2:Geometry):int
		{
			var z1:Number=o1.getWorldTranslation().z;
			var z2:Number=o2.getWorldTranslation().z;
			if (z1 > z2)
			{
				return 1;
			}
			else if (z1 < z2)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

		public function setCamera(cam:Camera3D):void
		{

		}
	}
}

