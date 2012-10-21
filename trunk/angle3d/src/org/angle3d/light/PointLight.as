package org.angle3d.light
{
	import org.angle3d.math.Vector3f;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.scene.Spatial;
	import org.angle3d.utils.Assert;

	/**
	 * Represents a point light.
	 * A point light emits light from a given position into all directions in space.
	 * E.g a lamp or a bright effect. Point light positions are in world space.
	 * <p>
	 * In addition to a position, point lights also have a radius which
	 * can be used to attenuate the influence of the light depending on the
	 * distance between the light and the effected object.
	 *
	 */
	public class PointLight extends Light
	{
		private var mPosition:Vector3f;

		private var mInvRadius:Number;

		public function PointLight()
		{
			super(LightType.Point);

			mPosition=new Vector3f();
			mRadius=0;
			mInvRadius=0;
		}

		/**
		 * Returns the world space position of the light.
		 *
		 * @return the world space position of the light.
		 *
		 * @see PointLight#setPosition(org.angle3d.math.Vector3f)
		 */
		public function get position():Vector3f
		{
			return mPosition;
		}

		/**
		 * Set the world space position of the light.
		 *
		 * @param position the world space position of the light.
		 */
		public function set position(value:Vector3f):void
		{
			mPosition.copyFrom(value);
		}

		override public function set radius(value:Number):void
		{
			Assert.assert(value >= 0, "Light radius cannot be negative");

			mRadius=value;
			if (value != 0)
			{
				mInvRadius=1 / value;
			}
			else
			{
				mInvRadius=0;
			}
		}

		override public function computeLastDistance(owner:Spatial):void
		{
			if (owner.worldBound != null)
			{
				var bv:BoundingVolume=owner.worldBound;
				lastDistance=bv.distanceSquaredTo(mPosition);
			}
			else
			{
				lastDistance=owner.getWorldTranslation().distanceSquared(mPosition);
			}
		}

		/**
		 * for internal use only
		 * @return the inverse of the radius
		 */
		public function get invRadius():Number
		{
			return mInvRadius;
		}
	}
}

