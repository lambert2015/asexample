package org.angle3d.effect;
import flash.Lib;
import flash.Vector;
import org.angle3d.bounding.BoundingBox;
import org.angle3d.effect.influencers.DefaultParticleInfluencer;
import org.angle3d.effect.influencers.ParticleInfluencer;
import org.angle3d.effect.shape.EmitterPointShape;
import org.angle3d.effect.shape.EmitterShape;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Vector3f;
import org.angle3d.renderer.Camera3D;
import org.angle3d.renderer.queue.QueueBucket;
import org.angle3d.renderer.queue.ShadowMode;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.Geometry;
import org.angle3d.utils.TempVars;

/**
 * <code>ParticleEmitter</code> is a special kind of geometry which simulates
 * a particle system.
 * <p>
 * Particle emitters can be used to simulate various kinds of phenomena,
 * such as fire, smoke, explosions and much more.
 * <p>
 * Particle emitters have many properties which are used to control the 
 * simulation. The interpretation of these properties depends on the 
 * {@link ParticleInfluencer} that has been assigned to the emitter via
 * {@link ParticleEmitter#setParticleInfluencer(com.jme3.effect.influencers.ParticleInfluencer) }.
 * By default the implementation {@link DefaultParticleInfluencer} is used.
 * 
 * @author Kirill Vainer
 */
class ParticleEmitter extends Geometry
{
	private static inline var DEFAULT_SHAPE:EmitterShape = new EmitterPointShape();
    private static inline var DEFAULT_INFLUENCER:ParticleInfluencer = new DefaultParticleInfluencer();

	private var enabled:Bool;
    
    private var control:ParticleEmitterControl;
    private var shape:EmitterShape;
    private var particleMesh:ParticleMesh;
    private var particleInfluencer:ParticleInfluencer;
    private var particles:Vector<Particle>;
    private var firstUnUsed:Int;
    private var lastUsed:Int;

    private var randomAngle:Bool;
    private var selectRandomImage:Bool;
    private var facingVelocity:Bool;
    private var particlesPerSec:Float;
    private var timeDifference:Float;
    private var lowLife:Float;
    private var highLife:Float;
    private var gravity:Vector3f;
    private var rotateSpeed:Float;
    private var faceNormal:Vector3f;
    private var imagesX:Int;
    private var imagesY:Int;
   
    private var startColor:Color;
    private var endColor:Color;
    private var startSize:Float;
    private var endSize:Float;
    private var worldSpace:Bool ;
    //variable that helps with computations
    private var temp:Vector3f;
	
	public function new(name:String,numParticles:Int) 
	{
		super(name);
		
		init();
	    
		this.setNumParticles(numParticles);
	}
	
	private function init():Void
	{
		enabled = true;
    	shape = DEFAULT_SHAPE;
    	particleInfluencer = DEFAULT_INFLUENCER;

    	particlesPerSec = 20;
    	timeDifference = 0;
    	lowLife = 3;
    	highLife = 7;
    	gravity = new Vector3f(0.0, 0.1, 0.0);

    	faceNormal = new Vector3f();
    	imagesX = 1;
    	imagesY = 1;
   
    	startColor = new Color(0.4, 0.4, 0.4, 0.5);
    	endColor = new Color(0.1, 0.1, 0.1, 0.0);
    	startSize = 0.2;
    	endSize = 2;
    	worldSpace = true;
    	temp = new Vector3f();
		
		// ignore world transform, unless user sets inLocalSpace
        this.setIgnoreTransform(true);

        // particles neither receive nor cast shadows
        this.setShadowMode(ShadowMode.Off);

        // particles are usually transparent
        this.setQueueBucket(QueueBucket.Transparent);
		
		// Must create clone of shape/influencer so that a reference to a static is 
        // not maintained
		shape = shape.deepClone();
		particleInfluencer = particleInfluencer.clone();
		
		control = new ParticleEmitterControl(this);
		controls.push(control);
		
		particleMesh = new ParticleMesh();
	}
	
	public function setShape(shape:EmitterShape):Void
	{
		this.shape = shape;
	}
	
