package org.angle3d.effect.cpu.influencers
{
	import org.angle3d.effect.cpu.Particle;
	import org.angle3d.effect.cpu.shape.EmitterShape;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Matrix3f;

	/**
	 * This influencer calculates initial velocity with the use of the emitter's shape.
	 */
	public class NewtonianParticleInfluencer extends DefaultParticleInfluencer
	{

		/** Normal to emitter's shape factor. */
		private var normalVelocity:Number;
		/** Emitter's surface tangent factor. */
		private var surfaceTangentFactor:Number;
		/** Emitters tangent rotation factor. */
		private var surfaceTangentRotation:Number;

		public function NewtonianParticleInfluencer()
		{
			super();
			this.velocityVariation = 0.0;
		}

		override public function influenceParticle(particle:Particle, emitterShape:EmitterShape):void
		{
			emitterShape.getRandomPointAndNormal(particle.position, particle.velocity);
			
			// influencing the particle's velocity
			if (surfaceTangentFactor == 0.0)
			{
				particle.velocity.scaleLocal(normalVelocity);
			}
			else
			{
				// calculating surface tangent (velocity contains the 'normal' value)
				temp.setTo(particle.velocity.z * surfaceTangentFactor, particle.velocity.y * surfaceTangentFactor, -particle.velocity.x * surfaceTangentFactor);
				if (surfaceTangentRotation != 0.0)
				{
					// rotating the tangent
					var m:Matrix3f = new Matrix3f();
					m.fromAngleNormalAxis(FastMath.PI * surfaceTangentRotation, particle.velocity);
					temp = m.multVec(temp);
				}
				// applying normal factor (this must be done first)
				particle.velocity.scaleLocal(normalVelocity);
				// adding tangent vector
				particle.velocity.addLocal(temp);
			}
			
			if (velocityVariation != 0.0)
			{
				this.applyVelocityVariation(particle);
			}
		}

		/**
		 * This method returns the normal velocity factor.
		 * @return the normal velocity factor
		 */
		public function getNormalVelocity():Number
		{
			return normalVelocity;
		}

		/**
		 * This method sets the normal velocity factor.
		 * @param normalVelocity
		 *        the normal velocity factor
		 */
		public function setNormalVelocity(normalVelocity:Number):void
		{
			this.normalVelocity = normalVelocity;
		}

		/**
		 * This method sets the surface tangent factor.
		 * @param surfaceTangentFactor
		 *        the surface tangent factor
		 */
		public function setSurfaceTangentFactor(surfaceTangentFactor:Number):void
		{
			this.surfaceTangentFactor = surfaceTangentFactor;
		}

		/**
		 * This method returns the surface tangent factor.
		 * @return the surface tangent factor
		 */
		public function getSurfaceTangentFactor():Number
		{
			return surfaceTangentFactor;
		}

		/**
		 * This method sets the surface tangent rotation factor.
		 * @param surfaceTangentRotation
		 *        the surface tangent rotation factor
		 */
		public function setSurfaceTangentRotation(surfaceTangentRotation:Number):void
		{
			this.surfaceTangentRotation = surfaceTangentRotation;
		}

		/**
		 * This method returns the surface tangent rotation factor.
		 * @return the surface tangent rotation factor
		 */
		public function getSurfaceTangentRotation():Number
		{
			return surfaceTangentRotation;
		}

		override protected function applyVelocityVariation(particle:Particle):void
		{
			temp.setTo(Math.random() * velocityVariation, Math.random() * velocityVariation, Math.random() * velocityVariation);
			particle.velocity.addLocal(temp);
		}

		override public function clone():IParticleInfluencer
		{
			var result:NewtonianParticleInfluencer = new NewtonianParticleInfluencer();
			result.initialVelocity.copyFrom(initialVelocity);
			result.normalVelocity = normalVelocity;
			result.velocityVariation = velocityVariation;
			result.surfaceTangentFactor = surfaceTangentFactor;
			result.surfaceTangentRotation = surfaceTangentRotation;
			return result;
		}
	}
}

