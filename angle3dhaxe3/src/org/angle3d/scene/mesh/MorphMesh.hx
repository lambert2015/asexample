package org.angle3d.scene.mesh;

import flash.display3D.VertexBuffer3D;
import flash.media.Video;
import flash.utils.Dictionary;


/**
 * 变形动画
 */
class MorphMesh extends Mesh
{
	//当前帧
	private var mCurrentFrame:Int = -1;
	private var mNextFrame:Int;
	private var mTotalFrame:Int;

	private var mAnimationMap:Dictionary;

	private var mUseNormal:Bool;

	public function new()
	{
		super();

		mType = MeshType.KEYFRAME;

		mAnimationMap = new Dictionary();
	}

	/**
	 * 不需要使用normal时设置为false，提高速度
	 */
	public function get useNormal():Bool
	{
		return mUseNormal;
	}

	public function set useNormal(value:Bool):Void
	{
		mUseNormal = value;
	}

	public function set totalFrame(value:Int):Void
	{
		mTotalFrame = value;
	}

	public function get totalFrame():Int
	{
		return mTotalFrame;
	}

	public function addAnimation(name:String, start:Int, end:Int):Void
	{
		mAnimationMap[name] = new MorphData(name, start, end);
	}

	public function getAnimation(name:String):MorphData
	{
		return mAnimationMap[name];
	}

	public function setFrame(curFrame:Int, nextFrame:Int):Void
	{
		if (mCurrentFrame == curFrame)
			return;

		mCurrentFrame = curFrame;
		mNextFrame = nextFrame;

		for (var i:Int = 0, length:Int = mSubMeshList.length; i < length; i++)
		{
			var morphSubMesh:MorphSubMesh = mSubMeshList[i] as MorphSubMesh;
			morphSubMesh.setFrame(curFrame, nextFrame, mUseNormal);
		}
	}
}
