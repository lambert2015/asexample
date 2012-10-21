package org.angle3d.particles.affectors
{
	import org.angle3d.particles.attribute.DynamicAttribute;
	import org.angle3d.particles.Particle;

	public class ScaleAffector extends ParticleAffector
	{
		public static const DEFAULT_X_SCALE:Number=1.0;
		public static const DEFAULT_Y_SCALE:Number=1.0;
		public static const DEFAULT_Z_SCALE:Number=1.0;
		public static const DEFAULT_XYZ_SCALE:Number=1.0;

		protected var mDynScaleX:DynamicAttribute;
		protected var mDynScaleY:DynamicAttribute;
		protected var mDynScaleZ:DynamicAttribute;
		protected var mDynScaleXYZ:DynamicAttribute;
		protected var mDynScaleXSet:Boolean;
		protected var mDynScaleYSet:Boolean;
		protected var mDynScaleZSet:Boolean;
		protected var mDynScaleXYZSet:Boolean;

		protected var mSinceStartSystem:Boolean;
		;

		protected var mLatestTimeElapsed:Number;

		public function ScaleAffector()
		{
			super();
		}

		/** Returns the scale value for the dynamic Scale.
		 */
		protected function _calculateScale(dynScale:DynamicAttribute, particle:Particle):Number
		{
			return 0.0;
		}
	}
}
