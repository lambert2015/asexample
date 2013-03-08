package org.angle3d.scene.mesh;

import haxe.ds.StringMap;


/**
 * 变形动画
 */
class MorphMesh extends Mesh
{
	//当前帧
	private var mCurrentFrame:Int = -1;
	private var mNextFrame:Int;
	private var mTotalFrame:Int;

	private var mAnimationMap:StringMap<MorphData>;

	private var mUseNormal:Bool;

	public function new()
	{
		super();

		mType = MeshType.KEYFRAME;

		mAnimationMap = new StringMap<MorphData>();
	}

	/**
	 * 不需要使用normal时设置为false，提高速度
	 */
	public var useNormal(get, set):Bool;
	private function get_useNormal():Bool
	{
		return mUseNormal;
	}

	private function set_useNormal(value:Bool):Bool
	{
		mUseNormal = value;
		return mUseNormal;
	}

	public var totalFrame(get, set):Int;
	private function set_totalFrame(value:Int):Int
	{
		mTotalFrame = value;
		return mTotalFrame;
	}

	private function get_totalFrame():Int
	{
		return mTotalFrame;
	}

	public function addAnimation(name:String, start:Int, end:Int):Void
	{
		mAnimationMap.set(name,new MorphData(name, start, end));
	}

	public function getAnimation(name:String):MorphData
	{
		return mAnimationMap.get(name);
	}

	public function setFrame(curFrame:Int, nextFrame:Int):Void
	{
		if (mCurrentFrame == curFrame)
			return;

		mCurrentFrame = curFrame;
		mNextFrame = nextFrame;

		for (i in 0...mSubMeshList.length)
		{
			var morphSubMesh:MorphSubMesh = cast mSubMeshList[i];
			morphSubMesh.setFrame(curFrame, nextFrame, mUseNormal);
		}
	}
}
