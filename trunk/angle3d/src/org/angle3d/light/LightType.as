package org.angle3d.light
{

	/**
	 * Describes the light type.
	 */
	public class LightType
	{
		public static const None:String = "none";

		/**
		 * Directional light
		 *
		 * @see DirectionalLight
		 */
		public static const Directional:String = "directional";

		/**
		 * Point light
		 *
		 * @see PointLight
		 */
		public static const Point:String = "point";

		/**
		 * Spot light.
		 *
		 * @see SpotLight
		 */
		public static const Spot:String = "spot";
	}
}

