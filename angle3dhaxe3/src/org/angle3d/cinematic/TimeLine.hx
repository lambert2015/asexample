package org.angle3d.cinematic
{


	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author andy
	 */
//TODO 换一种实现
	public class TimeLine
	{
		private var map:Dictionary; //<int,KeyFrame>;
		private var keyFramesPerSeconds:Float;
		private var lastKeyFrameIndex:int;

		public function TimeLine()
		{
			map = new Dictionary();
			keyFramesPerSeconds = 30;
			lastKeyFrameIndex = 0;
		}

		public function getKeyFrameAtTime(time:Float):KeyFrame
		{
			return map[getKeyFrameIndexFromTime(time)];
		}

		public function getKeyFrameAtIndex(keyFrameIndex:int):KeyFrame
		{
			return map[keyFrameIndex];
		}

		public function addKeyFrameAtTime(time:Float, keyFrame:KeyFrame):Void
		{
			addKeyFrameAtIndex(getKeyFrameIndexFromTime(time), keyFrame);
		}

		public function addKeyFrameAtIndex(keyFrameIndex:int, keyFrame:KeyFrame):Void
		{
			map[keyFrameIndex] = keyFrame;
			keyFrame.setIndex(keyFrameIndex);
			if (lastKeyFrameIndex < keyFrameIndex)
			{
				lastKeyFrameIndex = keyFrameIndex;
			}
		}

		public function removeKeyFrame(keyFrameIndex:int):Void
		{
			delete map[keyFrameIndex];
			if (lastKeyFrameIndex == keyFrameIndex)
			{
				var kf:KeyFrame = null;
				var i:int = keyFrameIndex;
				while (kf == null && i >= 0)
				{
					kf = getKeyFrameAtIndex(i);
					lastKeyFrameIndex = i;

					i--;
				}
			}
		}

		public function removeKeyFrameByTime(time:Float):Void
		{
			removeKeyFrame(getKeyFrameIndexFromTime(time));
		}

		public function getKeyFrameIndexFromTime(time:Float):int
		{
			return Math.round(time * keyFramesPerSeconds);
		}

		public function getKeyFrameTime(keyFrame:KeyFrame):Float
		{
			return keyFrame.getIndex() / keyFramesPerSeconds;
		}

		public function getAllKeyFrames():Vector<KeyFrame>
		{
			return map.toVector();
		}

		public function getLastKeyFrameIndex():int
		{
			return lastKeyFrameIndex;
		}
	}
}

