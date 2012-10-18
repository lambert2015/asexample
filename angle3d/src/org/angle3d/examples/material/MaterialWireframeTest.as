package org.angle3d.examples.material
{
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.WireframeGeometry;
	import org.angle3d.scene.shape.Box;
	import org.angle3d.scene.shape.Cube;
	import org.angle3d.scene.shape.TorusKnot;
	import org.angle3d.scene.shape.WireframeCube;
	import org.angle3d.scene.shape.WireframeGrid;
	import org.angle3d.scene.shape.WireframeShape;
	import org.angle3d.scene.shape.WireframeUtil;
	import org.angle3d.utils.Stats;

	public class MaterialWireframeTest extends SimpleApplication
	{
		private var geometry : Geometry;

		private var angle : Number;

		private var movingNode : Node;

		[Embed(source = "../embed/no-shader.png")]
		private static var EmbedPositiveZ : Class;

		public function MaterialWireframeTest()
		{
			super();

			angle = 0;

			this.addChild(new Stats());
		}

		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			var cube : WireframeCube = new WireframeCube(100, 100, 100);
			var wireGm : WireframeGeometry = new WireframeGeometry("WireGeometry", cube);
			wireGm.materialWireframe.color = 0x007700;
			scene.attachChild(wireGm);

			wireGm.setTranslationXYZ(0, 0, 0);

			var grid : WireframeGrid = new WireframeGrid(10, 110, 1);
			wireGm = new WireframeGeometry("WireframeGrid", grid);
			wireGm.materialWireframe.color = 0x000088;
			wireGm.rotateAngles(15 / 180 * Math.PI, 50 / 180 * Math.PI, 30 / 180 * Math.PI);
			scene.attachChild(wireGm);

			var solidCube : Cube = new Cube(100, 100, 100, 1, 1, 1);
			var solidBox : Box = new Box(100, 100, 100);

			var wireCube : WireframeShape = WireframeUtil.generateWireframe(solidCube);
			var wireCubeGeometry : WireframeGeometry = new WireframeGeometry("wireCube", wireCube);
			wireCubeGeometry.rotateAngles(45 / 180 * Math.PI, 0, 0);
			wireCubeGeometry.setTranslationXYZ(50, 0, 0);
			scene.attachChild(wireCubeGeometry);

			var torusKnot : TorusKnot = new TorusKnot(50, 10, 20, 20, false, 2, 3, 1);
			var wireTorusKnot : WireframeShape = WireframeUtil.generateWireframe(torusKnot);
			var gm : WireframeGeometry = new WireframeGeometry("sphere", wireTorusKnot);
			gm.setTranslationXYZ(-50, 50, 0);
			scene.attachChild(gm);

			movingNode = new Node("lightParentNode");
			scene.attachChild(movingNode);

			cam.location.setTo(0, 0, 300);
		}

		override public function simpleUpdate(tpf : Number) : void
		{
			angle += 0.03;
			angle %= FastMath.TWO_PI;


			cam.location.setTo(Math.cos(angle) * 300, 0, Math.sin(angle) * 300);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

