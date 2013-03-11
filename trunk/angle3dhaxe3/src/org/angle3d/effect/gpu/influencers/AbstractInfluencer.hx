package org.angle3d.effect.gpu.influencers;

import org.angle3d.effect.gpu.ParticleShapeGenerator;

class AbstractInfluencer implements IInfluencer
{
	private var _generator:ParticleShapeGenerator;

	public function new()
	{
	}

	public function set generator(value:ParticleShapeGenerator):Void
	{
		_generator = value;
	}

	public function get generator():ParticleShapeGenerator
	{
		return _generator;
	}
}
