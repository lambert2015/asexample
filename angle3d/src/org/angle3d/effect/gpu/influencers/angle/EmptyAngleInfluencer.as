package org.angle3d.effect.gpu.influencers.angle
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	public class EmptyAngleInfluencer extends AbstractInfluencer implements IAngleInfluencer
	{
		public function EmptyAngleInfluencer()
		{
		}
		
		public function getDefaultAngle(index:int):Number
		{
			return 0;
		}
	}
}