package org.angle3d.effect.gpu
{
	import org.angle3d.material.MaterialGPUParticle;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.queue.QueueBucket;
	import org.angle3d.renderer.queue.ShadowMode;
	import org.angle3d.scene.Geometry;
	import org.angle3d.texture.TextureMapBase;

	public class ParticleShape extends Geometry
	{
		//开始时间
		private var _startTime:Number;

		//当前时间
		private var _currentTime:Number;

		//生命
		private var _totalLife:Number;

		private var _gpuMaterial:MaterialGPUParticle;

		/**
		 *
		 * @param name 名字
		 * @param texture 贴图
		 * @param totalLife 生命周期
		 * @param startTime 开始时间
		 *
		 */
		public function ParticleShape(name:String, texture:TextureMapBase, totalLife:Number, startTime:Number=0)
		{
			super(name);

			_startTime=startTime;
			_totalLife=totalLife;

			_gpuMaterial=new MaterialGPUParticle(texture);
			setMaterial(_gpuMaterial);
			localShadowMode=ShadowMode.Off;
			localQueueBucket=QueueBucket.Transparent;

			loop=true;
			_currentTime=0;
		}

		/**
		 * 使用粒子单独加速度
		 */
		public function set useLocalAcceleration(value:Boolean):void
		{
			_gpuMaterial.useLocalAcceleration=value;
		}

		public function get useLocalAcceleration():Boolean
		{
			return _gpuMaterial.useLocalAcceleration;
		}

		public function set useLocalColor(value:Boolean):void
		{
			_gpuMaterial.useLocalColor=value;
		}

		public function get useLocalColor():Boolean
		{
			return _gpuMaterial.useLocalColor;
		}

		public function set blendMode(mode:int):void
		{
			_gpuMaterial.blendMode=mode;
		}

		/**
		 * 使用自转
		 */
		public function set useSpin(value:Boolean):void
		{
			_gpuMaterial.useSpin=value;
		}

		public function get useSpin():Boolean
		{
			return _gpuMaterial.useSpin;
		}

		/**
		 * 设置全局加速度，会影响每一个粒子
		 */
		public function setAcceleration(acceleration:Vector3f):void
		{
			_gpuMaterial.setAcceleration(acceleration);
		}

		/**
		 *
		 * @param animDuration 播放速度,多长时间播放一次（秒）
		 * @param col
		 * @param row
		 *
		 */
		public function setSpriteSheet(animDuration:Number, col:int, row:int):void
		{
			_gpuMaterial.setSpriteSheet(animDuration, col, row);
		}

		public function setColor(start:uint, end:uint):void
		{
			_gpuMaterial.setColor(start, end);
		}

		public function setAlpha(start:Number, end:Number):void
		{
			_gpuMaterial.setAlpha(start, end);
		}

		public function setSize(start:Number, end:Number):void
		{
			_gpuMaterial.setSize(start, end);
		}

		public function set loop(value:Boolean):void
		{
			_gpuMaterial.loop=value;
		}

		public function get loop():Boolean
		{
			return _gpuMaterial.loop;
		}

		public function reset():void
		{
			_currentTime=0;
			_gpuMaterial.reset();
			visible=false;
		}

		public function set startTime(value:Number):void
		{
			_startTime=value;
		}

		public function get startTime():Number
		{
			return _startTime;
		}

		public function get isDead():Boolean
		{
			return !loop && (_currentTime - _startTime) >= _totalLife * 2;
		}

		/**
		 * 内部调用
		 */
		public function updateMaterial(tpf:Number):void
		{
			_currentTime+=tpf;
			_gpuMaterial.update(tpf);
		}
	}
}
