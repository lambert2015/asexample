package org.angle3d.effect.gpu.influencers
{
	import org.angle3d.effect.gpu.ParticleShapeGenerator;

	public class AbstractInfluencer implements IInfluencer
	{
		protected var _generator:ParticleShapeGenerator;

		public function AbstractInfluencer()
		{
		}

		public function set generator(value:ParticleShapeGenerator):void
		{
			_generator = value;
		}

		public function get generator():ParticleShapeGenerator
		{
			return _generator;
		}
	}
}
