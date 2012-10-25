package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.loaders.parsers.MD2Parser;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;

	public class Basic_LoadMD2 extends Sprite
	{
		//signature swf
		[Embed(source = "/../embeds/signature.swf", symbol = "Signature")]
		public static var SignatureSwf:Class;

		//plane textures
		[Embed(source = "/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;

		//Perelith Knight diffuse texture 1
		[Embed(source = "/../embeds/pknight/pknight1.png")]
		public static var PKnightTexture1:Class;

		//Perelith Knight diffuse texture 2
		[Embed(source = "/../embeds/pknight/pknight2.png")]
		public static var PKnightTexture2:Class;

		//Perelith Knight diffuse texture 3
		[Embed(source = "/../embeds/pknight/pknight3.png")]
		public static var PKnightTexture3:Class;

		//Perelith Knight diffuse texture 4
		[Embed(source = "/../embeds/pknight/pknight4.png")]
		public static var PKnightTexture4:Class;

		//Perelith Knight model
		[Embed(source = "/../embeds/pknight/pknight.md2", mimeType = "application/octet-stream")]
		public static var PKnightModel:Class;

		//array of textures for random sampling
		private var _pKnightTextures:Vector.<Bitmap> = Vector.<Bitmap>([new PKnightTexture1(), new PKnightTexture2(), new PKnightTexture3(), new PKnightTexture4()]);
		private var _pKnightMaterials:Vector.<TextureMaterial> = new Vector.<TextureMaterial>();

		//engine variables
		private var _view:View3D;
		private var _cameraController:HoverController;

		//signature variables
		private var _signature:Sprite;
		private var _signatureBitmap:Bitmap;

		//light objects
		private var _light:DirectionalLight;
		private var _lightPicker:StaticLightPicker;

		//material objects
		private var _floorMaterial:TextureMaterial;
		private var _shadowMapMethod:FilteredShadowMapMethod;

		//scene objects
		private var _floor:Mesh;
		private var _mesh:Mesh;

		//navigation variables
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _animationSet:VertexAnimationSet;

		/**
		 * Constructor
		 */
		public function Basic_LoadMD2()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//setup the view
			_view = new View3D();
			_view.addSourceURL("srcview/index.html");
			addChild(_view);

			//setup the camera for optimal rendering
			_view.camera.lens.far = 5000;

			//setup controller to be used on the camera
			_cameraController = new HoverController(_view.camera, null, 45, 20, 2000, 5);

			//setup the lights for the scene
			_light = new DirectionalLight(-0.5, -1, -1);
			_light.ambient = 0.4;
			_lightPicker = new StaticLightPicker([_light]);
			_view.scene.addChild(_light);

			//setup parser to be used on AssetLibrary
			AssetLibrary.loadData(new PKnightModel(), null, null, new MD2Parser());
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);

			//create a global shadow map method
			_shadowMapMethod = new FilteredShadowMapMethod(_light);

			//setup floor material
			_floorMaterial = new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			_floorMaterial.lightPicker = _lightPicker;
			_floorMaterial.specular = 0;
			_floorMaterial.ambient = 1;
			_floorMaterial.shadowMethod = _shadowMapMethod;
			_floorMaterial.repeat = true;

			//setup Perelith Knight materials
			for (var i:uint = 0; i < _pKnightTextures.length; i++)
			{
				var bitmapData:BitmapData = _pKnightTextures[i].bitmapData;
				var knightMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bitmapData));
				knightMaterial.normalMap = Cast.bitmapTexture(BitmapFilterEffects.normalMap(bitmapData));
				knightMaterial.specularMap = Cast.bitmapTexture(BitmapFilterEffects.outline(bitmapData));
				knightMaterial.lightPicker = _lightPicker;
				knightMaterial.gloss = 30;
				knightMaterial.specular = 1;
				knightMaterial.ambient = 1;
				knightMaterial.shadowMethod = _shadowMapMethod;
				_pKnightMaterials.push(knightMaterial);
			}

			_floor = new Mesh(new PlaneGeometry(5000, 5000), _floorMaterial);
			_floor.geometry.scaleUV(5, 5);

			//setup the scene
			_view.scene.addChild(_floor);

			//add signature
			_signature = new SignatureSwf();
			_signatureBitmap = new Bitmap(new BitmapData(_signature.width, _signature.height, true, 0));
			stage.quality = StageQuality.HIGH;
			_signatureBitmap.bitmapData.draw(_signature);
			stage.quality = StageQuality.LOW;
			addChild(_signatureBitmap);

			//add stats panel
			addChild(new AwayStats(_view));

			//add listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (_move)
			{
				_cameraController.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
				_cameraController.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}

			_view.render();
		}

		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH)
			{
				_mesh = event.asset as Mesh;

				//adjust the ogre mesh
				_mesh.y = 120;
				_mesh.scale(5);

			}
			else if (event.asset.assetType == AssetType.ANIMATION_SET)
			{
				_animationSet = event.asset as VertexAnimationSet;
			}
		}

		/**
		 * Listener function for resource complete event on loader
		 */
		private function onResourceComplete(event:LoaderEvent):void
		{
			//create 20 x 20 different clones of the ogre
			var numWide:Number = 20;
			var numDeep:Number = 20;
			var k:uint = 0;
			for (var i:uint = 0; i < numWide; i++)
			{
				for (var j:uint = 0; j < numDeep; j++)
				{
					//clone mesh
					var clone:Mesh = _mesh.clone() as Mesh;
					clone.x = (i - (numWide - 1) / 2) * 5000 / numWide;
					clone.z = (j - (numDeep - 1) / 2) * 5000 / numDeep;
					clone.castsShadows = true;
					clone.material = _pKnightMaterials[uint(Math.random() * _pKnightMaterials.length)];
					_view.scene.addChild(clone);

					//create animator
					var vertexAnimator:VertexAnimator = new VertexAnimator(_animationSet);

					//play specified state
					vertexAnimator.play(_animationSet.animationNames[int(Math.random() * _animationSet.animationNames.length)], null, Math.random() * 1000);
					clone.animator = vertexAnimator;
					k++;
				}
			}
		}

		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			_lastPanAngle = _cameraController.panAngle;
			_lastTiltAngle = _cameraController.tiltAngle;
			_lastMouseX = stage.mouseX;
			_lastMouseY = stage.mouseY;
			_move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			_move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			_move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
			_signatureBitmap.y = stage.stageHeight - _signature.height;
		}
	}
}