	public function getShape():EmitterShape
	{
		return this.shape;
	}
	
	/**
     * Set the {@link ParticleInfluencer} to influence this particle emitter.
     * 
     * @param particleInfluencer the {@link ParticleInfluencer} to influence 
     * this particle emitter.
     * 
     * @see ParticleInfluencer
     */
    public function setParticleInfluencer(particleInfluencer:ParticleInfluencer):Void
	{
        this.particleInfluencer = particleInfluencer;
    }

    /**
     * Returns the {@link ParticleInfluencer} that influences this 
     * particle emitter.
     * 
     * @return the {@link ParticleInfluencer} that influences this 
     * particle emitter.
     * 
     * @see ParticleInfluencer
     */
    public function getParticleInfluencer():ParticleInfluencer
	{
        return particleInfluencer;
    }
	
	/**
     * Returns true if particles should spawn in world space. 
     * 
     * @return true if particles should spawn in world space. 
     * 
     * @see ParticleEmitter#setInWorldSpace(boolean) 
     */
    public function isInWorldSpace():Bool 
	{
        return worldSpace;
    }

    /**
     * Set to true if particles should spawn in world space. 
     * 
     * <p>If set to true and the particle emitter is moved in the scene,
     * then particles that have already spawned won't be effected by this
     * motion. If set to false, the particles will emit in local space
     * and when the emitter is moved, so are all the particles that
     * were emitted previously.
     * 
     * @param worldSpace true if particles should spawn in world space. 
     */
    public function setInWorldSpace(worldSpace:Bool):Void 
	{
        this.setIgnoreTransform(worldSpace);
        this.worldSpace = worldSpace;
    }

    /**
     * Returns the number of visible particles (spawned but not dead).
     * 
     * @return the number of visible particles
     */
    public function getNumVisibleParticles():Int 
	{
//        return unusedIndices.size() + next;
        return lastUsed + 1;
    }

    /**
     * Set the maximum amount of particles that
     * can exist at the same time with this emitter.
     * Calling this method many times is not recommended.
     * 
     * @param numParticles the maximum amount of particles that
     * can exist at the same time with this emitter.
     */
    public function setNumParticles(numParticles:Int):Void
	{
        particles = new Vector<Particle>(numParticles,true);
        for (i in 0...numParticles) 
		{
            particles[i] = new Particle();
        }
        //We have to reinit the mesh's buffers with the new size
        particleMesh.initParticleData(this, particles.length);
        particleMesh.setImagesXY(this.imagesX, this.imagesY);
        firstUnUsed = 0;
        lastUsed = -1;
    }

    public function getMaxNumParticles():Int
	{
        return particles.length;
    }

    /**
     * Returns a list of all particles (shouldn't be used in most cases).
     * 
     * <p>
     * This includes both existing and non-existing particles.
     * The size of the array is set to the <code>numParticles</code> value
     * specified in the constructor or {@link ParticleEmitter#setNumParticles(int) }
     * method. 
     * 
     * @return a list of all particles.
     */
    public function getParticles():Vector<Particle>
	{
        return particles;
    }

    /**
     * Get the normal which particles are facing. 
     * 
     * @return the normal which particles are facing. 
     * 
     * @see ParticleEmitter#setFaceNormal(com.jme3.math.Vector3f) 
     */
    public function getFaceNormal():Vector3f 
	{
        if (Vector3f.isValidVector(faceNormal)) 
		{
            return faceNormal;
        } 
		else 
		{
            return null;
        }
    }

    /**
     * Sets the normal which particles are facing. 
     * 
     * <p>By default, particles
     * will face the camera, but for some effects (e.g shockwave) it may
     * be necessary to face a specific direction instead. To restore
     * normal functionality, provide <code>null</code> as the argument for
     * <code>faceNormal</code>.
     *
     * @param faceNormal The normals particles should face, or <code>null</code>
     * if particles should face the camera.
     */
    public function setFaceNormal(faceNormal:Vector3f):Void
	{
        if (faceNormal == null || !Vector3f.isValidVector(faceNormal)) 
		{
            this.faceNormal.copyFrom(Vector3f.NAN);
        } 
		else 
		{
            this.faceNormal = faceNormal;
        }
    }

