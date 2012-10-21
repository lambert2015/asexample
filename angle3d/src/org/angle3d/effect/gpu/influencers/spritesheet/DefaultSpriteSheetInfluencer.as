package org.angle3d.effect.gpu.influencers.spritesheet
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;

	public class DefaultSpriteSheetInfluencer extends AbstractInfluencer implements ISpriteSheetInfluencer
	{
		private var _totalFrame:int;

		public function DefaultSpriteSheetInfluencer(totalFrame:int=1)
		{
			_totalFrame=totalFrame;
		}

		public function getTotalFrame():int
		{
			return _totalFrame;
		}

		public function getDefaultFrame():int
		{
			return int(Math.random() * _totalFrame);
		}
	}
}
