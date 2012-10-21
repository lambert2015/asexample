package examples.model
{

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.angle3d.app.SimpleApplication;
	import examples.skybox.DefaultSkyBox;
	import org.angle3d.io.AssetManager;
	import org.angle3d.io.parser.max3ds.Max3DSParser;
	import org.angle3d.io.parser.ParserOptions;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.texture.BitmapTexture;
	import org.angle3d.utils.Stats;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;
	
	

	public class Max3DSParserTest extends SimpleApplication
	{

		private var angle : Number;

		private var gm : Geometry;

		public function Max3DSParserTest()
		{
			super();

			angle = 0;

			this.addChild(new Stats());
		}

		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);

			//flyCam.setDragToRotate(true);

			var assetLoader : AssetLoader = AssetManager.getInstance().createLoader("max3dsLoader");
			assetLoader.addFile("ship", "../assets/max3ds/ship.3ds", AssetType.BINARY);
			assetLoader.addFile("ship_texture", "../assets/max3ds/ship.jpg", AssetType.IMAGE);
			assetLoader.onComplete.addOnce(_loadComplete);
			assetLoader.start();
		}

		private function _loadComplete(signal : LoaderSignal, assets : Dictionary) : void
		{
			var bitmapTexture : BitmapTexture = new BitmapTexture(assets["ship_texture"].bitmapData);
			var material : MaterialTexture = new MaterialTexture(bitmapTexture);
			material.doubleSide = true;

			var sky : DefaultSkyBox = new DefaultSkyBox(500);
			scene.attachChild(sky);

			var data : ByteArray = assets["ship"];
			var parser : Max3DSParser = new Max3DSParser();
			parser.parse(data, new ParserOptions());

			var mesh : Mesh = parser.mesh;

			var geom : Geometry = new Geometry("ship", mesh);

			geom.setMaterial(material);

			scene.attachChild(geom);
		}

		override public function simpleUpdate(tpf : Number) : void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;


			cam.location.setTo(Math.cos(angle) * 800, 200, Math.sin(angle) * 800);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

