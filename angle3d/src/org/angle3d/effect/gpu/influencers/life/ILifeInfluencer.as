package org.angle3d.effect.gpu.influencers.life
{
	import org.angle3d.effect.gpu.influencers.IInfluencer;

	/**
	 * 定义粒子生命周期
	 */
	public interface ILifeInfluencer extends IInfluencer
	{
		/**
		 * 生命
		 */
		function getLife(index:int):Number;
	}
}
