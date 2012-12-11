package examples.effect.gpu
{
	import flash.events.MouseEvent;

	import org.angle3d.app.SimpleApplication;
	import org.angle3d.effect.gpu.ParticleShape;
	import org.angle3d.effect.gpu.ParticleShapeGenerator;
	import org.angle3d.effect.gpu.ParticleSystem;
	import org.angle3d.effect.gpu.influencers.birth.PerSecondBirthInfluencer;
	import org.angle3d.effect.gpu.influencers.life.SameLifeInfluencer;
	import org.angle3d.effect.gpu.influencers.position.CirclePositionInfluencer;
	import org.angle3d.effect.gpu.influencers.scale.DefaultScaleInfluencer;
	import org.angle3d.effect.gpu.influencers.velocity.DefaultVelocityInfluencer;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.texture.Texture2D;
	import org.angle3d.utils.Stats;

	/**
	 * 下雪测试
	 */
	public class SwordTest extends SimpleApplication
	{
		private var particleSystem:ParticleSystem;
		private var swordShape:ParticleShape;
		private var angle:Number = 0;

		[Embed(source = "../../../../assets/embed/sword.jpg")]
		private static var EMBED_SWORD:Class;

		public function SwordTest()
		{
			super();

			this.addChild(new Stats());
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			var texture:Texture2D = new Texture2D(new EMBED_SWORD().bitmapData, false);

			var particleGenerator:ParticleShapeGenerator = new ParticleShapeGenerator(90, 3);
			particleGenerator.setPositionInfluencer(new CirclePositionInfluencer(new Vector3f(0, 10, 0), 3, 0));
			particleGenerator.setScaleInfluencer(new DefaultScaleInfluencer(1, 0));
			particleGenerator.setVelocityInfluencer(new DefaultVelocityInfluencer(new Vector3f(0, -1, 0), 0));
			particleGenerator.setBirthInfluencer(new PerSecondBirthInfluencer(0.7));
			particleGenerator.setLifeInfluencer(new SameLifeInfluencer(3));
			//particleGenerator.setAngleInfluencer(new EmptyAngleInfluencer());
			//particleGenerator.setSpinInfluencer(new DefaultSpinInfluencer(3, 2.1));


			swordShape = particleGenerator.createParticleShape("sword", texture);
			swordShape.useSpin = false;
			swordShape.loop = true;
			swordShape.setAlpha(0.7, 0);
			swordShape.setColor(0xff0000, 0xffff00);
			swordShape.setAcceleration(new Vector3f(0, -1.5, 0));
			swordShape.setSize(3, 1);

			particleSystem = new ParticleSystem("swordSystem");
			particleSystem.addShape(swordShape);
			scene.attachChild(particleSystem);
			particleSystem.play();

			cam.location.setTo(0, 0, 10);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);

			this.stage.doubleClickEnabled = true;
			this.stage.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClickHandler);
		}

		private function _doubleClickHandler(e:MouseEvent):void
		{
			particleSystem.playOrPause();
		}


		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.03;
			angle %= FastMath.TWO_PI;

			//cam.location.setTo(Math.cos(angle) * 20, 10, Math.sin(angle) * 20);
			//cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}
