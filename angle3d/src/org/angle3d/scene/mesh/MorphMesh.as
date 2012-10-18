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
		private var _currentFrame : int = -1;
		private var _nextFrame : int;
		private var _totalFrame : int;

		private var _animationMap : Dictionary;

		private var _useNormal : Boolean;

		public function MorphMesh()
		{
			super();

			_type = MeshType.MT_MORPH_ANIMATION;

			_animationMap = new Dictionary();
		}

		/**
		 * 不需要使用normal时设置为false，提高速度
		 */
		public function get useNormal() : Boolean
		{
			return _useNormal;
		}

		public function set useNormal(value : Boolean) : void
		{
			_useNormal = value;
		}

		public function set totalFrame(value : int) : void
		{
			_totalFrame = value;
		}

		public function get totalFrame() : int
		{
			return _totalFrame;
		}

		public function addAnimation(name : String, start : int, end : int) : void
		{
			_animationMap[name] = new MorphData(name, start, end);
		}

		public function getAnimation(name : String) : MorphData
		{
			return _animationMap[name];
		}

		public function setFrame(curFrame : int, nextFrame : int) : void
		{
			if (_currentFrame == curFrame)
				return;

			_currentFrame = curFrame;
			_nextFrame = nextFrame;

			for (var i : int = 0, length : int = _subMeshList.length; i < length; i++)
			{
				var morphSubMesh : MorphSubMesh = _subMeshList[i] as MorphSubMesh;
				morphSubMesh.setFrame(curFrame, nextFrame, _useNormal);
			}
		}
	}
}