    /**
     * Returns the rotation speed in radians/sec for particles.
     * 
     * @return the rotation speed in radians/sec for particles.
     * 
     * @see ParticleEmitter#setRotateSpeed(float) 
     */
    public function getRotateSpeed():Float 
	{
        return rotateSpeed;
    }

    /**
     * Set the rotation speed in radians/sec for particles
     * spawned after the invocation of this method.
     * 
     * @param rotateSpeed the rotation speed in radians/sec for particles
     * spawned after the invocation of this method.
     */
    public function setRotateSpeed(rotateSpeed:Float):Void
	{
        this.rotateSpeed = rotateSpeed;
    }

    /**
     * Returns true if every particle spawned
     * should have a random facing angle. 
     * 
     * @return true if every particle spawned
     * should have a random facing angle. 
     * 
     * @see ParticleEmitter#setRandomAngle(boolean) 
     */
    public function isRandomAngle():Bool 
	{
        return randomAngle;
    }

    /**
     * Set to true if every particle spawned
     * should have a random facing angle. 
     * 
     * @param randomAngle if every particle spawned
     * should have a random facing angle.
     */
    public function setRandomAngle(randomAngle:Bool):Void 
	{
        this.randomAngle = randomAngle;
    }

    /**
     * Returns true if every particle spawned should get a random
     * image.
     * 
     * @return True if every particle spawned should get a random
     * image.
     * 
     * @see ParticleEmitter#setSelectRandomImage(boolean) 
     */
    public function isSelectRandomImage():Bool 
	{
        return selectRandomImage;
    }

    /**
     * Set to true if every particle spawned
     * should get a random image from a pool of images constructed from
     * the texture, with X by Y possible images.
     * 
     * <p>By default, X and Y are equal
     * to 1, thus allowing only 1 possible image to be selected, but if the
     * particle is configured with multiple images by using {@link ParticleEmitter#setImagesX(int) }
     * and {#link ParticleEmitter#setImagesY(int) } methods, then multiple images
     * can be selected. Setting to false will cause each particle to have an animation
     * of images displayed, starting at image 1, and going until image X*Y when
     * the particle reaches its end of life.
     * 
     * @param selectRandomImage True if every particle spawned should get a random
     * image.
     */
    public function setSelectRandomImage(selectRandomImage:Bool):Void 
	{
        this.selectRandomImage = selectRandomImage;
    }

    /**
     * Check if particles spawned should face their velocity.
     * 
     * @return True if particles spawned should face their velocity.
     * 
     * @see ParticleEmitter#setFacingVelocity(boolean) 
     */
    public function isFacingVelocity():Bool 
	{
        return facingVelocity;
    }

    /**
     * Set to true if particles spawned should face
     * their velocity (or direction to which they are moving towards).
     * 
     * <p>This is typically used for e.g spark effects.
     * 
     * @param followVelocity True if particles spawned should face their velocity.
     * 
     */
    public function setFacingVelocity(followVelocity:Bool):Void
	{
        this.facingVelocity = followVelocity;
    }

    /**
     * Get the end color of the particles spawned.
     * 
     * @return the end color of the particles spawned.
     * 
     * @see ParticleEmitter#setEndColor(com.jme3.math.ColorRGBA) 
     */
    public function getEndColor():Color 
	{
        return endColor;
    }

    /**
     * Set the end color of the particles spawned.
     * 
     * <p>The
     * particle color at any time is determined by blending the start color
     * and end color based on the particle's current time of life relative
     * to its end of life.
     * 
     * @param endColor the end color of the particles spawned.
     */
    public function setEndColor(endColor:Color):Void 
	{
        this.endColor.copyFrom(endColor);
    }

    /**
     * Get the end size of the particles spawned.
     * 
     * @return the end size of the particles spawned.
     * 
     * @see ParticleEmitter#setEndSize(float) 
     */
    public function getEndSize():Float 
	{
        return endSize;
    }

