package org.angle3d.effect.gpu
{
	import org.angle3d.scene.Node;

	public class ParticleSystem extends Node
	{
		private var _currentTime:Number = 0;

		private var _isPlay:Boolean = false;
		private var _isPaused:Boolean = false;

		private var _shapes:Vector.<ParticleShape>;

		private var _control:ParticleSystemControl;

		public function ParticleSystem(name:String)
		{
			super(name);

			_shapes = new Vector.<ParticleShape>();

			_control = new ParticleSystemControl(this);
			addControl(_control);
		}

		public function addShape(shape:ParticleShape):void
		{
			shape.visible = false;
			this.attachChild(shape);
			if (_shapes.indexOf(shape) == -1)
				_shapes.push(shape);
		}

		public function removeShape(shape:ParticleShape):int
		{
			var index:int = _shapes.indexOf(shape);
			if (index != -1)
			{
				_shapes.splice(index, 1);
				return detachChild(shape);
			}
			return -1;
		}

		public function reset():void
		{
			_isPaused = false;

			_currentTime = 0;

			var numShape:int = _shapes.length;
			for (var i:int = 0; i < numShape; i++)
			{
				_shapes[i].reset();
			}
		}

		/**
		 *
		 * @param continueLastPlay 是否继续播放前一次暂停时的动画，否则从头开始播放
		 *
		 */
		public function play(continueLastPlay:Boolean = false):void
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

		public function pause():void
		{
			isPaused = true;
		}

		public function playOrPause():void
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

		public function stop():void
		{
			reset();
			isPlay = false;
		}

		public function set isPlay(value:Boolean):void
		{
			_isPlay = value;
			_control.enabled = _isPlay && !_isPaused;
		}

		public function get isPlay():Boolean
		{
			return _isPlay;
		}

		public function set isPaused(value:Boolean):void
		{
			_isPaused = value;
			_control.enabled = _isPlay && !_isPaused;
		}

		public function get isPaused():Boolean
		{
			return _isPaused;
		}

		/**
		 * Callback from Control.update(), do not use.
		 * @param tpf
		 */
		public function updateFromControl(tpf:Number):void
		{
			if (_isPlay && !_isPaused)
			{
				updateParticleShape(tpf);
			}
		}

		private function updateParticleShape(tpf:Number):void
		{
			var numShape:int = _shapes.length;
			for (var i:int = 0; i < numShape; i++)
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
