package org.angle3d.effect.cpu.influencers
{
	import org.angle3d.effect.cpu.influencers.IParticleInfluencer;
	import org.angle3d.effect.cpu.Particle;
	import org.angle3d.effect.cpu.shape.EmitterShape;
	import org.angle3d.math.Vector3f;

	/**
	 * This influencer does not influence particle at all.
	 * It makes particles not to move.
	 */
	public class EmptyParticleInfluencer implements IParticleInfluencer
	{

		public function EmptyParticleInfluencer()
		{

		}

		public function influenceParticle(particle:Particle, emitterShape:EmitterShape):void
		{

		}


		public function clone():IParticleInfluencer
		{
			return new EmptyParticleInfluencer();
		}


		public function setInitialVelocity(initialVelocity:Vector3f):void
		{

		}


		public function getInitialVelocity():Vector3f
		{
			return null;
		}

		public function setVelocityVariation(variation:Number):void
		{

		}

		public function getVelocityVariation():Number
		{
			return 0;
		}
	}
}

