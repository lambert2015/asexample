package org.angle3d.effect.gpu
{
	import org.angle3d.scene.Node;

	class ParticleSystem extends Node
	{
		private var _currentTime:Float = 0;

		private var _isPlay:Bool = false;
		private var _isPaused:Bool = false;

		private var _shapes:Vector<ParticleShape>;

		private var _control:ParticleSystemControl;

		public function ParticleSystem(name:String)
		{
			super(name);

			_shapes = new Vector<ParticleShape>();

			_control = new ParticleSystemControl(this);
			addControl(_control);
		}

		public function addShape(shape:ParticleShape):Void
		{
			shape.visible = false;
			this.attachChild(shape);
			if (_shapes.indexOf(shape) == -1)
				_shapes.push(shape);
		}

		public function removeShape(shape:ParticleShape):Int
		{
			var index:Int = _shapes.indexOf(shape);
			if (index != -1)
			{
				_shapes.splice(index, 1);
				return detachChild(shape);
			}
			return -1;
		}

		public function reset():Void
		{
			_isPaused = false;

			_currentTime = 0;

			var numShape:Int = _shapes.length;
			for (var i:Int = 0; i < numShape; i++)
			{
				_shapes[i].reset();
			}
		}

		/**
		 *
		 * @param continueLastPlay 是否继续播放前一次暂停时的动画，否则从头开始播放
		 *
		 */
		public function play(continueLastPlay:Bool = false):Void
		{
			if (continueLastPlay && _isPaused)
			{
				_isPaused = false;
			}
			else
			{
				reset();
			}

			isPlay = true;
		}

		public function pause():Void
		{
			isPaused = true;
		}

		public function playOrPause():Void
		{
			if (_isPaused)
			{
				play(true);
			}
			else
			{
				pause();
			}
		}

		public function stop():Void
		{
			reset();
			isPlay = false;
		}

		public function set isPlay(value:Bool):Void
		{
			_isPlay = value;
			_control.enabled = _isPlay && !_isPaused;
		}

		public function get isPlay():Bool
		{
			return _isPlay;
		}

		public function set isPaused(value:Bool):Void
		{
			_isPaused = value;
			_control.enabled = _isPlay && !_isPaused;
		}

		public function get isPaused():Bool
		{
			return _isPaused;
		}

		/**
		 * Callback from Control.update(), do not use.
		 * @param tpf
		 */
		public function updateFromControl(tpf:Float):Void
		{
			if (_isPlay && !_isPaused)
			{
				updateParticleShape(tpf);
			}
		}

		private function updateParticleShape(tpf:Float):Void
		{
			var numShape:Int = _shapes.length;
			for (var i:Int = 0; i < numShape; i++)
			{
				var shape:ParticleShape = _shapes[i];
				//粒子未开始或者已死亡
				if (shape.startTime > _currentTime || shape.isDead)
				{
					shape.visible = false;
				}
				else
				{
					shape.visible = true;
					shape.updateMaterial(tpf);
				}
			}

			_currentTime += tpf;
		}
	}
}
