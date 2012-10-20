package examples.animation
{
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.material.MaterialFill;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.shape.Cube;
	import org.angle3d.scene.shape.Sphere;
	import org.angle3d.texture.BitmapTexture;

	public class SurroundTest extends SimpleApplication
	{
		private var angle:Number;

		[Embed(source = "../embed/no-shader.png")]
		private static var EmbedPositiveZ:Class;

		public function SurroundTest()
		{
			super();

			angle = 0;

			this.addChild(new Stats());
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			var colorMat:MaterialFill = new MaterialFill(0xFF0000);

			var texture:BitmapTexture = new BitmapTexture(new EmbedPositiveZ().bitmapData);
			var textureMat:MaterialTexture = new MaterialTexture(texture);

			var gm:Geometry;

			var cube:Cube = new Cube(20, 20, 20, 1, 1, 1);
			gm = new Geometry("cube", cube);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(0, 0, 0);
			scene.attachChild(gm);

			var sphere:Sphere = new Sphere(20, 20, 10);
			sphereGM = new Geometry("sphere", sphere);
			sphereGM.setMaterial(textureMat);
			sphereGM.setTranslationXYZ(-50, 0, 0);
			scene.attachChild(sphereGM);

			cam.location.setTo(0, 0, 300);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
		private var sphereGM:Geometry;

		private var _radius:Number = 50;

		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;

			sphereGM.y += 0.2;
			sphereGM.x = _radius * Math.cos(angle);
			sphereGM.z = _radius * Math.sin(angle);


//			cam.location.setTo(Math.cos(angle) * 300, 100, Math.sin(angle) * 300);
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

