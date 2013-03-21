package examples.model;

import flash.utils.Dictionary;

import org.angle3d.app.SimpleApplication;
import org.angle3d.io.AssetManager;
import org.angle3d.io.parser.ms3d.MS3DParser;
import org.angle3d.material.MaterialTexture;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.texture.Texture2D;
import org.angle3d.utils.Stats;
import org.assetloader.AssetLoader;
import org.assetloader.base.AssetType;
import org.assetloader.signals.LoaderSignal;



class MS3DStaticModelParserTest extends SimpleApplication
{
	public function new()
	{
		super();


		var assetLoader:AssetLoader = AssetManager.getInstance().createLoader("ms3dLoader");
		assetLoader.addFile("ninja", "../asexample/angle3d/assets/ms3d/ninja.ms3d", AssetType.BINARY);
		assetLoader.addFile("ninjaSkin", "../asexample/angle3d/assets/ms3d/nskinbr.jpg", AssetType.IMAGE);
		assetLoader.onComplete.addOnce(_loadComplete);
		assetLoader.onError.add(_loadError);
		assetLoader.start();

		this.addChild(new Stats());
	}

	private function _loadComplete(signal:LoaderSignal, assets:Dictionary):Void
	{
		flyCam.setDragToRotate(true);


		var material:MaterialTexture = new MaterialTexture(new Texture2D(assets["ninjaSkin"].bitmapData));

		var parser:MS3DParser = new MS3DParser();

		var geomtry:Geometry = new Geometry("ninja", parser.parseStaticMesh(assets["ninja"]));
		geomtry.setMaterial(material);
		scene.attachChild(geomtry);

		geomtry.setTranslationXYZ(0, -5, 0);

		cam.location.setTo(0, 5, -20);
		cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
	}

	private function _loadError(signal:LoaderSignal):Void
	{

	}

	private var angle:Number = 0;

	override public function simpleUpdate(tpf:Number):Void
	{
		angle += 0.02;
		angle %= FastMath.TWO_PI;


		cam.location.setTo(Math.cos(angle) * 20, 0, Math.sin(angle) * 20);
		cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
	}
}
