package org.angle3d.examples.model
{
	import flash.utils.Dictionary;
	
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.io.AssetManager;
	import org.angle3d.io.parser.ms3d.MS3DParser;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.texture.BitmapTexture;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	public class MS3DStaticModelParserTest extends SimpleApplication
	{
		public function MS3DStaticModelParserTest()
		{
			super();


			var assetLoader : AssetLoader = AssetManager.getInstance().createLoader("ms3dLoader");
			assetLoader.addFile("ninja", "assets/ms3d/ninja.ms3d", AssetType.BINARY);
			assetLoader.addFile("ninjaSkin", "assets/ms3d/nskinbr.jpg", AssetType.IMAGE);
			assetLoader.onComplete.addOnce(_loadComplete);
			assetLoader.onError.add(_loadError);
			assetLoader.start();
			
			this.addChild(new Stats());
		}

		private function _loadComplete(signal : LoaderSignal, assets : Dictionary) : void
		{
			flyCam.setDragToRotate(true);


			var material : MaterialTexture = new MaterialTexture(new BitmapTexture(assets["ninjaSkin"].bitmapData));

			var parser : MS3DParser = new MS3DParser();

			var geomtry : Geometry = parser.parseStaticMesh("ninja",assets["ninja"]);
			geomtry.setMaterial(material);
			scene.attachChild(geomtry);
			
			geomtry.setTranslationXYZ(0,-5,0);

			cam.location.setTo(0, 5, -20);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}

		private function _loadError(signal : LoaderSignal) : void
		{

		}
		
		private var angle:Number=0;
		override public function simpleUpdate(tpf : Number) : void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;
			
			
			cam.location.setTo(Math.cos(angle) * 20, 0, Math.sin(angle) * 20);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}
