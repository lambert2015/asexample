package examples.model
{
	import flash.utils.Dictionary;
	import org.angle3d.animation.AnimChannel;
	import org.angle3d.animation.SkeletonAnimControl;
	import org.angle3d.animation.SkeletonControl;
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.cinematic.LoopMode;
	import org.angle3d.io.AssetManager;
	import org.angle3d.io.parser.ms3d.MS3DParser;
	import org.angle3d.material.MaterialFill;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.queue.QueueBucket;
	import org.angle3d.scene.debug.SkeletonDebugger;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.shape.Cube;
	import org.angle3d.texture.BitmapTexture;
	import org.angle3d.utils.Stats;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	public class MS3DSkinnedMeshTest extends SimpleApplication
	{
		public function MS3DSkinnedMeshTest()
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

		private var material:MaterialTexture;

		private function _loadComplete(signal:LoaderSignal, assets:Dictionary):void
		{
			flyCam.setDragToRotate(true);

			material = new MaterialTexture(new BitmapTexture(assets["ninjaSkin"].bitmapData));

			var parser:MS3DParser = new MS3DParser();


			for (var i:int = 0; i < 5; i++)
			{
				for (var j:int = 0; j < 5; j++)
				{
					var node:Node = createNinja(parser, assets);
					node.setTranslationXYZ((i - 3) * 15, 0, (j - 3) * 15);
					scene.attachChild(node);
				}
			}

			cam.location.setTo(0, 15, -100);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}

		private function createNinja(parser:MS3DParser, assets:Dictionary):Node
		{
			var ninjaNode:Node = parser.parseSkinnedMesh("ninja", assets["ninja"]);
			ninjaNode.setMaterial(material);

			var skeletonControl:SkeletonControl = ninjaNode.getControlByClass(SkeletonControl) as SkeletonControl;

			//attatchNode
//			var boxNode:Node = new Node("box");
//			var gm:Geometry = new Geometry("cube", new Cube(0.5, 0.5, 5, 1, 1, 1));
//			gm.setMaterial(new MaterialFill(0xff0000, 1.0));
//			gm.localQueueBucket = QueueBucket.Opaque;
//			boxNode.attachChild(gm);

//			var attachNode:Node = skeletonControl.getAttachmentsNode("Joint29");
//			attachNode.attachChild(boxNode);

			var animControl:SkeletonAnimControl = ninjaNode.getControlByClass(SkeletonAnimControl) as SkeletonAnimControl;
			var channel:AnimChannel = animControl.createChannel();
			channel.playAnimation("default", LoopMode.Cycle, 10);

			var skeletonDebugger:SkeletonDebugger = new SkeletonDebugger("skeletonDebugger", skeletonControl.getSkeleton(), 0.1);
			ninjaNode.attachChild(skeletonDebugger);

			return ninjaNode;
		}

		private function _loadError(signal:LoaderSignal):void
		{
			trace(signal.numListeners);
		}

		private var angle:Number = 0;

		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.01;
			angle %= FastMath.TWO_PI;

			//cam.location.setTo(Math.cos(angle) * 15, 15, Math.sin(angle) * 15);
			//cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}
