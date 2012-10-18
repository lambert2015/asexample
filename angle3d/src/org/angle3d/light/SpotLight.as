package org.angle3d.light
{
	import org.angle3d.math.Vector3f;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.math.FastMath;
	import org.angle3d.scene.Spatial;
	import org.angle3d.utils.Assert;

	/**
	 * Represents a spot light.
	 * A spot light emmit a cone of light from a position and in a direction.
	 * It can be used to fake torch lights or car's lights.
	 * <p>
	 * In addition to a position and a direction, spot lights also have a range which
	 * can be used to attenuate the influence of the light depending on the
	 * distance between the light and the effected object.
	 * Also the angle of the cone can be tweaked by changing the spot inner angle and the spot outer angle.
	 * the spot inner angle determin the cone of light where light has full influence.
	 * the spot outer angle determin the cone global cone of light of the spot light.
	 * the light intensity slowly decrease between the inner cone and the outer cone.
	 *  @author Nehon
	 */
	public class SpotLight extends Light
	{
		private var _position : Vector3f;
		private var _direction : Vector3f;

		private var _innerAngle : Number;
		private var _outerAngle : Number;
		private var _spotRange : Number;
		private var _invSpotRange : Number;
		private var _packedAngleCos : Number;

		public function SpotLight()
		{
			super(LightType.Spot);

			_position = new Vector3f();
			_direction = new Vector3f(0, -1, 0);

			_innerAngle = FastMath.PI / (4 * 8);
			_outerAngle = FastMath.PI / (4 * 6);
			_spotRange = 100;
			_invSpotRange = 1 / 100;
			_packedAngleCos = 0;
			computePackedCos();
		}

		private function computePackedCos() : void
		{
			var innerCos : Number = Math.cos(_innerAngle);
			var outerCos : Number = Math.cos(_outerAngle);
			_packedAngleCos = int(innerCos * 1000);
			_packedAngleCos += outerCos;
		}

		override public function computeLastDistance(owner : Spatial) : void
		{
			if (owner.worldBound != null)
			{
				var bv : BoundingVolume = owner.worldBound;
				lastDistance = bv.distanceSquaredTo(_position);
			}
			else
			{
				lastDistance = owner.getWorldTranslation().distanceSquared(_position);
			}
		}

		public function get direction() : Vector3f
		{
			return _direction;
		}

		public function set direction(direction : Vector3f) : void
		{
			_direction.copyFrom(direction);
		}

		public function get position() : Vector3f
		{
			return _position;
		}

		public function set position(position : Vector3f) : void
		{
			_position.copyFrom(position);
		}

		public function getSpotRange() : Number
		{
			return _spotRange;
		}

		/**
		 * Set the range of the light influence.
		 * <p>
		 * Setting a non-zero range indicates the light should use attenuation.
		 * If a pixel's distance to this light's position
		 * is greater than the light's range, then the pixel will not be
		 * effected by this light, if the distance is less than the range, then
		 * the magnitude of the influence is equal to distance / range.
		 *
		 * @param spotRange the range of the light influence.
		 *
		 * @throws IllegalArgumentException If spotRange is negative
		 */
		public function set spotRange(value : Number) : void
		{
			Assert.assert(value >= 0, "SpotLight range cannot be negative");

			_spotRange = value;
			if (value != 0)
			{
				_invSpotRange = 1 / value;
			}
			else
			{
				_invSpotRange = 0;
			}
		}

		/**
		 * for internal use only
		 * @return the inverse of the spot range
		 */
		public function get invSpotRange() : Number
		{
			return _invSpotRange;
		}

		/**
		 * returns the spot inner angle
		 * @return the spot inner angle
		 */
		public function get innerAngle() : Number
		{
			return _innerAngle;
		}

		/**
		 * Sets the inner angle of the cone of influence.
		 * This angle is the angle between the spot direction axis and the inner border of the cone of influence.
		 * @param spotInnerAngle
		 */
		public function set innerAngle(value : Number) : void
		{
			_innerAngle = value;
			computePackedCos();
		}

		/**
		 * returns the spot outer angle
		 * @return the spot outer angle
		 */
		public function get outerAngle() : Number
		{
			return _outerAngle;
		}

		/**
		 * Sets the outer angle of the cone of influence.
		 * This angle is the angle between the spot direction axis and the outer border of the cone of influence.
		 * this should be greater than the inner angle or the result will be unexpected.
		 * @param spotOuterAngle
		 */
		public function set outerAngle(value : Number) : void
		{
			_outerAngle = value;
			computePackedCos();
		}

		/**
		 * for internal use only
		 * @return the cosines of the inner and outter angle packed in a float
		 */
		public function get packedAngleCos() : Number
		{
			return _packedAngleCos;
		}
	}
}

