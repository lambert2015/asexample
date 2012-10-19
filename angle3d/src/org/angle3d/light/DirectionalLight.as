package org.angle3d.light
{
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Spatial;

	/**
	 * <code>DirectionalLight</code> is a light coming from a certain direction in world space.
	 * E.g sun or moon light.
	 * <p>
	 * Directional lights have no specific position in the scene, they always
	 * come from their direction regardless of where an object is placed.
	 */
	public class DirectionalLight extends Light
	{
		private var mDirection : Vector3f;

		public function DirectionalLight()
		{
			super(LightType.Directional);

			mDirection = new Vector3f(0, -1, 0);
		}

		/**
		 * Returns the direction vector of the light.
		 *
		 * @return The direction vector of the light.
		 *
		 * @see DirectionalLight#setDirection(org.angle3d.math.Vector3f)
		 */
		public function get direction() : Vector3f
		{
			return mDirection;
		}

		/**
		 * Sets the direction of the light.
		 * <p>
		 * Represents the vector direction the light is coming from.
		 * (1, 0, 0) would represent a directional light coming from the X axis.
		 *
		 * @param dir the direction of the light.
		 */
		public function set direction(dir : Vector3f) : void
		{
			mDirection.copyFrom(dir);
			mDirection.normalizeLocal();
		}

		override public function computeLastDistance(owner : Spatial) : void
		{
			lastDistance = 0; // directional lights are always closest to their owner
		}
	}
}

