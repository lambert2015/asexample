package org.angle3d.effect.cpu
{


	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.effect.cpu.influencers.DefaultParticleInfluencer;
	import org.angle3d.effect.cpu.influencers.IParticleInfluencer;
	import org.angle3d.effect.cpu.shape.EmitterPointShape;
	import org.angle3d.effect.cpu.shape.EmitterShape;
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Matrix3f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.renderer.queue.QueueBucket;
	import org.angle3d.renderer.queue.ShadowMode;
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
	 */
	/**
	 * 粒子发射器
	 *
	 * 设计要点：
	 * 需要有层级的概念，类似于Pyro
	 * 一个完整的粒子效果可能是有多个子特效组成
	 * 子特效至少包含开始时间和结束时间
	 * 编辑器的话需要使用类似于时间轴的概念来安排子特效到特效中
	 */
	//TODO 包围盒大小应该初步确定，以后就不更改大小
	public class ParticleEmitter extends Geometry
	{
		private static var DEFAULT_SHAPE:EmitterShape = new EmitterPointShape();
		private static var DEFAULT_INFLUENCER:IParticleInfluencer = new DefaultParticleInfluencer();

		private var _enabled:Boolean;

		private var _control:ParticleEmitterControl;
		private var _shape:EmitterShape;
		private var _particleMesh:ParticleCPUMesh;
		private var _particleInfluencer:IParticleInfluencer;

		private var _particles:Vector.<Particle>;
		private var _firstUnUsed:int;
		private var _lastUsed:int;

		private var _randomAngle:Boolean;
		private var _randomImage:Boolean;
		private var _facingVelocity:Boolean;
		private var _particlesPerSec:int;
		private var _timeDifference:Number;

		private var _lowLife:Number;
		private var _highLife:Number;

		private var _gravity:Vector3f;
		private var _rotateSpeed:Number;
		private var _faceNormal:Vector3f;
		private var _imagesX:int;
		private var _imagesY:int;

		private var _startColor:Color;
		private var _endColor:Color;

		private var _startAlpha:Number;
		private var _endAlpha:Number;

		private var _startSize:Number;
		private var _endSize:Number;

		private var _worldSpace:Boolean;

		//variable that helps with computations
		private var temp:Vector3f;

		public function ParticleEmitter(name:String, numParticles:int)
		{
			super(name);

			init();

			setNumParticles(numParticles);
		}

		private function init():void
		{
			_enabled = true;

			_shape = new EmitterPointShape();
			_particleInfluencer = new DefaultParticleInfluencer();

			_particlesPerSec = 20;
			_timeDifference = 0;
			_lowLife = 3;
			_highLife = 7;
			_gravity = new Vector3f(0.0, 0.1, 0.0);
			_rotateSpeed = 0;

			_faceNormal = new Vector3f(NaN, NaN, NaN);
			_imagesX = 1;
			_imagesY = 1;

			_startColor = new Color(0.4, 0.4, 0.4);
			_endColor = new Color(0.1, 0.1, 0.1);

			_startAlpha = 0.5;
			_endAlpha = 0.0;

			_startSize = 0.2;
			_endSize = 2;
			_worldSpace = true;

			temp = new Vector3f();

			// ignore world transform, unless user sets inLocalSpace
			setIgnoreTransform(true);

			// particles neither receive nor cast shadows
			localShadowMode = ShadowMode.Off;

			// particles are usually transparent
			localQueueBucket = QueueBucket.Transparent;

			_control = new ParticleEmitterControl(this);
			addControl(_control);

			_particleMesh = new ParticleCPUMesh();
			setMesh(_particleMesh);
		}

		public function setShape(shape:EmitterShape):void
		{
			_shape = shape;
		}

		public function getShape():EmitterShape
		{
			return _shape;
		}

		/**
		 * Set the {@link ParticleInfluencer} to influence this particle emitter.
		 *
		 * @param particleInfluencer the {@link ParticleInfluencer} to influence
		 * this particle emitter.
		 *
		 * @see ParticleInfluencer
		 */
		public function set particleInfluencer(influencer:IParticleInfluencer):void
		{
			_particleInfluencer = influencer;
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
		public function get particleInfluencer():IParticleInfluencer
		{
			return _particleInfluencer;
		}

		/**
		 * Returns true if particles should spawn in world space.
		 *
		 * @return true if particles should spawn in world space.
		 *
		 * @see ParticleEmitter#setInWorldSpace(boolean)
		 */
		public function get inWorldSpace():Boolean
		{
			return _worldSpace;
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
		public function set inWorldSpace(worldSpace:Boolean):void
		{
			setIgnoreTransform(worldSpace);
			_worldSpace = worldSpace;
		}

		/**
		 * Returns the number of visible particles (spawned but not dead).
		 *
		 * @return the number of visible particles
		 */
		public function getNumVisibleParticles():int
		{
//        return unusedIndices.size() + next;
			return _lastUsed + 1;
		}

		/**
		 * Set the maximum amount of particles that
		 * can exist at the same time with this emitter.
		 * Calling this method many times is not recommended.
		 *
		 * @param numParticles the maximum amount of particles that
		 * can exist at the same time with this emitter.
		 */
		public function setNumParticles(numParticles:int):void
		{
			_particles = new Vector.<Particle>(numParticles, true);
			for (var i:int = 0; i < numParticles; i++)
			{
				_particles[i] = new Particle();
			}

			//We have to reinit the mesh's buffers with the new size
			_particleMesh.initParticleData(this, numParticles);
			_particleMesh.setImagesXY(_imagesX, _imagesY);
			_firstUnUsed = 0;
			_lastUsed = -1;
		}

		public function getNumParticles():int
		{
			return _particles.length;
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
		public function getParticles():Vector.<Particle>
		{
			return _particles;
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
			if (Vector3f.isValidVector(_faceNormal))
			{
				return _faceNormal;
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
		public function setFaceNormal(faceNormal:Vector3f):void
		{
			if (faceNormal == null || !Vector3f.isValidVector(faceNormal))
			{
				this._faceNormal.copyFrom(Vector3f.NAN);
			}
			else
			{
				this._faceNormal = faceNormal;
			}
		}

		/**
		 * Returns the rotation speed in radians/sec for particles.
		 *
		 * @return the rotation speed in radians/sec for particles.
		 *
		 * @see ParticleEmitter#setRotateSpeed(float)
		 */
		public function getRotateSpeed():Number
		{
			return _rotateSpeed;
		}

		/**
		 * Set the rotation speed in radians/sec for particles
		 * spawned after the invocation of this method.
		 *
		 * @param rotateSpeed the rotation speed in radians/sec for particles
		 * spawned after the invocation of this method.
		 */
		public function setRotateSpeed(rotateSpeed:Number):void
		{
			this._rotateSpeed = rotateSpeed;
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
		public function isRandomAngle():Boolean
		{
			return _randomAngle;
		}

		/**
		 * Set to true if every particle spawned
		 * should have a random facing angle.
		 *
		 * @param randomAngle if every particle spawned
		 * should have a random facing angle.
		 */
		public function setRandomAngle(randomAngle:Boolean):void
		{
			this._randomAngle = randomAngle;
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
		public function get randomImage():Boolean
		{
			return _randomImage;
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
		public function set randomImage(randomImage:Boolean):void
		{
			_randomImage = randomImage;
		}

		/**
		 * Check if particles spawned should face their velocity.
		 *
		 * @return True if particles spawned should face their velocity.
		 *
		 * @see ParticleEmitter#setFacingVelocity(boolean)
		 */
		public function isFacingVelocity():Boolean
		{
			return _facingVelocity;
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
		public function setFacingVelocity(followVelocity:Boolean):void
		{
			this._facingVelocity = followVelocity;
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
			return _endColor;
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
		public function setEndColor(endColor:Color):void
		{
			this._endColor.copyFrom(endColor);
		}

		/**
		 * Get the end size of the particles spawned.
		 *
		 * @return the end size of the particles spawned.
		 *
		 * @see ParticleEmitter#setEndSize(float)
		 */
		public function getEndSize():Number
		{
			return _endSize;
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
		public function setEndSize(endSize:Number):void
		{
			this._endSize = endSize;
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
			return _gravity;
		}

		/**
		 * This method sets the gravity vector.
		 *
		 * @param gravity the gravity vector
		 */
		public function setGravity(gravity:Vector3f):void
		{
			this._gravity.copyFrom(gravity);
		}

		/**
		 * Get the high value of life.
		 *
		 * @return the high value of life.
		 *
		 * @see ParticleEmitter#setHighLife(float)
		 */
		public function getHighLife():Number
		{
			return _highLife;
		}

		/**
		 * Set the high value of life.
		 *
		 * <p>The particle's lifetime/expiration
		 * is determined by randomly selecting a time between low life and high life.
		 *
		 * @param highLife the high value of life.
		 */
		public function setHighLife(highLife:Number):void
		{
			this._highLife = highLife;
		}

		/**
		 * Get the number of images along the X axis (width).
		 *
		 * @return the number of images along the X axis (width).
		 *
		 * @see ParticleEmitter#setImagesX(int)
		 */
		public function getImagesX():int
		{
			return _imagesX;
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
		public function setImagesX(imagesX:int):void
		{
			this._imagesX = imagesX;
			_particleMesh.setImagesXY(this._imagesX, this._imagesY);
		}

		/**
		 * Get the number of images along the Y axis (height).
		 *
		 * @return the number of images along the Y axis (height).
		 *
		 * @see ParticleEmitter#setImagesY(int)
		 */
		public function getImagesY():int
		{
			return _imagesY;
		}

		/**
		 * Set the number of images along the Y axis (height).
		 *
		 * <p>To determine how multiple particle images are selected and used, see the
		 * {@link ParticleEmitter#setSelectRandomImage(boolean) } method.
		 *
		 * @param imagesY the number of images along the Y axis (height).
		 */
		public function setImagesY(imagesY:int):void
		{
			this._imagesY = imagesY;
			_particleMesh.setImagesXY(this._imagesX, this._imagesY);
		}

		/**
		 * Get the low value of life.
		 *
		 * @return the low value of life.
		 *
		 * @see ParticleEmitter#setLowLife(float)
		 */
		public function getLowLife():Number
		{
			return _lowLife;
		}

		/**
		 * Set the low value of life.
		 *
		 * <p>The particle's lifetime/expiration
		 * is determined by randomly selecting a time between low life and high life.
		 *
		 * @param lowLife the low value of life.
		 */
		public function setLowLife(lowLife:Number):void
		{
			this._lowLife = lowLife;
		}

		/**
		 * Get the number of particles to spawn per
		 * second.
		 *
		 * @return the number of particles to spawn per
		 * second.
		 *
		 * @see ParticleEmitter#setParticlesPerSec(int)
		 */
		public function getParticlesPerSec():int
		{
			return _particlesPerSec;
		}

		/**
		 * Set the number of particles to spawn per
		 * second.
		 *
		 * @param particlesPerSec the number of particles to spawn per
		 * second.
		 */
		public function setParticlesPerSec(particlesPerSec:int):void
		{
			this._particlesPerSec = particlesPerSec;
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
			return _startColor;
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
		public function setStartColor(startColor:Color):void
		{
			this._startColor.copyFrom(startColor);
		}

		public function getStartAlpha():Number
		{
			return _startAlpha;
		}

		public function setStartAlpha(alpha:Number):void
		{
			_startAlpha = alpha;
		}

		public function getEndAlpha():Number
		{
			return _endAlpha;
		}

		public function setEndAlpha(alpha:Number):void
		{
			_endAlpha = alpha;
		}

		/**
		 * Get the start color of the particles spawned.
		 *
		 * @return the start color of the particles spawned.
		 *
		 * @see ParticleEmitter#setStartSize(float)
		 */
		public function getStartSize():Number
		{
			return _startSize;
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
		public function setStartSize(startSize:Number):void
		{
			this._startSize = startSize;
		}

		/**
		 * Instantly emits all the particles possible to be emitted. Any particles
		 * which are currently inactive will be spawned immediately.
		 */
		public function emitAllParticles():void
		{
			// Force world transform to update
			checkDoTransformUpdate();

			var vars:TempVars = TempVars.getTempVars();

			var bbox:BoundingBox = this.getMesh().getBound() as BoundingBox;

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
		public function killAllParticles():void
		{
			var len:int = _particles.length;
			for (var i:int = 0; i < len; i++)
			{
				if (_particles[i].life > 0)
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
		public function killParticle(index:int):void
		{
			freeParticle(index);
		}

		/**
		 * Set to enable or disable the particle emitter
		 *
		 * <p>When a particle is
		 * disabled, it will be "frozen in time" and not update.
		 *
		 * @param enabled True to enable the particle emitter
		 */
		public function set enabled(enabled:Boolean):void
		{
			this._enabled = enabled;
		}

		/**
		 * Check if a particle emitter is enabled for update.
		 *
		 * @return True if a particle emitter is enabled for update.
		 *
		 * @see ParticleEmitter#setEnabled(boolean)
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * Callback from Control.update(), do not use.
		 * @param tpf
		 */
		public function updateFromControl(tpf:Number):void
		{
			if (_enabled)
			{
				updateParticleState(tpf);
			}
		}

		/**
		 * Callback from Control.render(), do not use.
		 *
		 * @param rm
		 * @param vp
		 */
		private var _inverseRotation:Matrix3f = new Matrix3f();

		public function renderFromControl(rm:RenderManager, vp:ViewPort):void
		{
			_inverseRotation.makeIdentity();

			if (!_worldSpace)
			{
				getWorldRotation().toMatrix3f(_inverseRotation);
				_inverseRotation.invertLocal();
			}

			_particleMesh.updateParticleData(_particles, vp.camera, _inverseRotation);
		}

		/**
		 * 初次发射粒子，对粒子位置速度等进行初始化
		 */
		private function emitParticle(min:Vector3f, max:Vector3f):Particle
		{
			var idx:uint = _lastUsed + 1;
			if (idx >= _particles.length)
			{
				return null;
			}

			var p:Particle = _particles[idx];

			if (_randomImage)
			{
				p.frame = int(Math.random() * _imagesY) * _imagesX + int(Math.random() * _imagesX);
			}

			p.totalLife = _lowLife + Math.random() * (_highLife - _lowLife);
			p.life = p.totalLife;
			p.color = _startColor.getColor();
			p.size = _startSize;

			_particleInfluencer.influenceParticle(p, _shape);

			if (_worldSpace)
			{
				mWorldTransform.transformVector(p.position, p.position);
				mWorldTransform.rotation.multiplyVector(p.velocity, p.velocity);
					// TODO: Make scale relevant somehow??
			}

			if (_randomAngle)
			{
				p.angle = Math.random() * FastMath.TWO_PI;
			}

			if (_rotateSpeed != 0)
			{
				p.spin = _rotateSpeed * (0.2 + (Math.random() * 2 - 1) * .8);
			}

			// Computing bounding volume
			temp.x = p.position.x + p.size;
			temp.y = p.position.y + p.size;
			temp.z = p.position.z + p.size;
			max.maxLocal(temp);

			temp.x = p.position.x - p.size;
			temp.y = p.position.y - p.size;
			temp.z = p.position.z - p.size;
			min.minLocal(temp);

			++_lastUsed;
			_firstUnUsed = idx + 1;
			return p;
		}

		/**
		 * 释放粒子，此粒子生命周期已经结束
		 */
		private function freeParticle(idx:int):void
		{
			var p:Particle = _particles[idx];
			p.reset();

			if (idx == _lastUsed)
			{
				while (_lastUsed >= 0 && _particles[_lastUsed].life == 0)
				{
					_lastUsed--;
				}
			}

			if (idx < _firstUnUsed)
			{
				_firstUnUsed = idx;
			}
		}

		private function swap(idx1:int, idx2:int):void
		{
			var p1:Particle = _particles[idx1];
			_particles[idx1] = _particles[idx2];
			_particles[idx2] = p1;
		}

		/**
		 * 每次循环都更新粒子信息
		 */
		private var _tColor:Color = new Color();

		/**
		 *
		 * @param p
		 * @param tpf
		 * @param min
		 * @param max
		 *
		 */
		private function updateParticle(p:Particle, tpf:Number, min:Vector3f, max:Vector3f):void
		{
			// applying gravity
			p.velocity.x -= _gravity.x * tpf;
			p.velocity.y -= _gravity.y * tpf;
			p.velocity.z -= _gravity.z * tpf;

			p.position.x += p.velocity.x * tpf;
			p.position.y += p.velocity.y * tpf;
			p.position.z += p.velocity.z * tpf;


			_tColor.setColor(p.color);

			// affecting color, size and angle
			var interp:Number = (p.totalLife - p.life) / p.totalLife;

			_tColor.lerp(_startColor, _endColor, interp);
			p.color = _tColor.getColor();
			p.alpha = FastMath.lerp(_startAlpha, _endAlpha, interp);
			p.size = FastMath.lerp(_startSize, _endSize, interp);
			p.angle += p.spin * tpf;

			if (!_randomImage)
			{
				p.frame = int(interp * _imagesX * _imagesY);
			}

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
		}

		private var _tMin:Vector3f = new Vector3f();
		private var _tMax:Vector3f = new Vector3f();

		private function updateParticleState(tpf:Number):void
		{
			// Force world transform to update
			checkDoTransformUpdate();

			_tMin.copyFrom(Vector3f.POSITIVE_INFINITY);
			_tMax.copyFrom(Vector3f.NEGATIVE_INFINITY);

			var p:Particle;
			var numPaticle:int = _particles.length;
			for (var i:int = 0; i < numPaticle; i++)
			{
				p = _particles[i];

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

				updateParticle(p, tpf, _tMin, _tMax);

				if (_firstUnUsed < i)
				{
					this.swap(_firstUnUsed, i);
					if (i == _lastUsed)
					{
						_lastUsed = _firstUnUsed;
					}
					_firstUnUsed++;
				}
			}

			// Spawns particles within the tpf timeslot with proper age
			var interval:Number = 1.0 / _particlesPerSec;
			tpf += _timeDifference;
			while (tpf > interval)
			{
				tpf -= interval;
				p = emitParticle(_tMin, _tMax);
				if (p != null)
				{
					p.life -= tpf;
					if (p.life <= 0)
					{
						freeParticle(_lastUsed);
					}
					else
					{
						updateParticle(p, tpf, _tMin, _tMax);
					}
				}
			}
			_timeDifference = tpf;

			var bbox:BoundingBox = this.getMesh().getBound() as BoundingBox;
			bbox.setMinMax(_tMin, _tMax);
			this.setBoundRefresh();
		}
	}
}

