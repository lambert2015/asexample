package examples.effect.cpu
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.effect.cpu.ParticleEmitter;
	import org.angle3d.material.MaterialCPUParticle;
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.texture.Texture2D;

	public class MovingParticleTest extends SimpleApplication
	{
		private var emit:ParticleEmitter;
		private var angle:Number;

		[Embed(source = "../../../../assets/embed/smoke.png")]
		private static var EMBED_SMOKE:Class;


		public function MovingParticleTest()
		{
			super();

			angle = 0;
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);
			
			flyCam.setDragToRotate(true);

			emit = new ParticleEmitter("Emitter", 1000);
			emit.setGravity(new Vector3f(0, 0.3, 0));
			emit.setLowLife(1);
			emit.setHighLife(5);
			emit.setStartColor(new Color(1.0,0.0,0.0));
			emit.setEndColor(new Color(1.0,1.0,0.0));
			emit.setStartAlpha(0.4);
			emit.setEndAlpha(0.0);
			
			emit.setStartSize(0.5);
			emit.setEndSize(2);
			emit.particleInfluencer.setVelocityVariation(0.1);
			emit.particleInfluencer.setInitialVelocity(new Vector3f(0, 2.5, 0));
			//emit.setImagesX(15);
			
			var bitmap:Bitmap = new EMBED_SMOKE();
			var bitmapData:BitmapData = bitmap.bitmapData;
			var texture:Texture2D = new Texture2D(bitmapData, false);

			var material:MaterialCPUParticle = new MaterialCPUParticle(texture);
			emit.setMaterial(material);

			scene.attachChild(emit);
		}

		override public function simpleUpdate(tpf:Number):void
		{
			angle += tpf;
			angle %= FastMath.TWO_PI;
			var fx:Number = Math.cos(angle) * 2;
			var fy:Number = Math.sin(angle) * 2;
			emit.setTranslationXYZ(fx, 0, fy);
		}
	}
}
