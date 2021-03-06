package examples.effect.gpu
{
	import flash.events.MouseEvent;

	import org.angle3d.app.SimpleApplication;
	import org.angle3d.effect.gpu.ParticleShape;
	import org.angle3d.effect.gpu.ParticleShapeGenerator;
	import org.angle3d.effect.gpu.ParticleSystem;
	import org.angle3d.effect.gpu.influencers.angle.DefaultAngleInfluencer;
	import org.angle3d.effect.gpu.influencers.color.RandomColorInfluencer;
	import org.angle3d.effect.gpu.influencers.life.DefaultLifeInfluencer;
	import org.angle3d.effect.gpu.influencers.position.PlanePositionInfluencer;
	import org.angle3d.effect.gpu.influencers.scale.DefaultScaleInfluencer;
	import org.angle3d.effect.gpu.influencers.spin.DefaultSpinInfluencer;
	import org.angle3d.effect.gpu.influencers.velocity.DefaultVelocityInfluencer;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.texture.Texture2D;
	import org.angle3d.utils.Stats;

	/**
	 * 下雪测试
	 */
	public class SnowTest extends SimpleApplication
	{
		private var particleSystem:ParticleSystem;
		private var snowShape:ParticleShape;
		private var angle:Number = 0;

		[Embed(source = "../../../../assets/embed/snow.png")]
		private static var EMBED_SNOW:Class;

		public function SnowTest()
		{
			super();

			this.addChild(new Stats());
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			this.viewPort.setBackgroundColor(0x0);

			flyCam.setDragToRotate(true);

			var texture:Texture2D = new Texture2D(new EMBED_SNOW().bitmapData, false);

			var particleGenerator:ParticleShapeGenerator = new ParticleShapeGenerator(1000, 8);
			particleGenerator.setPositionInfluencer(new PlanePositionInfluencer(new Vector3f(0, 10, 0), 20, 20));
			particleGenerator.setScaleInfluencer(new DefaultScaleInfluencer(0.5, 0.3));
			particleGenerator.setVelocityInfluencer(new DefaultVelocityInfluencer(new Vector3f(0, -4, 0), 0.3));
			particleGenerator.setLifeInfluencer(new DefaultLifeInfluencer(4, 8));
			particleGenerator.setAngleInfluencer(new DefaultAngleInfluencer());
			particleGenerator.setSpinInfluencer(new DefaultSpinInfluencer(3, 0.7));
			//使用自定义粒子颜色
			particleGenerator.setColorInfluencer(new RandomColorInfluencer());
			//particleGenerator.setAlphaInfluencer(new RandomAlphaInfluencer());

			snowShape = particleGenerator.createParticleShape("Snow", texture);
			snowShape.useSpin = true;
			snowShape.loop = true;
			snowShape.setAlpha(0.9, 0.0);
//			snowShape.setColor(0xffffff, 0xffffff);
			snowShape.setAcceleration(new Vector3f(0, -1.5, 0));
			snowShape.setSize(1, 1);

			var snowShape2:ParticleShape = particleGenerator.createParticleShape("Snow2", texture);
			snowShape2.startTime = 1;
			snowShape2.useSpin = true;
			snowShape2.loop = true;
			snowShape2.setAlpha(0.9, 0);
			snowShape2.setColor(0xff0000, 0xffff00);
			snowShape2.setAcceleration(new Vector3f(0, 0, 0));
			snowShape2.setSize(1, 1);

			particleSystem = new ParticleSystem("SnowSystem");
			particleSystem.addShape(snowShape);
			particleSystem.addShape(snowShape2);
			scene.attachChild(particleSystem);

			particleSystem.play();

			cam.location.setTo(0, 8, 10);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);

			this.stage.doubleClickEnabled = true;
			this.stage.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClickHandler);
		}

		private function _doubleClickHandler(e:MouseEvent):void
		{
			particleSystem.playOrPause();

			//snowShape.reset();
		}


		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.03;
			angle %= FastMath.TWO_PI;

//			cam.location.setTo(Math.cos(angle) * 10, 10, Math.sin(angle) * 10);
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}
