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
	import org.angle3d.effect.gpu.influencers.birth.DefaultBirthInfluencer;
	import org.angle3d.effect.gpu.influencers.life.DefaultLifeInfluencer;
	import org.angle3d.effect.gpu.influencers.position.DefaultPositionInfluencer;
	import org.angle3d.effect.gpu.influencers.position.PlanePositionInfluencer;
	import org.angle3d.effect.gpu.influencers.scale.DefaultScaleInfluencer;
	import org.angle3d.effect.gpu.influencers.spritesheet.DefaultSpriteSheetInfluencer;
	import org.angle3d.effect.gpu.influencers.velocity.DefaultVelocityInfluencer;
	import org.angle3d.effect.gpu.influencers.velocity.EmptyVelocityInfluencer;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.MaterialGPUParticle;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.texture.Texture2D;
	
	/**
	 * 
	 */
	public class CrazyFlash extends SimpleApplication
	{
		private var particleSystem:ParticleSystem;
		private var bulletShape:ParticleShape;
		
		[Embed(source = "../../../../assets/embed/spikey.png")]
		private static var EMBED_DEBRIS:Class;
		
		[Embed(source = "../../../../assets/embed/glow.png")]
		private static var EMBED_GLOW:Class;
		public function CrazyFlash()
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
			var texture:Texture2D = new Texture2D(bitmapData, false);
			
			var particleGenerator:ParticleShapeGenerator = new ParticleShapeGenerator(150, 3);
			particleGenerator.setPositionInfluencer(new PlanePositionInfluencer(new Vector3f(0, 0, 0),5,5,"xy"));
			particleGenerator.setVelocityInfluencer(new EmptyVelocityInfluencer());
			particleGenerator.setScaleInfluencer(new DefaultScaleInfluencer(1, 0.0));
			particleGenerator.setBirthInfluencer(new DefaultBirthInfluencer());
			particleGenerator.setLifeInfluencer(new DefaultLifeInfluencer(3, 3));

			bulletShape = particleGenerator.createParticleShape("bulletShape", texture);
			bulletShape.blendMode = BlendMode.AlphaAdditive;
			//bulletShape.setColor(0xffffff, 0xffffff);
			bulletShape.setAlpha(1.0, 1.0);
			bulletShape.setAcceleration(new Vector3f(0, -0.3, 0));
			bulletShape.setSize(3.0, 0.5);
			bulletShape.loop = true;
			
			var particleGenerator2:ParticleShapeGenerator = new ParticleShapeGenerator(10, 2);
			particleGenerator2.setPositionInfluencer(new PlanePositionInfluencer(new Vector3f(0, 0, 0),5,5,"xy"));
			particleGenerator2.setVelocityInfluencer(new EmptyVelocityInfluencer());
			particleGenerator2.setScaleInfluencer(new DefaultScaleInfluencer(0.5, 0.4));
			particleGenerator2.setLifeInfluencer(new DefaultLifeInfluencer(0.1, 2));
			
			bitmap = new EMBED_GLOW();
			bitmapData = bitmap.bitmapData;
			var texture2:Texture2D = new Texture2D(bitmapData, false);
			
			
			var shape:ParticleShape = particleGenerator.createParticleShape("glowShape", texture2);
			shape.blendMode = BlendMode.AlphaAdditive;
			//shape.setColor(0xffffff, 0xffffff);
			shape.setAlpha(1.0, 0);
//			shape.setAcceleration(new Vector3f(0, 0, 0));
			shape.setSize(0.3, 1.0);
			shape.loop = true;
			
			particleSystem = new ParticleSystem("bulletShapeSystem");
			particleSystem.addShape(bulletShape);
			//particleSystem.addShape(shape);
			scene.attachChild(particleSystem);
			
			cam.location.setTo(0, 0, -3);
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
