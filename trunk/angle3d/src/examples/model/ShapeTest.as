package examples.model
{
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.material.MaterialFill;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.shape.Cube;
	import org.angle3d.scene.shape.Sphere;
	import org.angle3d.scene.shape.Torus;
	import org.angle3d.scene.shape.TorusKnot;
	import org.angle3d.texture.BitmapTexture;
	import org.angle3d.utils.Stats;
	

	public class ShapeTest extends SimpleApplication
	{
		private var angle : Number;

		[Embed(source = "../embed/no-shader.png")]
		private static var EmbedPositiveZ : Class;

		public function ShapeTest()
		{
			super();

			angle = 0;

			this.addChild(new Stats());
		}

		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			var colorMat : MaterialFill = new MaterialFill(0xFF0000);

			var texture : BitmapTexture = new BitmapTexture(new EmbedPositiveZ().bitmapData);
			var textureMat : MaterialTexture = new MaterialTexture(texture);

			var gm : Geometry;

			var cube : Cube = new Cube(100, 100, 100, 1, 1, 1);
			gm = new Geometry("cube", cube);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(-100, 0, 0);
			scene.attachChild(gm);

			var torus : Torus = new Torus(50, 10, 10, 10, true);
			gm = new Geometry("torus", torus);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(100, 0, 0);
			scene.attachChild(gm);

			var torusKnot : TorusKnot = new TorusKnot(50, 10, 100, 400, false, 2, 3, 1);
			gm = new Geometry("torusKnot", torusKnot);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(100, 0, -100);
			scene.attachChild(gm);

			var sphere : Sphere = new Sphere(20, 20, 50);
			gm = new Geometry("sphere", sphere);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(-100, 0, -100);
			scene.attachChild(gm);

			cam.location.setTo(0, 0, 300);
		}

		override public function simpleUpdate(tpf : Number) : void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;


			cam.location.setTo(Math.cos(angle) * 300, 100, Math.sin(angle) * 300);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

