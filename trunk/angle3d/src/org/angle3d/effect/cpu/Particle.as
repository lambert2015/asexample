package org.angle3d.effect.cpu
{
	import org.angle3d.math.Color;
	import org.angle3d.math.Vector3f;

	/**
	 * a single particle .
	 *
	 */
	public class Particle
	{
		/**
		 * Particle velocity.
		 * 速度
		 */
		public var velocity:Vector3f;

		/**
		 * Current particle position
		 * 位置
		 */
		public var position:Vector3f;

		/**
		 * Particle color
		 * 颜色
		 */
		public var color:uint;

		/**
		 * Particle Alpha
		 */
		public var alpha:Number;

		/**
		 * 缩放比例
		 */
		public var size:Number;

		/**
		 * Particle remaining life, in seconds.
		 * 生命剩余时间
		 */
		public var life:Number;

		/**
		 * The initial particle life
		 *
		 */
		public var totalLife:Number;

		/**
		 * Particle rotation angle (in radians).
		 * 角度
		 */
		public var angle:Number;

		/**
		 * Particle rotation angle speed (in radians).
		 */
		public var spin:Number;

		/**
		 * Particle image index.
		 */
		public var frame:int;

		public function Particle()
		{
			velocity = new Vector3f();
			position = new Vector3f();
			color = 0x0;
			alpha = 1.0;

			size = 0;
			angle = 0;
			spin = 0;
			frame = 0;
			totalLife = 0;
			life = 0;
		}

		public function reset():void
		{
			color = 0x0;
			alpha = 1.0;

			size = 0;
			angle = 0;
			spin = 0;
			frame = 0;
			totalLife = 0;
			life = 0;
		}
	}
}

