package quake3;

import nme.display.OpenGLView;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.Stage3D;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display3D.Context3D;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.geom.Matrix3D;
import nme.geom.Vector3D;
import nme.geom.Rectangle;
import nme.Lib;
import nme.net.URLRequest;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.ui.Keyboard;
import nme.utils.ByteArray;
import quake3.bsp.BSP;
import quake3.bsp.BSPMovement;
import quake3.bsp.BSPParser;
import quake3.core.Camera3D;
import quake3.events.BSPParseEvent;
import quake3.material.TextureManager;
import quake3.math.FastMath;
import quake3.net.BinaryDataLoader;
import quake3.render.Renderer;

class NMEQuake3 extends Sprite
{
	private var _stage:Stage;

	private var _context:Context3D;
	private var _render:Renderer;
	private var _camera:Camera3D;
	private var _bps:BSP;

	private var _loadingText:TextField;
	
	private var zAngle:Float;
	private var xAngle:Float;
	private var lastIndex:Int;
	
	private var movingModel:Bool;

	private var _bspMovement:BSPMovement;
	
	private var pressedKeys:Array<Bool>;
	
	private var _bpsParser:BSPParser;
	private var _bspLoader:BinaryDataLoader;
	
	private var view:OpenGLView;
	
	public function new()
	{
		super();
		
		view = new OpenGLView();
		view.render = renderView;
		addChild(view);
		
		lastIndex = 0;
		
		pressedKeys = new Array<Bool>();
		_stage = Lib.current.stage;
		_stage.scaleMode = StageScaleMode.NO_SCALE;
		_stage.align = StageAlign.TOP_LEFT;
	}
	
	private function renderView (rect:Rectangle):Void {
		
		GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
	}
	
	private function _initHUD():Void
	{
		_loadingText = new TextField();
		_loadingText.textColor = 0x0;
		_loadingText.autoSize = TextFieldAutoSize.CENTER;
		_loadingText.x = (_stage.stageWidth - _loadingText.width) / 2;
		_loadingText.y = (_stage.stageHeight - _loadingText.height) / 2;
		
		_loadingText.text = "Loading MAP...";
		
		Lib.current.addChild(_loadingText);
	}
	
	private function _onContextReady(e:Event):Void
	{
		//_context = _stage3D.context3D;
		//_context.configureBackBuffer(_stage.stageWidth, _stage.stageHeight, 4, true);
		
		_initHUD();

		TextureManager.initialize(_context);
		TextureManager.getInstance().setDefaultTexture(new DefaultTexture(0,0));

		_bspLoader = new BinaryDataLoader();
		_bspLoader.addEventListener(Event.COMPLETE, _binaryLoadComplete);
		_bspLoader.load(new URLRequest("assets/rdogdm4/maps/rdogdm4.bsp"));
	}

	private function _binaryLoadComplete(e:Event):Void
	{
		var binary:ByteArray = Lib.as(_bspLoader.getData(), ByteArray);

		_bpsParser = new BSPParser("assets/rdogdm4/", 5);
		_bpsParser.addEventListener(BSPParseEvent.COMPLETE, _parseComplete);
		_bpsParser.addEventListener(BSPParseEvent.PROGRESS, _parseProgress);
		
		_bpsParser.parse(binary);
		
		_bspLoader.unload();
		_bspLoader.removeEventListener(Event.COMPLETE, _binaryLoadComplete);
	}

