package org.angle3d.effect.influencers;
import org.angle3d.effect.Particle;
import org.angle3d.effect.shape.EmitterShape;
import org.angle3d.math.Vector3f;

/**
 * This emitter influences the particles so that they move all in the same direction.
 * The direction may vary a little if the velocity variation is non zero.
 * This influencer is default for the particle emitter.
 * @author Marcin Roguski (Kaelthas)
 */
class DefaultParticleInfluencer implements ParticleInfluencer
{
	/** 
	 * Temporary variable used to help with calculations. 
	 */
    private var temp:Vector3f;
    /** 
	 * The initial velocity of the particles. 
	 */
    private var startVelocity:Vector3f;
    /** 
	 * The velocity's variation of the particles. 
	 */
    private var velocityVariation:Float;

	public function new() 
	{
		temp = new Vector3f();
		startVelocity = new Vector3f();
		velocityVariation = 0.2;
	}
	
	public function influenceParticle(particle:Particle, emitterShape:EmitterShape):Void
	{
		emitterShape.getRandomPoint(particle.position);
		this.applyVelocityVariation(particle);
	}
	
	/**
     * This method applies the variation to the particle with already set velocity.
     * @param particle
     *        the particle to be affected
     */
    private function applyVelocityVariation(particle:Particle):Void
	{
    	particle.velocity.copyFrom(startVelocity);
        temp.setTo(Math.random(), Math.random(), Math.random());
        temp.scaleLocal(2);
        temp.subtractLocal(new Vector3f(1, 1, 1));
        temp.scaleLocal(startVelocity.length);
        particle.velocity.interpolateLocal(temp, velocityVariation);
    }


    public function clone():ParticleInfluencer
	{
		var result:DefaultParticleInfluencer = new DefaultParticleInfluencer();
		result.startVelocity.copyFrom(startVelocity);
		result.velocityVariation = velocityVariation;
		
		return result;
	}


    public function setInitialVelocity(initialVelocity:Vector3f):Void
	{
		this.startVelocity.copyFrom(initialVelocity);
	}


    public function getInitialVelocity():Vector3f
	{
		return startVelocity;
	}

    public function setVelocityVariation(variation:Float):Void
	{
		this.velocityVariation = variation;
	}

    public function getVelocityVariation():Float
	{
		return velocityVariation;
	}
	
}