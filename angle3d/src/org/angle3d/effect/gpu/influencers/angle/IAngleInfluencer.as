package org.angle3d.effect.gpu.influencers.angle
{
	import org.angle3d.effect.gpu.influencers.IInfluencer;

	/**
	 * 定义粒子旋转速度
	 */
	public interface IAngleInfluencer extends IInfluencer
	{
		function getDefaultAngle(index:int):Number;
	}
}
