package org.angle3d.effect.gpu.influencers.scale
{
	import org.angle3d.effect.gpu.influencers.IInfluencer;

	/**
	 * 定义粒子初始缩放
	 */
	public interface IScaleInfluencer extends IInfluencer
	{
		/**
		 * 缩放
		 */
		function getDefaultScale(index:int):Number;
	}
}
