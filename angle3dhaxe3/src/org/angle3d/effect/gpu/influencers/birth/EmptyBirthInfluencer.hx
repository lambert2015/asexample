package org.angle3d.effect.gpu.influencers.birth;

import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

/**
 *
 */
class EmptyBirthInfluencer extends AbstractInfluencer implements IBirthInfluencer
{
	public function new()
	{
		super();
	}

	public function getBirth(index:Int):Float
	{
		return 0;
	}
}

