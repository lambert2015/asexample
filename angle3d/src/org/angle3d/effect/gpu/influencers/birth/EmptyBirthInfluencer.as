package org.angle3d.effect.gpu.influencers.birth
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	
	/**
	 * 
	 */
	public class EmptyBirthInfluencer extends AbstractInfluencer implements IBirthInfluencer
	{
		public function EmptyBirthInfluencer()
		{
			super();
		}
		
		public function getBirth(index:int):Number
		{
			return 0;
		}
	}
}