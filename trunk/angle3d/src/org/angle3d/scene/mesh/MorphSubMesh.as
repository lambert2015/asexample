package org.angle3d.scene.mesh
{
	import flash.display3D.VertexBuffer3D;
	import flash.media.Video;
	import flash.utils.Dictionary;


	/**
	 * 变形动画
	 */
	public class MorphSubMesh extends SubMesh
	{
		private var mTotalFrame:int;

		private var mVerticesList:Vector.<Vector.<Number>>;

		private var mNormalList:Vector.<Vector.<Number>>;

		public function MorphSubMesh()
		{
			super();

			_merge = false;
			_vertexBuffer3DMap = new Dictionary();

			mVerticesList = new Vector.<Vector.<Number>>();
			mNormalList = new Vector.<Vector.<Number>>();
		}

		override public function set merge(value:Boolean):void
		{
			//不可用合并模式
		}

		override public function validate():void
		{
			mVerticesList.fixed = true;

			mNormalList.length = mTotalFrame;
			mNormalList.fixed = true;

			updateBound();
		}

		public function set totalFrame(value:int):void
		{
			mTotalFrame = value;
		}

		public function get totalFrame():int
		{
			return mTotalFrame;
		}

		public function getNormals(frame:int):Vector.<Number>
		{
			//需要时再创建，解析模型时一起创建耗时有点久
			if (mNormalList[frame] == null)
			{
				mNormalList[frame] = MeshHelper.buildVertexNormals(mIndices, getVertices(frame));
			}

			return mNormalList[frame];
		}

		public function addNormals(list:Vector.<Number>):void
		{
			mNormalList.push(list);
		}

		public function getVertices(frame:int):Vector.<Number>
		{
			return mVerticesList[frame];
		}

		public function addVertices(vertices:Vector.<Number>):void
		{
			mVerticesList.push(vertices);
		}

		public function setFrame(curFrame:int, nextFrame:int, useNormal:Boolean):void
		{
			//更新两帧的位置数据
			setVertexBuffer(BufferType.POSITION, 3, getVertices(curFrame));
			setVertexBuffer(BufferType.POSITION1, 3, getVertices(nextFrame));

			if (useNormal)
			{
				setVertexBuffer(BufferType.NORMAL, 3, getNormals(curFrame));
				setVertexBuffer(BufferType.NORMAL1, 3, getNormals(nextFrame));
			}
		}
	}
}
