package examples.model
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;

	import org.angle3d.app.SimpleApplication;
	import org.angle3d.collision.CollisionResult;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.material.MaterialColorFill;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Ray;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.CullHint;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.shape.Cube;
	import org.angle3d.scene.shape.Sphere;
	import org.angle3d.scene.shape.Torus;
	import org.angle3d.scene.shape.TorusKnot;
	import org.angle3d.texture.Texture2D;
	import org.angle3d.utils.Stats;

//TODO 添加箭头测试
	public class ShapeTest extends SimpleApplication
	{
		private var angle:Number;

		[Embed(source = "../../../assets/embed/no-shader.png")]
		private static var EmbedPositiveZ:Class;

		public function ShapeTest()
		{
			super();

			angle = 0;

			this.addChild(new Stats());
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);
//			flyCam.setEnabled(false);

			var colorMat:MaterialColorFill = new MaterialColorFill(0xFF0000);

			var texture:Texture2D = new Texture2D(new EmbedPositiveZ().bitmapData);
			var textureMat:MaterialTexture = new MaterialTexture(texture);

			var gm:Geometry;

			var cube:Cube = new Cube(100, 100, 100, 1, 1, 1);
			gm = new Geometry("cube", cube);
			gm.setMaterial(colorMat);
			gm.setTranslationXYZ(-100, 0, 0);
			scene.attachChild(gm);

			var colorMat2:MaterialColorFill = new MaterialColorFill(0xFFff00);
			colorMat2.technique.renderState.cullMode = Context3DTriangleFace.BACK;
			var cube2:Cube = new Cube(100, 100, 100, 1, 1, 1);
			gm = new Geometry("cube2", cube2);
			gm.setScaleXYZ(1.03, 1.03, 1.03);
			gm.setMaterial(colorMat2);
			gm.setTranslationXYZ(-100, 0, 0);
			scene.attachChild(gm);

			var torus:Torus = new Torus(50, 10, 10, 10, true);
			gm = new Geometry("torus", torus);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(100, 0, 0);
			scene.attachChild(gm);

			var torusKnot:TorusKnot = new TorusKnot(30, 10, 20, 20, false, 2, 3, 2);
			gm = new Geometry("torusKnot", torusKnot);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(100, 0, -100);
			scene.attachChild(gm);

			var sphere:Sphere = new Sphere(20, 10, 10);
			gm = new Geometry("sphere", sphere);
			gm.setMaterial(textureMat);
			gm.setTranslationXYZ(-100, 0, -100);
			scene.attachChild(gm);

			cam.location.setTo(0, 0, 300);
			cam.location.setTo(Math.cos(angle) * 300, 100, Math.sin(angle) * 300);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}

		override public function simpleUpdate(tpf:Number):void
		{
//			angle += 0.02;
//			angle %= FastMath.TWO_PI;
//			cam.location.setTo(Math.cos(angle) * 300, 100, Math.sin(angle) * 300);
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);

			var origin:Vector3f = cam.getWorldCoordinates(inputManager.getCursorPosition(), 0.0);
			var direction:Vector3f = cam.getWorldCoordinates(inputManager.getCursorPosition(), 0.3);
			direction.subtractLocal(origin).normalizeLocal();

			var ray:Ray = new Ray(origin, direction);
			var results:CollisionResults = new CollisionResults();
			scene.collideWith(ray, results);

			if (results.size > 0)
			{
				var closest:CollisionResult = results.getClosestCollision();

				trace(closest.geometry.name);
			}
		}
	}
}

