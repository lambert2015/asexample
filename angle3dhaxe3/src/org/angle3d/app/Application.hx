package org.angle3d.app;

import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.Lib;
import org.angle3d.app.state.AppStateManager;
import org.angle3d.input.InputManager;
import org.angle3d.manager.ShaderManager;
import org.angle3d.material.shader.ShaderProfile;
import org.angle3d.math.Vector3f;
import org.angle3d.renderer.Camera3D;
import org.angle3d.renderer.DefaultRenderer;
import org.angle3d.renderer.IRenderer;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;



/**
 * The <code>Application</code> class represents an instance of a
 * real-time 3D rendering jME application.
 *
 * An <code>Application</code> provides all the tools that are commonly used in jME3
 * applications.
 *
 * jME3 applications should extend this class and call start() to begin the
 * application.
 *
 */
class Application extends Sprite
{
	private var renderer:IRenderer;
	private var renderManager:RenderManager;

	private var mViewPort:ViewPort;
	private var cam:Camera3D;

	private var mGuiViewPort:ViewPort;
	private var mGuiCam:Camera3D;

	private var stage3D:Stage3D;

	private var contextWidth:Int;
	private var contextHeight:Int;

	private var inputEnabled:Bool;
	private var inputManager:InputManager;
	private var stateManager:AppStateManager;

	//time per frame(ms)
	private var timePerFrame:Float;
	private var oldTime:Int;

	private var mProfile:ShaderProfile;

	public function new()
	{
		super();

		inputEnabled = true;
		oldTime = -1;

		this.addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
	}

	public function setSize(w:Int, h:Int):Void
	{
		contextWidth = w;
		contextHeight = h;

		stage3D.x = 0;
		stage3D.y = 0;
		stage3D.context3D.configureBackBuffer(contextWidth, contextHeight, 0, true);

		reshape(contextWidth, contextHeight);
	}

	/**
	 * Starts the application as a display.
	 */
	public function start():Void
	{
		stage.addEventListener(Event.ENTER_FRAME, _onEnterFrameHandler, false, 0, true);
	}

	public function reshape(w:Int, h:Int):Void
	{
		if (renderManager != null)
		{
			renderManager.reshape(w, h);
		}
	}

	public function stop():Void
	{
		stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrameHandler);
	}

	public function update():Void
	{
		if (oldTime <= -1)
		{
			timePerFrame = 0;
			oldTime = flash.Lib.getTimer();
			return;
		}

		var curTime:Int = flash.Lib.getTimer();
		timePerFrame = (curTime - oldTime) * 0.001;
		oldTime = curTime;

		if (inputEnabled)
		{
			inputManager.update(timePerFrame);
		}
	}

	public var guiViewPort(get, null):ViewPort;
	private inline function get_guiViewPort():ViewPort
	{
		return mGuiViewPort;
	}

	public var viewPort(get, null):ViewPort;
	private inline function get_viewPort():ViewPort
	{
		return mViewPort;
	}

	private function initialize(width:Int, height:Int):Void
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		initShaderManager();
		initCamera(width, height);
		initStateManager();
		initInput();
	}

	private function initInput():Void
	{
		inputManager = new InputManager();
		inputManager.initialize(stage);
	}

	private function initStateManager():Void
	{
		stateManager = new AppStateManager(this);
	}

	private function initShaderManager():Void
	{
		ShaderManager.init(stage3D.context3D, mProfile);
	}

	/**
	 * Creates the camera to use for rendering. Default values are perspective
	 * projection with 45° field of view, with near and far values 1 and 1000
	 * units respectively.
	 */
	private function initCamera(width:Int, height:Int):Void
	{
		setSize(width, height);

		cam = new Camera3D(width, height);

		cam.setFrustumPerspective(60, width / height, 1, 5000);
		cam.location = new Vector3f(0, 0, 10);
		cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);

		renderer = new DefaultRenderer(stage3D);
		renderManager = new RenderManager(renderer);

		mViewPort = renderManager.createMainView("Default", cam);
		mViewPort.setClearFlags(true, true, true);

		mGuiCam = new Camera3D(width, height);
		mGuiViewPort = renderManager.createPostView("Gui Default", mGuiCam);
		mGuiViewPort.setClearFlags(false, false, false);
	}

	private function _addedToStageHandler(e:Event):Void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);

		//StageProxy.stage = stage;

		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		initContext3D();
	}

	private function initContext3D():Void
	{
		stage3D = stage.stage3Ds[0];
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, _context3DCreateHandler);

		mProfile = ShaderProfile.BASELINE;
		stage3D.requestContext3D("auto", ShaderProfile.BASELINE);
	}

	private function _context3DCreateHandler(e:Event):Void
	{
		#if debug
			Lib.trace(stage3D.context3D.driverInfo);
			stage3D.context3D.enableErrorChecking = true;
		#end

		if (isSoftware(stage3D.context3D.driverInfo))
		{
			mProfile = ShaderProfile.BASELINE_CONSTRAINED;
			stage3D.requestContext3D("auto", ShaderProfile.BASELINE_CONSTRAINED);
		}
		else
		{
			stage.addEventListener(Event.RESIZE, _resizeHandler, false, 0, true);
			initialize(stage.stageWidth, stage.stageHeight);
		}
	}

	private function isSoftware(driverInfo:String):Bool
	{
		return driverInfo.indexOf("Software") > -1;
	}

	private function _resizeHandler(e:Event):Void
	{
		setSize(stage.stageWidth, stage.stageHeight);
	}

	private function _onEnterFrameHandler(e:Event):Void
	{
		update();
	}
}

