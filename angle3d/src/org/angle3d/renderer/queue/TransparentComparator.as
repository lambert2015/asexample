package org.angle3d.renderer.queue
{
	import org.angle3d.material.Material;
	import org.angle3d.math.FastMath;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.scene.Geometry;
	import org.angle3d.math.Vector3f;

	/**
	 * <code>TransparentComparator</code> sorts geometries back-to-front based
	 * on their Z position.
	 *
	 * @author Kirill Vainer
	 */
	public class TransparentComparator implements GeometryComparator
	{
		private var cam : Camera3D;
		private var tempVec : Vector3f;

		public function TransparentComparator()
		{
			tempVec = new Vector3f();
		}

		public function compare(o1 : Geometry, o2 : Geometry) : int
		{
			var d1 : Number = distanceToCam(o1);
			var d2 : Number = distanceToCam(o2);

			if (d1 < d2)
			{
				return 1;
			}
			else if (d1 > d2)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

		private function distanceToCam(spat : Geometry) : Number
		{
			// NOTE: It is best to check the distance
			// to the bound's closest edge vs. the bound's center here.
			return spat.worldBound.distanceToEdge(cam.location);
		}

		private function distanceToCam2(spat : Geometry) : Number
		{
			if (spat == null)
			{
				return Number.NEGATIVE_INFINITY;
			}

			if (spat.queueDistance != Number.NEGATIVE_INFINITY)
			{
				return spat.queueDistance;
			}

			var camPosition : Vector3f = cam.location;
			var viewVector : Vector3f = cam.getDirection();
			var spatPosition : Vector3f;
			if (spat.worldBound != null)
			{
				spatPosition = spat.worldBound.getCenter();
			}
			else
			{
				spatPosition = spat.getWorldTranslation();
			}

			tempVec = spatPosition.subtract(camPosition);
			//spat.queueDistance = tempVec.dotProduct(tempVec);

			var retval : Number = FastMath.fabs(tempVec.dot(viewVector) / viewVector.dot(viewVector));

			spat.queueDistance = tempVec.length;

			return spat.queueDistance;
		}

		public function setCamera(cam : Camera3D) : void
		{
			this.cam = cam;
		}
	}
}

