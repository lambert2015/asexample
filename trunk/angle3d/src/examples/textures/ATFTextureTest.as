package examples.textures
{

	import flash.utils.Dictionary;

	import org.angle3d.app.SimpleApplication;
	import org.angle3d.io.AssetManager;
	import org.angle3d.material.MaterialColorFill;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.shape.Sphere;
	import org.angle3d.texture.ATFTexture;
	import org.angle3d.texture.MagFilter;
	import org.angle3d.texture.MinFilter;
	import org.angle3d.texture.Texture2D;
	import org.angle3d.texture.WrapMode;
	import org.angle3d.utils.Stats;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	public class ATFTextureTest extends SimpleApplication
	{

		private var angle:Number;

		private var gm:Geometry;

		public function ATFTextureTest()
		{
			super();

			angle = 0;

			this.addChild(new Stats());
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			cam.location = new Vector3f(0, 0, -100);
			cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);

			var assetLoader:AssetLoader = AssetManager.getInstance().createLoader("leaf");
			assetLoader.addFile("atfImage", "../asexample/angle3d/assets/crate256.atf", AssetType.BINARY);
			assetLoader.addFile("pngImage", "../asexample/angle3d/assets/crate256.png", AssetType.IMAGE);
			assetLoader.onComplete.addOnce(_loadComplete);
			assetLoader.start();
		}

		private function _loadComplete(signal:LoaderSignal, assets:Dictionary):void
		{
			var atfTexture:ATFTexture = new ATFTexture(assets["atfImage"]);
			atfTexture.setMinFilter(MinFilter.NoMip);
			atfTexture.setMagFilter(MagFilter.Bilinear);
			atfTexture.setWrapMode(WrapMode.Repeat);

			var pngTexture:Texture2D = new Texture2D(assets["pngImage"].bitmapData);

			var textureMat:MaterialTexture = new MaterialTexture(atfTexture);
			var fillMat:MaterialColorFill = new MaterialColorFill(0xff0000);

			gm = new Geometry("Sphere", new Sphere(50, 10, 10));
			gm.setMaterial(textureMat);

			scene.attachChild(gm);
		}

		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.01;
			angle %= FastMath.TWO_PI;


			cam.location = new Vector3f(Math.cos(angle) * 200, 0, Math.sin(angle) * 200);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

