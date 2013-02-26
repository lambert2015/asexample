package org.angle3d.effect;
import org.angle3d.math.Color;
import org.angle3d.math.Vector3f;

/**
 * Represents a single particle in a {@link ParticleEmitter}.
 * 
 * @author Kirill Vainer
 */
class Particle 
{
	/**
     * Particle velocity.
     */
    public var velocity:Vector3f;
    
    /**
     * Current particle position
     */
    public var position:Vector3f;
    
    /**
     * Particle color
     */
    public var color:Color;
    
    /**
     * Particle size or radius.
     */
    public var size:Float;
    
    /**
     * Particle remaining life, in seconds.
     */
    public var life:Float;
    
    /**
     * The initial particle life
     */
    public var startlife:Float;
    
    /**
     * Particle rotation angle (in radians).
     */
    public var angle:Float;
    
    /**
     * Particle rotation angle speed (in radians).
     */
    public var rotateSpeed:Float;
    
    /**
     * Particle image index. 
     */
    public var imageIndex:Int;

	public function new() 
	{
		velocity = new Vector3f();
		position = new Vector3f();
		color = new Color();
		
		imageIndex = 0;
	}
	
}