	private function _parseComplete(e:BSPParseEvent):Void
	{
		Lib.current.removeChild(_loadingText);
		
		_bps = _bpsParser.getBSP();
		
		_camera = new Camera3D();
		_camera.makePerspective(60, 1.3333, 1, 10000);

		_render = new Renderer(_context, _camera);
		_render.setBSP(_bps);
		
		initPlayer();
		
		respawnPlayer(0);

		Lib.current.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _keyUpHandler);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
		Lib.current.stage.addEventListener(Event.RESIZE, _resizeHandler);
	}

	private function _parseProgress(e:BSPParseEvent):Void
	{
		_loadingText.text = e.getInfo();
		_loadingText.x = (_stage.stageWidth - _loadingText.width) / 2;
		_loadingText.y = (_stage.stageHeight - _loadingText.height)/2;
	}
	
	private var lastMove:Int;
	private function _onEnterFrame(e:Event):Void
	{
		var currentTime:Int = Lib.getTimer();
		
		while (currentTime - lastMove > 16)
		{
			updateInput(16);
			lastMove += 16;
		}
		
		var p:Vector3D = _bspMovement.position;
		
		var _viewMatrix:Matrix3D = _camera.getViewMatrix();
		_viewMatrix.identity();
		_viewMatrix.prependRotation( xAngle-90, Vector3D.X_AXIS);
		_viewMatrix.prependRotation( zAngle, Vector3D.Z_AXIS);
		_viewMatrix.prependTranslation( -p.x, -p.y, -p.z - 30);

		_render.render();
	}
	
	
	private function respawnPlayer(index:Int):Void
	{
		if (index == -1)
		{
			index = (lastIndex +1) % _bps.getNumPlayer();
		}
		
		lastIndex = index;
		
		var p:Vector3D = _bps.getDefaultPlayerPosition(lastIndex);

		_bspMovement.position.setTo(p.x, p.y, p.z + 60);
		
		_bspMovement.velocity.setTo(0, 0, 0);
		
		zAngle = -_bps.getDefaultPlayerAngle(lastIndex) + 90;
		xAngle = 0;
	}
	
	private function initPlayer():Void
	{
		_bspMovement = new BSPMovement(_bps);
	}
	
	private function updateInput(frameTime:Float):Void
	{
		if(_bspMovement == null) { return; }
					
		var dir:Vector3D = new Vector3D();
				
		// This is our first person movement code. It's not really pretty, but it works
		if(pressedKeys['W'.charCodeAt(0)] || pressedKeys[Keyboard.UP]) {
			dir.y += 1;
		}
		if(pressedKeys['S'.charCodeAt(0)] || pressedKeys[Keyboard.DOWN]) {
			dir.y -= 1;
		}
		if(pressedKeys['A'.charCodeAt(0)] || pressedKeys[Keyboard.LEFT]) {
			dir.x -= 1;
		}
		if(pressedKeys['D'.charCodeAt(0)] || pressedKeys[Keyboard.RIGHT]) {
			dir.x += 1;
		}
				
		if (dir.x != 0 || dir.y != 0 || dir.z != 0) {
			var matrix:Matrix3D = new Matrix3D();
			matrix.prependRotation(zAngle, Vector3D.Z_AXIS);
			matrix.invert();
			
			dir = matrix.deltaTransformVector(dir);
		}
				
		// Send desired movement direction to the player mover for collision detection against the map
		_bspMovement.move(dir, frameTime);
	}
	
	private function _keyDownHandler(e:KeyboardEvent):Void
	{
		switch(e.keyCode)
		{
			case Keyboard.R:
				respawnPlayer( -1);
			case Keyboard.SPACE:
				if (!pressedKeys[32])
				{
					_bspMovement.jump();
				}
		}
		pressedKeys[e.keyCode] = true;
	}
	
	private function _keyUpHandler(e:KeyboardEvent):Void
	{
		pressedKeys[e.keyCode] = false;
	}
	
	private var lastX:Float;
	private var lastY:Float;
	private function _mouseDownHandler(e:MouseEvent):Void
	{
		movingModel = true;
		
		lastX = e.stageX;
		lastY = e.stageY;
	}
	
	private function _mouseMoveHandler(e:MouseEvent):Void
	{
		var xDelta:Float = e.stageX - lastX;
		var yDelta:Float = e.stageY - lastY;
		
		lastX = e.stageX;
		lastY = e.stageY;
		
		if (movingModel) 
		{
			zAngle += xDelta * 0.025 * FastMath.RADTODEG;
			while (zAngle < 0)
				zAngle += 360;
			while (zAngle >= 360)
				zAngle -= 360;
							
			xAngle += yDelta * 0.025 * FastMath.RADTODEG;
			while (xAngle < -90)
				xAngle = -90;
			while (xAngle > 90)
				xAngle = 90;
		}
		
		e.updateAfterEvent();
	}
	
	private function _mouseUpHandler(e:MouseEvent):Void
	{
		movingModel = false;
	}
	
	private function _resizeHandler(e:Event):Void
	{
		_stage3D.x = 0;
		_stage3D.y = 0;
		_context.configureBackBuffer(_stage.stageWidth, _stage.stageHeight, 1, true);
	}
	
}

@:bitmap("../bin/assets/no-shader.png") class DefaultTexture extends flash.display.BitmapData {
}