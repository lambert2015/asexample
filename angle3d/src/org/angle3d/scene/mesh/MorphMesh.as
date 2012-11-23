package org.angle3d.scene.mesh
{
	import flash.display3D.VertexBuffer3D;
	import flash.media.Video;
	import flash.utils.Dictionary;


	/**
	 * 变形动画
	 */
	public class MorphMesh extends Mesh
	{
		//当前帧
		private var mCurrentFrame:int = -1;
		private var mNextFrame:int;
		private var mTotalFrame:int;

		private var mAnimationMap:Dictionary;

		private var mUseNormal:Boolean;

		public function MorphMesh()
		{
			super();

			mType = MeshType.MT_KEYFRAME;

			mAnimationMap = new Dictionary();
		}

		/**
		 * 不需要使用normal时设置为false，提高速度
		 */
		public function get useNormal():Boolean
		{
			return mUseNormal;
		}

		public function set useNormal(value:Boolean):void
		{
			mUseNormal = value;
		}

		public function set totalFrame(value:int):void
		{
			mTotalFrame = value;
		}

		public function get totalFrame():int
		{
			return mTotalFrame;
		}

		public function addAnimation(name:String, start:int, end:int):void
		{
			mAnimationMap[name] = new MorphData(name, start, end);
		}

		public function getAnimation(name:String):MorphData
		{
			return mAnimationMap[name];
		}

		public function setFrame(curFrame:int, nextFrame:int):void
		{
			if (mCurrentFrame == curFrame)
				return;

			mCurrentFrame = curFrame;
			mNextFrame = nextFrame;

			for (var i:int = 0, length:int = mSubMeshList.length; i < length; i++)
			{
				var morphSubMesh:MorphSubMesh = mSubMeshList[i] as MorphSubMesh;
				morphSubMesh.setFrame(curFrame, nextFrame, mUseNormal);
			}
		}
	}
}
