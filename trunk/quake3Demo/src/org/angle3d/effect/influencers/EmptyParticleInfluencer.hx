package org.angle3d.effect.influencers;
import org.angle3d.effect.influencers.ParticleInfluencer;
import org.angle3d.effect.Particle;
import org.angle3d.effect.shape.EmitterShape;
import org.angle3d.math.Vector3f;

/**
 * This influencer does not influence particle at all.
 * It makes particles not to move.
 * @author Marcin Roguski (Kaelthas)
 */
class EmptyParticleInfluencer implements ParticleInfluencer
{

	public function new() 
	{
		
	}
	
	public function influenceParticle(particle:Particle, emitterShape:EmitterShape):Void
	{
		
	}


    public function clone():ParticleInfluencer
	{
		return new EmptyParticleInfluencer();
	}


    public function setInitialVelocity(initialVelocity:Vector3f):Void
	{
		
	}


    public function getInitialVelocity():Vector3f
	{
		return null;
	}

    public function setVelocityVariation(variation:Float):Void
	{
		
	}

    public function getVelocityVariation():Float
	{
		return 0;
	}
	
}