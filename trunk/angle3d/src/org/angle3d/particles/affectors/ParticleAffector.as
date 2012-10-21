package org.angle3d.particles.affectors
{
	import org.angle3d.math.Vector3f;
	import org.angle3d.particles.Particle;
	import org.angle3d.particles.ParticleTechnique;
	import org.angle3d.particles.ParticleType;

	/**
	 * Abstract class defining the interface to be implemented by particle affectors.
	 * Particle affectors modify particles in a particle system over their lifetime. This class defines
	 * the interface, and provides a few implementations of some basic functions.
	 */
	public class ParticleAffector
	{
		// Name of the affector 
		public var name:String;

		// Type of the affector
		public var type:String;

		public var technique:ParticleTechnique;

		/** The mAffectSpecialisation is used to specialise the affector. This attribute is comparable with the
		 mAutoDirection of the ParticleEmitter, it is an optional attribute and used in some of the Particle
		 Affectors.
		 */
		protected var mAffectSpecialisation:int;

		/** List of ParticleEmitter names that excludes particles emitted by ParticleEmitters with that name.
		 @remarks
		 Particles emitted by an ParticleEmitter with a name that is included in this list are not
		 affected by this ParticleAffector.
		 */
		protected var mExcludedEmitters:Vector.<String>;

		/** Although the scale is on a Particle System level, the affector can also be scaled.
		 */
		protected var _mAffectorScale:Vector3f;

		public function ParticleAffector()
		{
			//particleType = ParticleType.PT_AFFECTOR;
		}

		public function getAffectSpecialisation():int
		{
			return mAffectSpecialisation;
		}

		public function setAffectSpecialisation(value:int):void
		{
			mAffectSpecialisation = value;
		}

		/** Perform initialisation actions.
		 @remarks
		 The _prepare() function is automatically called during initialisation (prepare) activities of a
		 ParticleTechnique. A subclass could implement this function to perform initialisation
		 actions.
		 */
		public function _prepare(particleTechnique:ParticleTechnique):void
		{
		}

		/** Reverse the actions from the _prepare.
		 */
		public function _unprepare(particleTechnique:ParticleTechnique):void
		{
		}

		/** Perform activities when a ParticleAffector is started.
		 */
		public function _notifyStart():void
		{
		}

		/** Perform activities when a ParticleAffector is stopped.
		 */
		public function _notifyStop():void
		{
		}

		/** Perform activities when a ParticleAffector is paused.
		 */
		public function _notifyPause():void
		{
		}

		/** Perform activities when a ParticleAffector is resumed.
		 */
		public function _notifyResume():void
		{
		}

		/** Notify that the Affector is rescaled.
		 */
		public function _notifyRescaled(scale:Vector3f):void
		{
		}

		/** Perform activities before the individual particles are processed.
		 @remarks
		 This function is called before the ParticleTechnique update-loop where all particles are traversed.
		 the preProcess is typically used to perform calculations where the result must be used in
		 processing each individual particle.
		 */
		public function _preProcessParticles(particleTechnique:ParticleTechnique, timeElapsed:Number):void
		{
		}

		/** Perform precalculations if the first Particle in the update-loop is processed.
		 */
		public function _firstParticle(particleTechnique:ParticleTechnique, particle:Particle, timeElapsed:Number):void
		{
		}

		/** Initialise the ParticleAffector before it is emitted itself.
		 */
		public function _initForEmission():void
		{
		}

		/** Initialise the ParticleAffector before it is expired itself.
		 */
		public function _initForExpiration(technique:ParticleTechnique, timeElapsed:Number):void
		{
		}

		/** Initialise a newly emitted particle.
		 @param
		 particle Pointer to a Particle to initialise.
		 */
		public function _initParticleForEmission(particle:Particle):void
		{
		}

		/**
		 * 在affect之前调用，这里判断粒子是否需要执行affect
		 * @param particle Pointer to a ParticleTechnique to which the particle belongs.
		 * @param particle Pointer to a Particle.
		 * @param timeElapsed The number of seconds which have elapsed since the last call.
		 * @param firstParticle Determines whether the ParticleAffector encounters the first particle of all active particles.
		 */
		public function _processParticle(technique:ParticleTechnique, particle:Particle, timeElapsed:Number, firstParticle:Boolean):void
		{
		}

		/** Perform activities after the individual particles are processed.
		 @remarks
		 This function is called after the ParticleTechnique update-loop where all particles are traversed.
		 */
		public function _postProcessParticles(technique:ParticleTechnique, timeElapsed:Number):void
		{
		}

		/**
		 * Affect a particle.
		 */
		public function affect(technique:ParticleTechnique, particle:Particle, timeElapsed:Number):void
		{
		}

		/** Add a ParticleEmitter name that excludes Particles emitted by this ParticleEmitter from being
		 affected.
		 */
		public function addEmitterToExclude(emitterName:String):void
		{
		}

		/** Remove a ParticleEmitter name that excludes Particles emitted by this ParticleEmitter.
		 */
		public function removeEmitterToExclude(emitterName:String):void
		{
		}

		/** Remove all ParticleEmitter names that excludes Particles emitted by this ParticleEmitter.
		 */
		public function removeAllEmittersToExclude():void
		{
		}

		/**
		 * Return the list with emitters to exclude.
		 */
		public function getEmittersToExclude():Vector.<String>
		{
			return null;
		}

		/** Returns true if the list with excluded emitters contains a given name.
		 */
		public function hasEmitterToExclude(emitterName:String):Boolean
		{
			return false;
		}

		/** Copy attributes to another affector.
		 */
		public function copyAttributesTo(affector:ParticleAffector):void
		{
		}

		/** Copy parent attributes to another affector.
		 */
		public function copyParentAttributesTo(affector:ParticleAffector):void
		{
		}

		/** Calculate the derived position of the affector.
		 @remarks
		 Note, that in script, the position is set as localspace, while if the affector is
		 emitted, its position is automatically transformed. This function always returns
		 the derived position.
		 */
		public function getDerivedPosition():Vector3f
		{
			return null;
		}

		/** If the mAffectSpecialisation is used to specialise the affector, a factor can be calculated and used
		 in a child class. This factor depends on the value of mAffectSpecialisation.
		 @remarks
		 This helper method assumes that the particle pointer is valid.
		 */
		public function _calculateAffectSpecialisationFactor(particle:Particle):Number
		{
			return 0;
		}
	}
}
