package org.angle3d.scene.control
{
	import org.angle3d.material.Material;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.MorphGeometry;
	import org.angle3d.scene.Spatial;
	import org.angle3d.scene.mesh.MorphMesh;
	import org.angle3d.scene.mesh.MorphData;

	/**
	 * 变形动画控制器
	 */
	//TODO 添加两个不同动画之间的过渡
	//TODO 添加一个可以倒播的动画，比如一个人物行走倒播就是人物倒着走的动画
	public class MorphControl extends AbstractControl
	{
		private var _morphData:MorphData;
		private var _fps:Number;
		private var _loop:Boolean;

		private var _curFrame:Number;
		private var _nextFrame:int;

		private var _pause:Boolean;

		private var _node:MorphGeometry;
		private var _mesh:MorphMesh;
		private var _material:Material;

		private var _curAnimation:String;
		private var _oldAnimation:String;

		public function MorphControl()
		{
			super();
		}

		public function setAnimationSpeed(value:Number):void
		{
			_fps = value / 60;
		}

		private function get material():Material
		{
			if (_material == null)
			{
				_material = _node.getMaterial();
			}
			return _material;
		}

		private function get mesh():MorphMesh
		{
			if (_mesh == null)
			{
				_mesh = _node.morphMesh;
			}
			return _mesh;
		}

		/**
		 *
		 * @param animationName 动画名称
		 * @param animationFPS 播放速度
		 * @param loop 是否循环
		 * @param fadOutTime 前一个动画淡出时间，如果有的话
		 */
		public function playAnimation(animation:String, loop:Boolean = true, fadeOutTime:Number = 0.5):void
		{
			_oldAnimation = _curAnimation;

			_curAnimation = animation;

			_morphData = mesh.getAnimation(_curAnimation);
			_loop = loop;

			_pause = false;
			if (_morphData != null)
			{
				_curFrame = _morphData.start;
				_nextFrame = _curFrame + 1;
			}
		}

		//TODO 可能需要添加一些参数，用于控制在什么位置停止动画
		public function stop():void
		{
			_pause = true;
		}

		override public function cloneForSpatial(spatial:Spatial):Control
		{
			var control:MorphControl = new MorphControl();
			control.spatial = spatial;
			control.enabled = enabled;
			return control;
		}

		override public function set spatial(spatial:Spatial):void
		{
			super.spatial = spatial;
			_node = spatial as MorphGeometry;
		}

		override protected function controlUpdate(tpf:Number):void
		{
			if (_pause || _morphData == null)
				return;

			_curFrame += _fps;

			if (!_loop && _curFrame >= _morphData.end)
			{
				_nextFrame = _curFrame = _morphData.end;
				_pause = !_loop;
			}
			else
			{
				if (_curFrame >= _morphData.end + 1)
				{
					//循环情况下,_curFrame超过最后一帧后，不应该立即设为_keyframe.start,
					//因为此时正在做最后一帧和开始帧之间的插值计算，所以要等到
					//_curFrame >= _keyframe.end + 1时才设为_keyframe.start
					_curFrame = _morphData.start;
				}
				_nextFrame = int(_curFrame + 1);
				if (_nextFrame > _morphData.end)
					_nextFrame = _morphData.start;
			}

			mesh.setFrame(int(_curFrame), _nextFrame);

			//influence是两帧之间的插值，传递给Shader用于计算最终位置
			material.influence = _curFrame - int(_curFrame);
		}
	}
}
