package org.angle3d.effect.gpu.influencers.color
{
	import org.angle3d.effect.gpu.influencers.IInfluencer;
	import org.angle3d.math.Color;

	/**
	 * 粒子初始颜色
	 */
	public interface IColorInfluencer extends IInfluencer
	{
		function getColor(index:int,color:Color):Color;
	}
}