package examples.model;

import flash.utils.Dictionary;

import org.angle3d.animation.AnimChannel;
import org.angle3d.animation.Animation;
import org.angle3d.animation.Bone;
import org.angle3d.animation.Skeleton;
import org.angle3d.animation.SkeletonAnimControl;
import org.angle3d.animation.SkeletonControl;
import org.angle3d.app.SimpleApplication;
import org.angle3d.cinematic.LoopMode;
import org.angle3d.io.AssetManager;
import org.angle3d.io.parser.ms3d.MS3DParser;
import org.angle3d.material.MaterialTexture;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.debug.SkeletonDebugger;
import org.angle3d.scene.mesh.SkinnedMesh;
import org.angle3d.texture.Texture2D;
import org.angle3d.utils.Stats;
import org.assetloader.AssetLoader;
import org.assetloader.base.AssetType;
import org.assetloader.signals.LoaderSignal;
import org.angle3d.animation.Bone;

class MS3DSkinnedMeshTest extends SimpleApplication
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

	private var material:MaterialTexture;
	private var skinnedMesh:SkinnedMesh;
	private var animation:Animation;
	private var bones:Vector.<Bone>;

	private function _loadComplete(signal:LoaderSignal, assets:Dictionary):Void
	{
		flyCam.setDragToRotate(true);

		material = new MaterialTexture(new Texture2D(assets["ninjaSkin"].bitmapData));

		var parser:MS3DParser = new MS3DParser();

		skinnedMesh = parser.parseSkinnedMesh("ninja", assets["ninja"]);
		var array:Array = parser.buildSkeleton();
		bones = array[0];
		animation = array[1];

		for (var i:int = 0; i < 5; i++)
		{
			for (var j:int = 0; j < 5; j++)
			{
				var node:Node = createNinja(i);
				node.setTranslationXYZ((i - 3) * 15, 0, (j - 3) * 15);
				scene.attachChild(node);
			}
		}

		cam.location.setTo(0, 15, -100);
		cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
	}

	private function createNinja(index:int):Node
	{
		var geometry:Geometry = new Geometry("ninja" + index, skinnedMesh);

		var ninjaNode:Node = new Node("ninja" + index);
		ninjaNode.attachChild(geometry);
		ninjaNode.setMaterial(material);

		var newBones:Vector.<Bone> = new Vector.<Bone>();
		for (var i:uint = 0, il:uint = bones.length; i < il; i++)
		{
			newBones[i] = bones[i].clone();
		}

		var skeleton:Skeleton = new Skeleton(newBones);
		var skeletonControl:SkeletonControl = new SkeletonControl(geometry, skeleton);
		var animationControl:SkeletonAnimControl = new SkeletonAnimControl(skeleton);
		animationControl.addAnimation("default", animation);

		ninjaNode.addControl(skeletonControl);
		ninjaNode.addControl(animationControl);

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

	private function _loadError(signal:LoaderSignal):Void
	{
		trace(signal.numListeners);
	}

	private var angle:Number = 0;

	override public function simpleUpdate(tpf:Number):Void
	{
		angle += 0.01;
		angle %= FastMath.TWO_PI;

		cam.location.setTo(Math.cos(angle) * 50, 20, Math.sin(angle) * 60);
		cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
	}
}