    /**
     * Set the end size of the particles spawned.
     * 
     * <p>The
     * particle size at any time is determined by blending the start size
     * and end size based on the particle's current time of life relative
     * to its end of life.
     * 
     * @param endSize the end size of the particles spawned.
     */
    public function setEndSize(endSize:Float):Void 
	{
        this.endSize = endSize;
    }

    /**
     * Get the gravity vector.
     * 
     * @return the gravity vector.
     * 
     * @see ParticleEmitter#setGravity(com.jme3.math.Vector3f) 
     */
    public function getGravity():Vector3f 
	{
        return gravity;
    }

    /**
     * This method sets the gravity vector.
     * 
     * @param gravity the gravity vector
     */
    public function setGravity(gravity:Vector3f):Void 
	{
        this.gravity.copyFrom(gravity);
    }

    /**
     * Get the high value of life.
     * 
     * @return the high value of life.
     * 
     * @see ParticleEmitter#setHighLife(float) 
     */
    public function getHighLife():Float 
	{
        return highLife;
    }

    /**
     * Set the high value of life.
     * 
     * <p>The particle's lifetime/expiration
     * is determined by randomly selecting a time between low life and high life.
     * 
     * @param highLife the high value of life.
     */
    public function setHighLife(highLife:Float):Void
	{
        this.highLife = highLife;
    }

    /**
     * Get the number of images along the X axis (width).
     * 
     * @return the number of images along the X axis (width).
     * 
     * @see ParticleEmitter#setImagesX(int) 
     */
    public function getImagesX():Int 
	{
        return imagesX;
    }

    /**
     * Set the number of images along the X axis (width).
     * 
     * <p>To determine
     * how multiple particle images are selected and used, see the
     * {@link ParticleEmitter#setSelectRandomImage(boolean) } method.
     * 
     * @param imagesX the number of images along the X axis (width).
     */
    public function setImagesX(imagesX:Int):Void 
	{
        this.imagesX = imagesX;
        particleMesh.setImagesXY(this.imagesX, this.imagesY);
    }

    /**
     * Get the number of images along the Y axis (height).
     * 
     * @return the number of images along the Y axis (height).
     * 
     * @see ParticleEmitter#setImagesY(int) 
     */
    public function getImagesY():Int 
	{
        return imagesY;
    }

    /**
     * Set the number of images along the Y axis (height).
     * 
     * <p>To determine how multiple particle images are selected and used, see the
     * {@link ParticleEmitter#setSelectRandomImage(boolean) } method.
     * 
     * @param imagesY the number of images along the Y axis (height).
     */
    public function setImagesY(imagesY:Int):Void
	{
        this.imagesY = imagesY;
        particleMesh.setImagesXY(this.imagesX, this.imagesY);
    }

    /**
     * Get the low value of life.
     * 
     * @return the low value of life.
     * 
     * @see ParticleEmitter#setLowLife(float) 
     */
    public function getLowLife():Float 
	{
        return lowLife;
    }

    /**
     * Set the low value of life.
     * 
     * <p>The particle's lifetime/expiration
     * is determined by randomly selecting a time between low life and high life.
     * 
     * @param lowLife the low value of life.
     */
    public function setLowLife(lowLife:Float):Void
	{
        this.lowLife = lowLife;
    }

    /**
     * Get the number of particles to spawn per
     * second.
     * 
     * @return the number of particles to spawn per
     * second.
     * 
     * @see ParticleEmitter#setParticlesPerSec(float) 
     */
    public function getParticlesPerSec():Float 
	{
        return particlesPerSec;
    }

    /**
     * Set the number of particles to spawn per
     * second.
     * 
     * @param particlesPerSec the number of particles to spawn per
     * second.
     */
    public function setParticlesPerSec(particlesPerSec:Float):Void
	{
        this.particlesPerSec = particlesPerSec;
    }

