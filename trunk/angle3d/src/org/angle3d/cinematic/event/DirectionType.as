package org.angle3d.cinematic.event
{

	/**
	 * Enum for the different type of target direction behavior
	 */
	public class DirectionType
	{
		/**
		 * the target stay in the starting direction
		 */
		public static const None:int=0;
		/**
		 * The target rotates with the direction of the path
		 */
		public static const Path:int=1;
		/**
		 * The target rotates with the direction of the path but with the additon of a rtotation
		 * you need to use the setRotation mathod when using this Direction
		 */
		public static const PathAndRotation:int=2;
		/**
		 * The target rotates with the given rotation
		 */
		public static const Rotation:int=3;
		/**
		 * The target looks at a point
		 * You need to use the setLookAt method when using this direction
		 */
		public static const LookAt:int=4;
	}
}

