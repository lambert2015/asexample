package examples.material
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	import examples.skybox.DefaultSkyBox;
	import org.angle3d.material.MaterialReflective;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.WireframeGeometry;
	import org.angle3d.scene.shape.Sphere;
	import org.angle3d.scene.shape.WireframeShape;
	import org.angle3d.scene.shape.WireframeUtil;
	import org.angle3d.texture.BitmapTexture;

	public class MaterialReflectiveTest extends SimpleApplication
	{
		[Embed(source = "../embed/wall.jpg")]
		private static var DECALMAP_ASSET : Class;

		private var reflectiveSphere : Geometry;

		public function MaterialReflectiveTest()
		{
			super();

			this.addChild(new Stats());
		}

		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			flyCam.setDragToRotate(false);

			var sky : DefaultSkyBox = new DefaultSkyBox(500);

			scene.attachChild(sky);

			var decalMap : BitmapTexture = new BitmapTexture(new DECALMAP_ASSET().bitmapData);

			var material : MaterialReflective = new MaterialReflective(decalMap, sky.cubeMap, 0.8);

			var sphere : org.angle3d.scene.shape.Sphere = new org.angle3d.scene.shape.Sphere(50, 30, 30); //Sphere = new Sphere(50, 30, 30);
			reflectiveSphere = new Geometry("sphere", sphere);
			reflectiveSphere.setMaterial(material);
			scene.attachChild(reflectiveSphere);

			var wireShape : WireframeShape = WireframeUtil.generateNormalLineShape(sphere, 10);
			var wireGeom : WireframeGeometry = new WireframeGeometry("wireShape", wireShape);
			scene.attachChild(wireGeom);

			cam.location.setTo(0, 0, -200);
			cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
		}

		private var angle : Number = 0;

		override public function simpleUpdate(tpf : Number) : void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;


			cam.location.setTo(Math.cos(angle) * 200, 0, Math.sin(angle) * 200);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