    /**
     * Get the start color of the particles spawned.
     * 
     * @return the start color of the particles spawned.
     * 
     * @see ParticleEmitter#setStartColor(com.jme3.math.ColorRGBA) 
     */
    public function getStartColor():Color 
	{
        return startColor;
    }

    /**
     * Set the start color of the particles spawned.
     * 
     * <p>The particle color at any time is determined by blending the start color
     * and end color based on the particle's current time of life relative
     * to its end of life.
     * 
     * @param startColor the start color of the particles spawned
     */
    public function setStartColor(startColor:Color):Void
	{
        this.startColor.copyFrom(startColor);
    }

    /**
     * Get the start color of the particles spawned.
     * 
     * @return the start color of the particles spawned.
     * 
     * @see ParticleEmitter#setStartSize(float) 
     */
    public function getStartSize():Float 
	{
        return startSize;
    }

    /**
     * Set the start size of the particles spawned.
     * 
     * <p>The particle size at any time is determined by blending the start size
     * and end size based on the particle's current time of life relative
     * to its end of life.
     * 
     * @param startSize the start size of the particles spawned.
     */
    public function setStartSize(startSize:Float):Void
	{
        this.startSize = startSize;
    }

    /**
     * @deprecated Use ParticleEmitter.getParticleInfluencer().getInitialVelocity() instead.
     */
    //@Deprecated
    public function getInitialVelocity():Vector3f 
	{
        return particleInfluencer.getInitialVelocity();
    }

    /**
     * @param initialVelocity Set the initial velocity a particle is spawned with,
     * the initial velocity given in the parameter will be varied according
     * to the velocity variation set in {@link ParticleEmitter#setVelocityVariation(float) }.
     * A particle will move toward its velocity unless it is effected by the
     * gravity.
     *
     * @deprecated
     * This method is deprecated. 
     * Use ParticleEmitter.getParticleInfluencer().setInitialVelocity(initialVelocity); instead.
     *
     * @see ParticleEmitter#setVelocityVariation(float) 
     * @see ParticleEmitter#setGravity(float)
     */
    //@Deprecated
    public function setInitialVelocity(initialVelocity:Vector3f):Void
	{
        this.particleInfluencer.setInitialVelocity(initialVelocity);
    }

    /**
     * @deprecated
     * This method is deprecated. 
     * Use ParticleEmitter.getParticleInfluencer().getVelocityVariation(); instead.
     * @return the initial velocity variation factor
     */
    //@Deprecated
    public function getVelocityVariation():Float 
	{
        return particleInfluencer.getVelocityVariation();
    }

    /**
     * @param variation Set the variation by which the initial velocity
     * of the particle is determined. <code>variation</code> should be a value
     * from 0 to 1, where 0 means particles are to spawn with exactly
     * the velocity given in {@link ParticleEmitter#setStartVel(com.jme3.math.Vector3f) },
     * and 1 means particles are to spawn with a completely random velocity.
     * 
     * @deprecated
     * This method is deprecated. 
     * Use ParticleEmitter.getParticleInfluencer().setVelocityVariation(variation); instead.
     */
    //@Deprecated
    public function setVelocityVariation(variation:Float):Void
	{
        this.particleInfluencer.setVelocityVariation(variation);
    }

