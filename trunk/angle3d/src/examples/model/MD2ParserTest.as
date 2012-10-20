package examples.model
{
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.angle3d.app.SimpleApplication;
	import examples.skybox.DefaultSkyBox;
	import org.angle3d.io.AssetManager;
	import org.angle3d.io.parser.md2.MD2Parser;
	import org.angle3d.material.MaterialFill;
	import org.angle3d.material.MaterialNormalColor;
	import org.angle3d.material.MaterialReflective;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.mesh.MorphMesh;
	import org.angle3d.scene.MorphGeometry;
	import org.angle3d.scene.Node;
	import org.angle3d.texture.BitmapTexture;
	import org.angle3d.utils.Stats;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;
	
	public class MD2ParserTest extends SimpleApplication
	{
		
		private var angle:Number;
		
		private var monster:MorphGeometry;
		private var weapon:MorphGeometry;
		private var animations:Array = ["stand", "run", "attack", "pain", "jump", "flip", "salute", "taunt", "wave", "point", "crwalk", "crpain", "crdeath", "death"];
		
		private var animationIndex:int = 0;
		private var speed:Number = 2;
		
		public function MD2ParserTest()
		{
			super();
		}
		
		private function _changeAnimation(e:Event):void
		{
			if (animationIndex > animations.length - 1)
			{
				animationIndex = 0;
			}
			playAnimation(animations[animationIndex++], true);
		}
		
		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);
			
			angle = 0;
			
			this.addChild(new Stats());
			
			flyCam.setDragToRotate(true);
			
			var assetLoader:AssetLoader = AssetManager.getInstance().createLoader("md2Loader");
			assetLoader.addFile("ratamahatta", "assets/md2/ratamahatta.md2", AssetType.BINARY);
			assetLoader.addFile("w_rlauncher", "assets/md2/w_rlauncher.md2", AssetType.BINARY);
			assetLoader.addFile("ratamahatta_texture", "assets/md2/ctf_r.png", AssetType.IMAGE);
			assetLoader.addFile("w_rlauncher_texture", "assets/md2/w_rlauncher.png", AssetType.IMAGE);
			assetLoader.onComplete.addOnce(_loadComplete);
			assetLoader.start();
		}
		
		private function _loadComplete(signal:LoaderSignal, assets:Dictionary):void
		{
			var monsterMaterial:MaterialTexture = new MaterialTexture(new BitmapTexture(assets["ratamahatta_texture"].bitmapData));
			var weaponMaterial:MaterialTexture = new MaterialTexture(new BitmapTexture(assets["w_rlauncher_texture"].bitmapData));
			
			var fillMaterial:MaterialFill = new MaterialFill(0x008822);
			var normalMaterial:MaterialNormalColor = new MaterialNormalColor();
			
			var skybox:DefaultSkyBox = new DefaultSkyBox(500);
			scene.attachChild(skybox);
			
			var reflectiveMat:MaterialReflective = new MaterialReflective(new BitmapTexture(assets["ratamahatta_texture"].bitmapData), skybox.cubeMap, 0.9);
			
			var parser:MD2Parser = new MD2Parser();
			var monsterMesh:MorphMesh = parser.parse(assets["ratamahatta"]);
			monsterMesh.useNormal = false;
			
			var weaponMesh:MorphMesh = parser.parse(assets["w_rlauncher"]);
			weaponMesh.useNormal = false;
			
			var team:Node = new Node("team");
			
			monster = new MorphGeometry("monster", monsterMesh);
			monster.setMaterial(monsterMaterial);
			team.attachChild(monster);
			
			weapon = new MorphGeometry("weapon", weaponMesh);
			weapon.setMaterial(weaponMaterial);
			team.attachChild(weapon);
			team.rotateAngles(0, -45 / Math.PI, 0);
			
			scene.attachChild(team);
			
			setAnimationSpeed(5);
			_changeAnimation(null);
			
			cam.location = new Vector3f(0, 0, 80);
			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
		
		private function playAnimation(name:String, loop:Boolean):void
		{
			monster.playAnimation(name, loop);
			weapon.playAnimation(name, loop);
		}
		
		private function setAnimationSpeed(speed:Number):void
		{
			monster.setAnimationSpeed(speed);
			weapon.setAnimationSpeed(speed);
		}
		
		override public function simpleUpdate(tpf:Number):void
		{
			angle += 0.02;
			angle %= FastMath.TWO_PI;
		
//			cam.setLocation(new Vector3f(Math.cos(angle) * 80, 0, Math.sin(angle) * 80));
//			cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		}
	}
}

