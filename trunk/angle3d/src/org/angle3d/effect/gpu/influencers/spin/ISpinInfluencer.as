package org.angle3d.effect.gpu.influencers.spin
{
	import org.angle3d.effect.gpu.influencers.IInfluencer;

	/**
	 * 定义粒子初始自转角度
	 */
	public interface ISpinInfluencer extends IInfluencer
	{
		function getSpin(index:int):Number;
	}
}
