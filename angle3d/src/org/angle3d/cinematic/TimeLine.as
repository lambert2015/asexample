package org.angle3d.cinematic
{


	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author andy
	 */

	public class TimeLine
	{
		private var map:Dictionary; //<int,KeyFrame>;
		private var keyFramesPerSeconds:Number;
		private var lastKeyFrameIndex:int;

		public function TimeLine()
		{
			map=new Dictionary();
			keyFramesPerSeconds=30;
			lastKeyFrameIndex=0;
		}

		public function getKeyFrameAtTime(time:Number):KeyFrame
		{
			return map[getKeyFrameIndexFromTime(time)];
		}

		public function getKeyFrameAtIndex(keyFrameIndex:int):KeyFrame
		{
			return map[keyFrameIndex];
		}

		public function addKeyFrameAtTime(time:Number, keyFrame:KeyFrame):void
		{
			addKeyFrameAtIndex(getKeyFrameIndexFromTime(time), keyFrame);
		}

		public function addKeyFrameAtIndex(keyFrameIndex:int, keyFrame:KeyFrame):void
		{
			map[keyFrameIndex]=keyFrame;
			keyFrame.setIndex(keyFrameIndex);
			if (lastKeyFrameIndex < keyFrameIndex)
			{
				lastKeyFrameIndex=keyFrameIndex;
			}
		}

		public function removeKeyFrame(keyFrameIndex:int):void
		{
			delete map[keyFrameIndex];
			if (lastKeyFrameIndex == keyFrameIndex)
			{
				var kf:KeyFrame=null;
				var i:int=keyFrameIndex;
				while (kf == null && i >= 0)
				{
					kf=getKeyFrameAtIndex(i);
					lastKeyFrameIndex=i;

					i--;
				}
			}
		}

		public function removeKeyFrameByTime(time:Number):void
		{
			removeKeyFrame(getKeyFrameIndexFromTime(time));
		}

		public function getKeyFrameIndexFromTime(time:Number):int
		{
			return Math.round(time * keyFramesPerSeconds);
		}

		public function getKeyFrameTime(keyFrame:KeyFrame):Number
		{
			return keyFrame.getIndex() / keyFramesPerSeconds;
		}

		public function getAllKeyFrames():Vector.<KeyFrame>
		{
			return map.toVector();
		}

		public function getLastKeyFrameIndex():int
		{
			return lastKeyFrameIndex;
		}
	}
}

