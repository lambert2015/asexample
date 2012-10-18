package org.angle3d.effect.gpu.influencers
{
	import org.angle3d.effect.gpu.ParticleShapeGenerator;

	public interface IInfluencer
	{
		function set generator(value:ParticleShapeGenerator):void;

		function get generator():ParticleShapeGenerator;
	}
}
