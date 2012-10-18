package org.angle3d.effect.gpu.influencers.velocity
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Vector3f;

	/**
	 * 速度为0
	 */
	public class EmptyVelocityInfluencer extends AbstractInfluencer implements IVelocityInfluencer
	{
		public function EmptyVelocityInfluencer()
		{
		}

		public function getVelocity(index:int, vector3:Vector3f):Vector3f
		{
			vector3.setTo(0.0, 0.0, 0.0);
			return vector3;
		}
	}
}
