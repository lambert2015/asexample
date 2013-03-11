package org.angle3d.effect.gpu.influencers;

import org.angle3d.effect.gpu.ParticleShapeGenerator;

interface IInfluencer
{
	function set generator(value:ParticleShapeGenerator):Void;

	function get generator():ParticleShapeGenerator;
}