    private function emitParticle(min:Vector3f,max:Vector3f):Particle 
	{
        var idx:UInt = lastUsed + 1;
        if ( idx >= particles.length) 
		{
            return null;
        }

        var p:Particle = particles[idx];
        if (selectRandomImage) 
		{
        //    p.imageIndex = FastMath.nextRandomInt(0, imagesY - 1) * imagesX + FastMath.nextRandomInt(0, imagesX - 1);
        }

        //p.startlife = lowLife + FastMath.nextRandomFloat() * (highLife - lowLife);
        p.life = p.startlife;
        p.color.copyFrom(startColor);
        p.size = startSize;
        //shape.getRandomPoint(p.position);
        particleInfluencer.influenceParticle(p, shape);
        if (worldSpace) 
		{
            worldTransform.transformVector(p.position, p.position);
            worldTransform.rotation.multiplyVector(p.velocity, p.velocity);
            // TODO: Make scale relevant somehow??
        }
		
        if (randomAngle) 
		{
            //p.angle = FastMath.nextRandomFloat() * FastMath.TWO_PI;
        }
		
        if (rotateSpeed != 0) 
		{
            //p.rotateSpeed = rotateSpeed * (0.2 + (FastMath.nextRandomFloat() * 2 - 1) * .8);
        }
		
		// Computing bounding volume
		//var vec:Vector3f = new Vector3f(p.size, p.size, p.size);
		//temp.copyFrom(p.position).addLocal(vec);
		//max.maxLocal(temp);
		//temp.copyFrom(p.position).subtractLocal(vec);
		//min.minLocal(temp);
		
		temp.x = p.position.x + p.size;
		temp.y = p.position.y + p.size;
		temp.z = p.position.z + p.size;
        max.maxLocal(temp);
		
		temp.x = p.position.x - p.size;
		temp.y = p.position.y - p.size;
		temp.z = p.position.z - p.size;
        min.minLocal(temp);

        ++lastUsed;
        firstUnUsed = idx + 1;
        return p;
    }

    /**
     * Instantly emits all the particles possible to be emitted. Any particles
     * which are currently inactive will be spawned immediately.
     */
    public function emitAllParticles():Void
	{
        // Force world transform to update
        this.getWorldTransform();

        var vars:TempVars = TempVars.getTempVars();

        var bbox:BoundingBox = Lib.as(this.getMesh().getBound(),BoundingBox);

        var min:Vector3f = vars.vect1;
        var max:Vector3f = vars.vect2;

        bbox.getMin(min);
        bbox.getMax(max);

        if (!Vector3f.isValidVector(min)) 
		{
            min.copyFrom(Vector3f.POSITIVE_INFINITY);
        }
        if (!Vector3f.isValidVector(max)) 
		{
            max.copyFrom(Vector3f.NEGATIVE_INFINITY);
        }

        while (emitParticle(min, max) != null)
		{
			
		}

        bbox.setMinMax(min, max);
        this.setBoundRefresh();

        vars.release();
    }

    /**
     * Instantly kills all active particles, after this method is called, all
     * particles will be dead and no longer visible.
     */
    public function killAllParticles():Void
	{
        for (i in 0...particles.length) 
		{
            if (particles[i].life > 0) 
			{
                this.freeParticle(i);
            }
        }
    }
    
    /**
     * Kills the particle at the given index.
     * 
     * @param index The index of the particle to kill
     * @see #getParticles() 
     */
    public function killParticle(index:Int):Void
	{
        freeParticle(index);
    }

    private function freeParticle(idx:Int):Void
	{
        var p:Particle = particles[idx];
        p.life = 0;
        p.size = 0;
        p.color.setTo(0, 0, 0, 0);
        p.imageIndex = 0;
        p.angle = 0;
        p.rotateSpeed = 0;

        if (idx == lastUsed) 
		{
            while (lastUsed >= 0 && particles[lastUsed].life == 0) 
			{
                lastUsed--;
            }
        }
		
        if (idx < firstUnUsed) 
		{
            firstUnUsed = idx;
        }
    }

    private function swap(idx1:Int, idx2:Int):Void
	{
        var p1:Particle = particles[idx1];
        particles[idx1] = particles[idx2];
        particles[idx2] = p1;
    }

    private function updateParticle(p:Particle, tpf:Float, min:Vector3f, max:Vector3f):Void
	{
        // applying gravity
        p.velocity.x -= gravity.x * tpf;
        p.velocity.y -= gravity.y * tpf;
        p.velocity.z -= gravity.z * tpf;
        temp.copyFrom(p.velocity).scaleLocal(tpf);
        p.position.addLocal(temp);

        // affecting color, size and angle
        var b:Float = (p.startlife - p.life) / p.startlife;
        p.color.interpolate(startColor, endColor, b);
        p.size = FastMath.interpolateLinear(b, startSize, endSize);
        p.angle += p.rotateSpeed * tpf;
		
		

        // Computing bounding volume
		//var vec:Vector3f = new Vector3f(p.size, p.size, p.size);
		//temp.copyFrom(p.position).addLocal(vec);
		temp.x = p.position.x + p.size;
		temp.y = p.position.y + p.size;
		temp.z = p.position.z + p.size;
        max.maxLocal(temp);
		
        //temp.copyFrom(p.position).subtractLocal(vec);
		temp.x = p.position.x - p.size;
		temp.y = p.position.y - p.size;
		temp.z = p.position.z - p.size;
        min.minLocal(temp);

        if (!selectRandomImage) 
		{
            p.imageIndex = Std.int(b * imagesX * imagesY);
        }
    }
    
