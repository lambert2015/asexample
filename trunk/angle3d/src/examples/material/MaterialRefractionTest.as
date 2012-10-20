package examples.material
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	import examples.skybox.DefaultSkyBox;
	import org.angle3d.material.MaterialRefraction;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.shape.Sphere;
	import org.angle3d.texture.BitmapTexture;

	public class MaterialRefractionTest extends SimpleApplication
	{
		[Embed(source = "../embed/rock.jpg")]
		private static var DECALMAP_ASSET : Class;

		private var reflectiveSphere : Geometry;

		public function MaterialRefractionTest()
		{
			super();

			this.addChild(new Stats());
		}

		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			flyCam.setDragToRotate(true);

			var sky : DefaultSkyBox = new DefaultSkyBox(500);

			scene.attachChild(sky);

			var decalMap : BitmapTexture = new BitmapTexture(new DECALMAP_ASSET().bitmapData);

//			Vacuum 1.0
//			Air 1.0003
//			Water 1.3333
//			Glass 1.5
//			Plastic 1.5
//			Diamond	 2.417
			var material : MaterialRefraction = new MaterialRefraction(decalMap, sky.cubeMap, 1.5, 0.6);

			var sphere : Sphere = new Sphere(50, 30, 30);
			reflectiveSphere = new Geometry("sphere", sphere);
			reflectiveSphere.setMaterial(material);
			scene.attachChild(reflectiveSphere);


//			var cube : Cone = new Cone(50, 50, 20);
//			var cubeG : Geometry = new Geometry("cube", cube);
//			cubeG.setMaterial(material);
//			scene.attachChild(cubeG);
//
//			cubeG.setTranslationTo(-100, 0, 0);

			cam.location.setTo(0, 0, -200);
			cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
		}

		private var angle : Number = 0;

		override public function simpleUpdate(tpf : Number) : void
		{
			angle += 0.01;
			angle %= FastMath.TWO_PI;


			cam.location.setTo(Math.cos(angle) * 200, 50, Math.sin(angle) * 200);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

