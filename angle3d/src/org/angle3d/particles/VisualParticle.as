package org.angle3d.particles
{

	/**
	 * A VisualParticle is the most obvious implementation of a particle. It represents that particles that can be
	 * visualised on the screen.
	 */
	public class VisualParticle extends Particle
	{
		/** Current and original color */
		public var color:uint;
		public var originalColor:uint;

		/** zRotation is used to rotate the particle in 2D (around the Z-axis)
		 @remarks
		 There is no relation between zRotation and orientation.
		 rotationSpeed in combination with orientation are used for 3D rotation of the particle, while
		 zRotation means the rotation around the Z-axis. This type of rotation is typically used for
		 rotating textures. This also means that both types of rotation can be used together.
		 */
		public var zRotation:Number;

		/** The zRotationSpeed is used in combination with zRotation and defines tha actual rotationspeed
		 in 2D. */
		public var zRotationSpeed:Number;

		/** Does this particle have it's own dimensions? */
		public var ownDimensions:Boolean;

		/** Own width
		 */
		public var width:Number;

		/** Own height
		 */
		public var height:Number;

		//TODO 这个好像不需要
		/** Own depth
		 */
		public var depth:Number;

		/** Radius of the particle, to be used for inter-particle collision and such.
		 */
		public var radius:Number;

		/** Animation attributes
		 */
		public var textureAnimationTimeStep:Number;
		public var textureAnimationTimeStepCount:Number;
		public var textureCoordsCurrent:int;
		public var textureAnimationDirectionUp:Boolean;

		public function VisualParticle()
		{
			super(ParticleType.PT_VISUAL);

			mMarkedForEmission=true; // Default is false, but visual particles are always emitted.

			originalColor=color=0xFFFFFFFF;
			zRotation=0;
			zRotationSpeed=0;
			ownDimensions=false;
			width=height=depth=1;
			radius=0.87;

			textureAnimationTimeStep=0.1;
			textureAnimationTimeStepCount=0.1;
			textureCoordsCurrent=0;
			textureAnimationDirectionUp=true;
		}

		override public function _initForEmission():void
		{
			super._initForEmission();
			textureAnimationTimeStep=0.1;
			textureAnimationTimeStepCount=0.0;
			textureCoordsCurrent=0;
			textureAnimationDirectionUp=true;
		}

		public function setOwnDimensions(newWidth:Number, newHeight:Number, newDepth:Number):void
		{
			ownDimensions=true;
			if (newWidth)
				width=newWidth;
			if (newHeight)
				height=newHeight;
			if (newDepth)
				depth=newDepth;

			_calculateBoundingSphereRadius();

			parentEmitter.technique._notifyParticleResized();
		}

		public function _calculateBoundingSphereRadius():void
		{
			radius=0.5 * Math.max(depth, Math.max(width, height)); // approximation
		}
	}
}
