package examples.effect.gpu
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
	import org.angle3d.effect.gpu.influencers.position.CylinderPositionInfluencer;
	import org.angle3d.effect.gpu.influencers.position.DefaultPositionInfluencer;
	import org.angle3d.effect.gpu.influencers.scale.DefaultScaleInfluencer;
	import org.angle3d.effect.gpu.influencers.velocity.DefaultVelocityInfluencer;
	import org.angle3d.effect.gpu.influencers.velocity.EmptyVelocityInfluencer;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.MaterialGPUParticle;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.texture.Texture2D;

	//TODO 是否添加可用多个颜色
	public class FireTest extends SimpleApplication
	{
		private var particleSystem:ParticleSystem;
		private var fireShape:ParticleShape;

		[Embed(source = "../../../../assets/embed/smoke.png")]
		private static var EMBED_SMOKE:Class;

		public function FireTest()
		{
			super();

			this.addChild(new Stats());
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			mViewPort.setBackgroundColor(0x0);

			flyCam.setDragToRotate(true);

			var bitmap:Bitmap = new EMBED_SMOKE();
			var bitmapData:BitmapData = bitmap.bitmapData;
			var texture:Texture2D = new Texture2D(bitmapData, false);

			var particleGenerator:ParticleShapeGenerator = new ParticleShapeGenerator(500, 2);
			particleGenerator.setPositionInfluencer(new DefaultPositionInfluencer(new Vector3f(0, 0, 0)));
			particleGenerator.setVelocityInfluencer(new DefaultVelocityInfluencer(new Vector3f(0, 1.5, 0), 0.2));
			particleGenerator.setScaleInfluencer(new DefaultScaleInfluencer(0.5, 0.2));
			particleGenerator.setLifeInfluencer(new DefaultLifeInfluencer(1, 2));

			fireShape = particleGenerator.createParticleShape("Fire", texture);
			fireShape.setAlpha(0.6, 0);
			fireShape.setColor(0xffff00, 0xff0000);
			fireShape.setAcceleration(new Vector3f(0, .3, 0));
			fireShape.setSize(1, 3);

			var smokeGenerator:ParticleShapeGenerator = new ParticleShapeGenerator(200, 2);
			smokeGenerator.setPositionInfluencer(new CylinderPositionInfluencer(0, new Vector3f(0, 1, 0), 0.3, true));
			smokeGenerator.setVelocityInfluencer(new DefaultVelocityInfluencer(new Vector3f(0, 1.5, 0), 0.2));
			smokeGenerator.setScaleInfluencer(new DefaultScaleInfluencer(1, 0.2));
			smokeGenerator.setLifeInfluencer(new DefaultLifeInfluencer(1, 2));

			var smoke:ParticleShape = smokeGenerator.createParticleShape("Smoke", texture);
			smoke.setAlpha(0, 0.5);
			smoke.setColor(0x111111, 0x111111);
			smoke.setAcceleration(new Vector3f(0, 0.3, 0));
			smoke.setSize(1, 3);
			smoke.startTime = 1;

			particleSystem = new ParticleSystem("FireSystem");
			particleSystem.addShape(fireShape);
			particleSystem.addShape(smoke);
			scene.attachChild(particleSystem);
			particleSystem.play();

			cam.location.setTo(0, 5, 10);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);

			this.stage.doubleClickEnabled = true;
			this.stage.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClickHandler);
		}

		private function _doubleClickHandler(e:MouseEvent):void
		{
			particleSystem.playOrPause();
		}

		private var angle:Number = 0;

		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.03;
			angle %= FastMath.TWO_PI;

//			var fx:Number = Math.cos(angle) * 5;
//			var fy:Number = Math.sin(angle) * 5;
//			fireShape.setTranslationXYZ(fx, 0, fy);

//			cam.location.setTo(Math.cos(angle) * 20, 10, Math.sin(angle) * 20);
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}
