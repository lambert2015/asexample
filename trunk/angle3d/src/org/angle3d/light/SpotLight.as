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
		private var mPosition:Vector3f;
		private var mDirection:Vector3f;

		private var mInnerAngle:Number;
		private var mOuterAngle:Number;
		private var mSpotRange:Number;
		private var mInvSpotRange:Number;
		private var mPackedAngleCos:Number;

		public function SpotLight()
		{
			super(LightType.Spot);

			mPosition = new Vector3f();
			mDirection = new Vector3f(0, -1, 0);

			mInnerAngle = FastMath.PI / (4 * 8);
			mOuterAngle = FastMath.PI / (4 * 6);
			mSpotRange = 100;
			mInvSpotRange = 1 / 100;
			mPackedAngleCos = 0;
			computePackedCos();
		}

		private function computePackedCos():void
		{
			var innerCos:Number = Math.cos(mInnerAngle);
			var outerCos:Number = Math.cos(mOuterAngle);
			mPackedAngleCos = int(innerCos * 1000);
			mPackedAngleCos += outerCos;
		}

		override public function computeLastDistance(owner:Spatial):void
		{
			if (owner.worldBound != null)
			{
				var bv:BoundingVolume = owner.worldBound;
				lastDistance = bv.distanceSquaredTo(mPosition);
			}
			else
			{
				lastDistance = owner.getWorldTranslation().distanceSquared(mPosition);
			}
		}

		public function get direction():Vector3f
		{
			return mDirection;
		}

		public function set direction(direction:Vector3f):void
		{
			mDirection.copyFrom(direction);
		}

		public function get position():Vector3f
		{
			return mPosition;
		}

		public function set position(position:Vector3f):void
		{
			mPosition.copyFrom(position);
		}

		public function getSpotRange():Number
		{
			return mSpotRange;
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
		public function set spotRange(value:Number):void
		{
			Assert.assert(value >= 0, "SpotLight range cannot be negative");

			mSpotRange = value;
			if (value != 0)
			{
				mInvSpotRange = 1 / value;
			}
			else
			{
				mInvSpotRange = 0;
			}
		}

		/**
		 * for internal use only
		 * @return the inverse of the spot range
		 */
		public function get invSpotRange():Number
		{
			return mInvSpotRange;
		}

		/**
		 * returns the spot inner angle
		 * @return the spot inner angle
		 */
		public function get innerAngle():Number
		{
			return mInnerAngle;
		}

		/**
		 * Sets the inner angle of the cone of influence.
		 * This angle is the angle between the spot direction axis and the inner border of the cone of influence.
		 * @param spotInnerAngle
		 */
		public function set innerAngle(value:Number):void
		{
			mInnerAngle = value;
			computePackedCos();
		}

		/**
		 * returns the spot outer angle
		 * @return the spot outer angle
		 */
		public function get outerAngle():Number
		{
			return mOuterAngle;
		}

		/**
		 * Sets the outer angle of the cone of influence.
		 * This angle is the angle between the spot direction axis and the outer border of the cone of influence.
		 * this should be greater than the inner angle or the result will be unexpected.
		 * @param spotOuterAngle
		 */
		public function set outerAngle(value:Number):void
		{
			mOuterAngle = value;
			computePackedCos();
		}

		/**
		 * for internal use only
		 * @return the cosines of the inner and outter angle packed in a float
		 */
		public function get packedAngleCos():Number
		{
			return mPackedAngleCos;
		}
	}
}