    private function updateParticleState(tpf:Float):Void
	{
        // Force world transform to update
        this.getWorldTransform();

        var vars:TempVars = TempVars.getTempVars();

        var min:Vector3f = vars.vect1.copyFrom(Vector3f.POSITIVE_INFINITY);
        var max:Vector3f = vars.vect2.copyFrom(Vector3f.NEGATIVE_INFINITY);

        for (i in 0...particles.length) 
		{
            var p:Particle = particles[i];
			// particle is dead
            if (p.life == 0) 
			{ 
                continue;
            }

            p.life -= tpf;
            if (p.life <= 0) 
			{
                this.freeParticle(i);
                continue;
            }

            updateParticle(p, tpf, min, max);

            if (firstUnUsed < i) 
			{
                this.swap(firstUnUsed, i);
                if (i == lastUsed) 
				{
                    lastUsed = firstUnUsed;
                }
                firstUnUsed++;
            }
        }
        
        // Spawns particles within the tpf timeslot with proper age
        var interval:Float = 1 / particlesPerSec;
        tpf += timeDifference;
        while (tpf > interval)
		{
            tpf -= interval;
            var p:Particle = emitParticle(min, max);
            if (p != null)
			{
                p.life -= tpf;
                if (p.life <= 0)
				{
                    freeParticle(lastUsed);
                }
				else
				{
                    updateParticle(p, tpf, min, max);
                }
            }
        }
        timeDifference = tpf;

        var bbox:BoundingBox = Lib.as(this.getMesh().getBound(),BoundingBox);
        bbox.setMinMax(min, max);
        this.setBoundRefresh();

        vars.release();
    }

    /**
     * Set to enable or disable the particle emitter
     * 
     * <p>When a particle is
     * disabled, it will be "frozen in time" and not update.
     * 
     * @param enabled True to enable the particle emitter
     */
    public function setEnabled(enabled:Bool):Void
	{
        this.enabled = enabled;
    }

    /**
     * Check if a particle emitter is enabled for update.
     * 
     * @return True if a particle emitter is enabled for update.
     * 
     * @see ParticleEmitter#setEnabled(boolean) 
     */
    public function isEnabled():Bool 
	{
        return enabled;
    }

    /**
     * Callback from Control.update(), do not use.
     * @param tpf 
     */
    public function updateFromControl(tpf:Float):Void 
	{
        if (enabled) 
		{
            this.updateParticleState(tpf);
        }
    }

    /**
     * Callback from Control.render(), do not use.
     * 
     * @param rm
     * @param vp 
     */
    public function renderFromControl(rm:RenderManager, vp:ViewPort):Void 
	{
        var cam:Camera3D = vp.camera;

        var inverseRotation:Matrix3f = Matrix3f.IDENTITY;
        var vars:TempVars = null;
		
        if (!worldSpace) 
		{
            vars = TempVars.getTempVars();

            inverseRotation = this.getWorldRotation().toRotationMatrix3f(vars.tempMat3).invertLocal();
        }
		
        particleMesh.updateParticleData(particles, cam, inverseRotation);
		
        if (!worldSpace) 
		{
            vars.release();
        }
    }

    public function preload(rm:RenderManager,vp:ViewPort):Void
	{
        this.updateParticleState(0);
        particleMesh.updateParticleData(particles, vp.camera, Matrix3f.IDENTITY);
    }
}