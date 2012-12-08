package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueCPUParticle;
	import org.angle3d.material.technique.TechniqueGPUParticle;
	import org.angle3d.math.Vector3f;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * GPU计算粒子运动，旋转，缩放，颜色变化等
	 * @author andy
	 */
	public class MaterialGPUParticle extends Material
	{
		private var _technique:TechniqueGPUParticle;

		public function MaterialGPUParticle(texture:TextureMapBase)
		{
			super();

			_technique = new TechniqueGPUParticle();
			addTechnique(_technique);

			this.texture = texture;
		}

		public function set useLocalColor(value:Boolean):void
		{
			_technique.useLocalColor = value;
		}

		public function get useLocalColor():Boolean
		{
			return _technique.useLocalColor;
		}

		public function set useLocalAcceleration(value:Boolean):void
		{
			_technique.useLocalAcceleration = value;
		}

		public function get useLocalAcceleration():Boolean
		{
			return _technique.useLocalAcceleration;
		}

		public function set blendMode(mode:int):void
		{
			_technique.renderState.blendMode = mode;
		}

		public function set loop(value:Boolean):void
		{
			_technique.setLoop(value);
		}

		public function get loop():Boolean
		{
			return _technique.getLoop();
		}

		/**
		 * 使用自转
		 */
		public function set useSpin(value:Boolean):void
		{
			_technique.setUseSpin(value);
		}

		public function get useSpin():Boolean
		{
			return _technique.getUseSpin();
		}

		public function reset():void
		{
			_technique.curTime = 0;
		}

		public function update(tpf:Number):void
		{
			_technique.curTime += tpf;
		}

		public function setAcceleration(acceleration:Vector3f):void
		{
			_technique.setAcceleration(acceleration);
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
			_technique.setSpriteSheet(animDuration, col, row);
		}

		public function setParticleColor(start:uint, end:uint):void
		{
			_technique.setColor(start, end);
		}

		public function setAlpha(start:Number, end:Number):void
		{
			_technique.setAlpha(start, end);
		}

		public function setSize(start:Number, end:Number):void
		{
			_technique.setSize(start, end);
		}

		override public function set influence(value:Number):void
		{
		}

		public function get technique():TechniqueGPUParticle
		{
			return _technique;
		}

		public function set texture(value:TextureMapBase):void
		{
			_technique.texture = value;
		}


		public function get texture():TextureMapBase
		{
			return _technique.texture;
		}
	}
}

