package org.angle3d.examples.effect.gpu
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import org.angle3d.utils.Stats;

	import org.angle3d.app.SimpleApplication;
	import org.angle3d.effect.gpu.ParticleShape;
	import org.angle3d.effect.gpu.ParticleShapeGenerator;
	import org.angle3d.effect.gpu.ParticleSystem;
	import org.angle3d.effect.gpu.influencers.life.DefaultLifeInfluencer;
	import org.angle3d.effect.gpu.influencers.position.DefaultPositionInfluencer;
	import org.angle3d.effect.gpu.influencers.scale.DefaultScaleInfluencer;
	import org.angle3d.effect.gpu.influencers.spritesheet.DefaultSpriteSheetInfluencer;
	import org.angle3d.effect.gpu.influencers.velocity.DefaultVelocityInfluencer;
	import org.angle3d.material.MaterialGPUParticle;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.texture.BitmapTexture;

	/**
	 * 测试SpriteSheet模式
	 */
	public class BulletTest extends SimpleApplication
	{
		private var particleSystem:ParticleSystem;
		private var bulletShape:ParticleShape;

		[Embed(source = "../../embed/bullet.png")]
		private static var EMBED_DEBRIS:Class;

		public function BulletTest()
		{
			super();

			this.addChild(new Stats());
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			var bitmap:Bitmap = new EMBED_DEBRIS();
			var bitmapData:BitmapData = bitmap.bitmapData;
			var texture:BitmapTexture = new BitmapTexture(bitmapData, false);

			var particleGenerator:ParticleShapeGenerator = new ParticleShapeGenerator(50, 5);
			particleGenerator.setPositionInfluencer(new DefaultPositionInfluencer(new Vector3f(0, 0, 0)));
			particleGenerator.setVelocityInfluencer(new DefaultVelocityInfluencer(new Vector3f(1.0, 8, 1), 0.3));
			particleGenerator.setScaleInfluencer(new DefaultScaleInfluencer(0.5, 0.0));
			particleGenerator.setLifeInfluencer(new DefaultLifeInfluencer(4, 5));
			particleGenerator.setSpriteSheetInfluencer(new DefaultSpriteSheetInfluencer(16));

			bulletShape = particleGenerator.createParticleShape("bulletShape", texture);
			//bulletShape.setColor(0xffffff, 0xffffff);
			bulletShape.setAlpha(1.0, 1.0);
			bulletShape.setAcceleration(new Vector3f(0, -3, 0));
			bulletShape.setSpriteSheet(0.05, 4, 4);
			bulletShape.setSize(0.5, 0.5);
			bulletShape.loop = true;

			particleSystem = new ParticleSystem("bulletShapeSystem");
			particleSystem.addShape(bulletShape);
			scene.attachChild(particleSystem);

			cam.location.setTo(0, 5, -3);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);

			particleSystem.play();

			this.stage.doubleClickEnabled = true;
			this.stage.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClickHandler);
		}

		private function _doubleClickHandler(e:MouseEvent):void
		{
			particleSystem.playOrPause()
		}

		private var angle:Number = 0;

		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.03;
			angle %= FastMath.TWO_PI;

//			cam.location.setTo(Math.cos(angle) * 5, 10, Math.sin(angle) * 5);
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}
