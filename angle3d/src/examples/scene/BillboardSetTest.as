package examples.scene
{
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.material.MaterialVertexColor;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.billboard.Billboard;
	import org.angle3d.scene.billboard.BillboardOriginType;
	import org.angle3d.scene.billboard.BillboardSet;
	import org.angle3d.scene.billboard.BillboardType;
	import org.angle3d.texture.BitmapTexture;

	[SWF(width = "800", height = "600", frameRate = "60")]
	//各种形状测试
	public class BillboardSetTest extends SimpleApplication
	{
		private var billboardSet:BillboardSet;
		private var angle:Number;

		[Embed(source = "../embed/no-shader.png")]
		private static var EmbedPositiveZ:Class;

		public function BillboardSetTest()
		{
			super();

			angle = 0;

			this.addChild(new Stats());
		}

		private var gm:Geometry;

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			//var colorMat:MaterialFill = new MaterialFill(0xFF0000);

			var vertexColorMat:MaterialVertexColor = new MaterialVertexColor();
			vertexColorMat.alpha = 0.5;

			var texture:BitmapTexture = new BitmapTexture(new EmbedPositiveZ().bitmapData);
			var textureMat:MaterialTexture = new MaterialTexture(texture);


			billboardSet = new BillboardSet("billboardset", 10);
			billboardSet.setOriginType(BillboardOriginType.BBO_CENTER);
			billboardSet.inWorldSpace = true;
			billboardSet.setBillboardType(BillboardType.BBT_ORIENTED_SELF);
			billboardSet.setDefaultDimensions(100, 100);
			billboardSet.setMaterial(vertexColorMat);

			billboardSet.setCommonDirection(new Vector3f(0, 0, 1));
			billboardSet.setCommonUpVector(new Vector3f(0, 0, 1));
//			billboardSet.setCommonUpVector(new Vector3f(0,0,1));

			//billboardSet.setCommonDirection(new Vector3f(1,1,1));

			billboard = billboardSet.createBillboard(new Vector3f(0, 0, 0), 0x77FF0000);
			billboard.direction.setTo(0, 1, 0);

			billboard2 = billboardSet.createBillboard(new Vector3f(50, 0, 50), 0x7700FF00);
			billboard2.direction.setTo(0.5, 0, 0.5);

			billboard2.setDimensions(50, 50);

			var billboard3:Billboard = billboardSet.createBillboard(new Vector3f(50, 50, -150), 0x770000FF);
			billboard3.direction.setTo(0, 1, 0);


			billNode = new Node("billNode");

			billNode.attachChild(billboardSet);

			//billNode.setTranslationXYZ(0, 0, -150);
			//billNode.scale(new Vector3f(0.5,0.5,0.5));
			//billNode.rotateAngles(0,70,0);

			scene.attachChild(billNode);

			cam.location.setTo(0, 150, 300);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
		private var billNode:Node;
		private var billboard:Billboard;
		private var billboard2:Billboard;
		private var _height:Number = 0;

		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;

			_height += 1;
			if (_height >= 300)
			{
				_height = -300;
			}

			//billNode.rotateAngles(0,0.3/Math.PI,0);

			if (billboard != null)
			{
				billboard.setRotation(billboard.rotation + 0.1 / Math.PI);
				billboard.rotation %= FastMath.TWO_PI;
			}

			if (billboard2 != null)
			{
				billboard2.setRotation(billboard2.rotation - 0.2 / Math.PI);
				billboard2.rotation %= FastMath.TWO_PI;
			}
//
//			cam.location.setTo(Math.cos(angle) * 300, 150, Math.sin(angle) * 300);
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

