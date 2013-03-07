package org.angle3d.scene.mesh;

import flash.display3D.VertexBuffer3D;
import flash.media.Video;
import flash.utils.Dictionary;


/**
 * 变形动画
 */
class MorphSubMesh extends SubMesh
{
	private var mTotalFrame:Int;

	private var mVerticesList:Vector<Vector<Float>>;

	private var mNormalList:Vector<Vector<Float>>;

	public function new()
	{
		super();

		_merge = false;
		_vertexBuffer3DMap = new Dictionary();

		mVerticesList = new Vector<Vector<Float>>();
		mNormalList = new Vector<Vector<Float>>();
	}

	override public function set merge(value:Bool):Void
	{
		//不可用合并模式
	}

	override public function validate():Void
	{
		mVerticesList.fixed = true;

		mNormalList.length = mTotalFrame;
		mNormalList.fixed = true;

		updateBound();
	}

	public function set totalFrame(value:Int):Void
	{
		mTotalFrame = value;
	}

	public function get totalFrame():Int
	{
		return mTotalFrame;
	}

	public function getNormals(frame:Int):Vector<Float>
	{
		//需要时再创建，解析模型时一起创建耗时有点久
		if (mNormalList[frame] == null)
		{
			mNormalList[frame] = MeshHelper.buildVertexNormals(mIndices, getVertices(frame));
		}

		return mNormalList[frame];
	}

	public function addNormals(list:Vector<Float>):Void
	{
		mNormalList.push(list);
	}

	public function getVertices(frame:Int):Vector<Float>
	{
		return mVerticesList[frame];
	}

	public function addVertices(vertices:Vector<Float>):Void
	{
		mVerticesList.push(vertices);
	}

	public function setFrame(curFrame:Int, nextFrame:Int, useNormal:Bool):Void
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
