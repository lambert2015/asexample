package org.angle3d.scene
{

	/**
	 * The <code>FrustumIntersect</code> enum is returned as a result
	 * of a culling check operation,
	 * see {@link #contains(org.angle3d.bounding.BoundingVolume) }
	 */
	public class FrustumIntersect
	{
		/**
		 * defines a constant assigned to spatials that are completely outside
		 * of this camera's view frustum.
		 */
		public static const Outside:int=0;
		/**
		 * defines a constant assigned to spatials that are completely inside
		 * the camera's view frustum.
		 */
		public static const Inside:int=1;
		/**
		 * defines a constant assigned to spatials that are intersecting one of
		 * the six planes that define the view frustum.
		 */
		public static const Intersects:int=2;
	}
}

