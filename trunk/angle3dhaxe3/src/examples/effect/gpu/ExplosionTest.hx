package examples.effect.gpu;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;

import org.angle3d.utils.Stats;

import org.angle3d.app.SimpleApplication;
import org.angle3d.effect.gpu.ParticleShape;
import org.angle3d.effect.gpu.ParticleShapeGenerator;
import org.angle3d.effect.gpu.ParticleSystem;
import org.angle3d.effect.gpu.influencers.acceleration.ExplosionAccelerationInfluencer;
import org.angle3d.effect.gpu.influencers.angle.DefaultAngleInfluencer;
import org.angle3d.effect.gpu.influencers.birth.EmptyBirthInfluencer;
import org.angle3d.effect.gpu.influencers.life.DefaultLifeInfluencer;
import org.angle3d.effect.gpu.influencers.life.SameLifeInfluencer;
import org.angle3d.effect.gpu.influencers.position.DefaultPositionInfluencer;
import org.angle3d.effect.gpu.influencers.scale.DefaultScaleInfluencer;
import org.angle3d.effect.gpu.influencers.spin.DefaultSpinInfluencer;
import org.angle3d.effect.gpu.influencers.spritesheet.DefaultSpriteSheetInfluencer;
import org.angle3d.effect.gpu.influencers.velocity.RandomVelocityInfluencer;
import org.angle3d.material.MaterialGPUParticle;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.texture.Texture2D;

/**
 * 爆炸效果
 */
class ExplosionTest extends SimpleApplication
{
	private var particleSystem:ParticleSystem;

	[Embed(source = "../../../../assets/embed/Explosion/Debris.png")]
	private static var EMBED_SMOKE:Class;

	public function ExplosionTest()
	{
		super();

		this.addChild(new Stats());
	}

	override protected function initialize(width:int, height:int):void
	{
		super.initialize(width, height);

		flyCam.setDragToRotate(true);


		var bitmap:Bitmap = new EMBED_SMOKE();
		var bitmapData:BitmapData = bitmap.bitmapData;
		var texture:Texture2D = new Texture2D(bitmapData, false);

		var particleGenerator:ParticleShapeGenerator = new ParticleShapeGenerator(500, 2);
		particleGenerator.setPositionInfluencer(new DefaultPositionInfluencer(new Vector3f(0, 0, 0)));
		particleGenerator.setScaleInfluencer(new DefaultScaleInfluencer(0.5, 0));
		particleGenerator.setVelocityInfluencer(new RandomVelocityInfluencer(10, 0));
		particleGenerator.setBirthInfluencer(new EmptyBirthInfluencer());
		particleGenerator.setLifeInfluencer(new SameLifeInfluencer(2));
		particleGenerator.setAccelerationInfluencer(new ExplosionAccelerationInfluencer(3));
		particleGenerator.setSpriteSheetInfluencer(new DefaultSpriteSheetInfluencer(9));
		particleGenerator.setAngleInfluencer(new DefaultAngleInfluencer());
		particleGenerator.setSpinInfluencer(new DefaultSpinInfluencer(3, 0.7));

		var explosionShape:ParticleShape = particleGenerator.createParticleShape("Explosion", texture);
		explosionShape.setAlpha(0.8, 0);
		//explosionShape.setColor(0xff0000, 0xffff00);
//			explosionShape.setAcceleration(new Vector3f(0, -15, 0));
		explosionShape.setSpriteSheet(0.1, 3, 3);
		explosionShape.setSize(1, 1);
		explosionShape.loop = true;

		particleSystem = new ParticleSystem("Explosion");
		particleSystem.addShape(explosionShape);
		scene.attachChild(particleSystem);
		particleSystem.play();

		cam.location.setTo(0, 8, 10);
		cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);

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



//			cam.location.setTo(Math.cos(angle) * 20, 10, Math.sin(angle) * 20);
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
	}
}
