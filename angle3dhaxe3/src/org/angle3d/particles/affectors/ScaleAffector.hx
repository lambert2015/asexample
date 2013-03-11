package org.angle3d.particles.affectors
{
	import org.angle3d.particles.attribute.DynamicAttribute;
	import org.angle3d.particles.Particle;

	class ScaleAffector extends ParticleAffector
	{
		public static inline var DEFAULT_X_SCALE:Float = 1.0;
		public static inline var DEFAULT_Y_SCALE:Float = 1.0;
		public static inline var DEFAULT_Z_SCALE:Float = 1.0;
		public static inline var DEFAULT_XYZ_SCALE:Float = 1.0;

		protected var mDynScaleX:DynamicAttribute;
		protected var mDynScaleY:DynamicAttribute;
		protected var mDynScaleZ:DynamicAttribute;
		protected var mDynScaleXYZ:DynamicAttribute;
		protected var mDynScaleXSet:Bool;
		protected var mDynScaleYSet:Bool;
		protected var mDynScaleZSet:Bool;
		protected var mDynScaleXYZSet:Bool;

		protected var mSinceStartSystem:Bool;
		;

		protected var mLatestTimeElapsed:Float;

		public function ScaleAffector()
		{
			super();
		}

		/** Returns the scale value for the dynamic Scale.
		 */
		protected function _calculateScale(dynScale:DynamicAttribute, particle:Particle):Float
		{
			return 0.0;
		}
	}
}
