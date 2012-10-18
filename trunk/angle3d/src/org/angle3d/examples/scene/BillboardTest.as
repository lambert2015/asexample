package org.angle3d.examples.scene
{
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.material.MaterialFill;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.control.Alignment;
	import org.angle3d.scene.control.BillboardControl;
	import org.angle3d.scene.shape.Cube;
	import org.angle3d.scene.shape.TorusKnot;
	import org.angle3d.texture.BitmapTexture;

	[SWF(width = "800", height = "600", frameRate = "60")]
	//各种形状测试
	public class BillboardTest extends SimpleApplication
	{
		private var angle:Number;

		[Embed(source = "../embed/no-shader.png")]
		private static var EmbedPositiveZ:Class;

		public function BillboardTest()
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

			var colorMat:MaterialFill = new MaterialFill(0xFF0000);

			var texture:BitmapTexture = new BitmapTexture(new EmbedPositiveZ().bitmapData);
			var textureMat:MaterialTexture = new MaterialTexture(texture);


			var billboardControl:BillboardControl = new BillboardControl();
			billboardControl.setAlignment(Alignment.Camera);

			var cube:Cube = new Cube(100, 10, 100, 1, 1, 1);
			gm = new Geometry("cube", cube);
			gm.setMaterial(textureMat);
			gm.addControl(billboardControl);
			scene.attachChild(gm);
			
			var torusKnot : TorusKnot = new TorusKnot(50, 10, 100, 400, false, 2, 3, 1);
			var gm2:Geometry = new Geometry("torusKnot", torusKnot);
			gm2.setMaterial(textureMat);
			gm2.setTranslationXYZ(100, 0, -100);
			scene.attachChild(gm2);

			cam.location.setTo(0, 150, 300);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}

		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;

//			gm.rotateAngles(0.0, 0.2, 0);

			cam.location.setTo(Math.cos(angle) * 300, 150, Math.sin(angle) * 300);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

