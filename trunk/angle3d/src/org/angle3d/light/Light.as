package org.angle3d.light
{
	import org.angle3d.math.Color;
	import org.angle3d.scene.Spatial;
	import org.angle3d.utils.Cloneable;

	/**
	 * Abstract public class for representing a light source.
	 * <p>
	 * All light source types have a color.
	 */

	public class Light implements Cloneable
	{
		/**
		 * Used in LightList for caching the distance
		 * to the owner spatial. Should be reset after the sorting.
		 */
		public var lastDistance : Number;

		private var _type : String;


		protected var _color : Color;

		/**
		 * 所有灯光都应该有个范围，超过范围的灯光就不起作用
		 */
		protected var _radius : Number;

		/**
		 * If light is disabled, it will not take effect.
		 */
		protected var _enabled : Boolean;


		public function Light(type : String)
		{
			_type = type;

			lastDistance = -1;

			_color = new Color(1, 1, 1, 1);
			_enabled = true;
		}

		public function get type() : String
		{
			return _type;
		}

		/**
		 * Returns the radius of the light influence. A radius of 0 means
		 * the light has no attenuation.
		 *
		 * @return the radius of the light
		 */
		public function get radius() : Number
		{
			return _radius;
		}

		/**
		 * Set the radius of the light influence.
		 * <p>
		 * Setting a non-zero radius indicates the light should use attenuation.
		 * If a pixel's distance to this light's position
		 * is greater than the light's radius, then the pixel will not be
		 * effected by this light, if the distance is less than the radius, then
		 * the magnitude of the influence is equal to distance / radius.
		 *
		 * @param radius the radius of the light influence.
		 *
		 */
		public function set radius(value : Number) : void
		{
			_radius = value;
		}

		/**
		 * Returns true if the light is enabled
		 *
		 * @return true if the light is enabled
		 *
		 * @see Light#setEnabled(boolean)
		 */
		private function get enabled() : Boolean
		{
			return _enabled;
		}

		private function set enabled(value : Boolean) : void
		{
			_enabled = value;
		}

		/**
		 * Intensity of the light. Allowed values are between 0-1, from dark to light sequentially.
		 * @return Intensity of the light source.
		 *
		 */
		public function set intensity(value : Number) : void
		{
			_color.a = value;
		}

		public function get intensity() : Number
		{
			return _color.a;
		}

		/**
		 * Sets the light color.
		 *
		 * @param color the light color.
		 */
		public function set color(color : uint) : void
		{
			_color.setRGB(color);
		}

		public function get color() : uint
		{
			return _color.getColor();
		}

		/**
		 * Used internally to compute the last distance value.
		 */
		public function computeLastDistance(owner : Spatial) : void
		{

		}
	}
}

