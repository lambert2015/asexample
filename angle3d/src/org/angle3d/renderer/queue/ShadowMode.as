package org.angle3d.renderer.queue
{

	/**
	 * <code>ShadowMode</code> is a marker used to specify how shadow
	 * effects should treat the spatial.
	 */
	public class ShadowMode
	{
		/**
		 * Disable both shadow casting and shadow receiving for this spatial.
		 * Generally used for special effects like particle emitters.
		 */
		public static const Off:int = 0;

		/**
		 * Enable casting of shadows but not receiving them.
		 */
		public static const Cast:int = 1;

		/**
		 * Enable receiving of shadows but not casting them.
		 */
		public static const Receive:int = 2;

		/**
		 * Enable both receiving and casting of shadows.
		 */
		public static const CastAndReceive:int = 3;

		/**
		 * Inherit the <code>ShadowMode</code> from the parent node.
		 */
		public static const Inherit:int = 4;
	}
}

