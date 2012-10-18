package org.angle3d.cinematic;

import flash.Vector;
import org.angle3d.utils.HashMap;
/**
 * ...
 * @author andy
 */

class TimeLine
{
	private var map:HashMap<Int,KeyFrame>;
	private var keyFramesPerSeconds:Float;
	private var lastKeyFrameIndex:Int;

	public function new() 
	{
		map = new HashMap<Int,KeyFrame>();
		keyFramesPerSeconds = 30;
		lastKeyFrameIndex = 0;
	}
	
	public function getKeyFrameAtTime(time:Float):KeyFrame
	{
        return map.getValue(getKeyFrameIndexFromTime(time));
    }

    public function getKeyFrameAtIndex(keyFrameIndex:Int):KeyFrame
	{
        return map.getValue(keyFrameIndex);
    }

    public function addKeyFrameAtTime(time:Float, keyFrame:KeyFrame):Void  
	{
        addKeyFrameAtIndex(getKeyFrameIndexFromTime(time), keyFrame);
    }

    public function addKeyFrameAtIndex(keyFrameIndex:Int,keyFrame:KeyFrame):Void 
	{
        map.setValue(keyFrameIndex, keyFrame);
        keyFrame.setIndex(keyFrameIndex);
        if (lastKeyFrameIndex < keyFrameIndex) 
		{
            lastKeyFrameIndex = keyFrameIndex;
        }
    }

    public function removeKeyFrame(keyFrameIndex:Int):Void 
	{
		map.delete(keyFrameIndex);
        if (lastKeyFrameIndex == keyFrameIndex) 
		{
            var kf:KeyFrame = null;
			var i:Int = keyFrameIndex;
			while(kf == null && i >= 0)
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

    public function getKeyFrameIndexFromTime(time:Float):Int
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

    public function getLastKeyFrameIndex():Int
	{
        return lastKeyFrameIndex;
    }
	
}