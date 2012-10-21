package org.angle3d.scene.control
{

	/**
	 * Determines how the billboard is aligned to the screen/camera.
	 */
	public class Alignment
	{

		/**
		 * Aligns this Billboard to the screen.
		 */
		public static const Screen:String="screen";

		/**
		 * Aligns this Billboard to the camera position.
		 */
		public static const Camera:String="camera";

		/**
		 * Aligns this Billboard to the screen, but keeps the Y axis fixed.
		 */
		public static const AxialY:String="axialy";

		/**
		 * Aligns this Billboard to the screen, but keeps the Z axis fixed.
		 */
		public static const AxialZ:String="axialz";

	}
}

