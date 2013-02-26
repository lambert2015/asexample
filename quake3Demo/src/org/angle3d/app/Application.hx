package org.angle3d.app;
import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.FocusEvent;
import org.angle3d.math.Vector3f;
import flash.Lib;
import org.angle3d.app.state.AppStateManager;
import org.angle3d.input.InputManager;
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
	
	private var viewPort:ViewPort;
	private var cam:Camera3D;
	
	private var guiViewPort:ViewPort;
	private var guiCam:Camera3D;
	
	private var stage3D:Stage3D;

	private var contextWidth:Int;
	private var contextHeight:Int;
	
	private var inputEnabled:Bool;
	private var inputManager:InputManager;
	private var stateManager:AppStateManager;
	
	private var tpf:Float;
	private var oldTime:Int;

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
		stage3D.context3D.configureBackBuffer(contextWidth, contextHeight, 4, true);
		
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
			renderManager.notifyReshape(w, h);
		}
	}
	
	public function stop():Void
	{
		stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrameHandler);
	}
	
	public function update():Void
	{
		if (oldTime == -1)
		{
			tpf = 0;
		}
		else
		{
			tpf = (Lib.getTimer() - oldTime) / stage.frameRate;
		}

		oldTime = Lib.getTimer();
		
		if (inputEnabled)
		{
            inputManager.update(tpf);
        }
	}
	
	public function getGuiViewPort():ViewPort 
	{
        return guiViewPort;
    }

    public function getViewPort():ViewPort 
	{
        return viewPort;
    }
	
	private function initialize():Void
	{
		initCamera(contextWidth, contextHeight);
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
	
	/**
     * Creates the camera to use for rendering. Default values are perspective
     * projection with 45° field of view, with near and far values 1 and 1000
     * units respectively.
     */
	private function initCamera(width:Int,height:Int):Void
	{
		setSize(width, height);
		
		cam = new Camera3D(width, height);
		
		cam.setFrustumPerspective(60, width / height, 1, 1000);
		cam.setLocation(new Vector3f(0, 0, 20));
		cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
		
		renderer = new DefaultRenderer(stage3D);
		renderManager = new RenderManager(renderer);
		
		
		viewPort = renderManager.createMainView("Default", cam);
		viewPort.setClearFlags(true, true, true);
		
		guiCam = new Camera3D(width, height);
		guiViewPort = renderManager.createPostView("Gui Default", guiCam);
		guiViewPort.setClearFlags(false, false, false);
	}
	
	private function _addedToStageHandler(e:Event):Void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		stage3D = stage.stage3Ds[0];
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, _context3DCreateHandler);
		stage3D.requestContext3D();
	}
	
	private function _context3DCreateHandler(e:Event):Void
	{
		Lib.trace(stage3D.context3D.driverInfo);
		
		stage.addEventListener(FocusEvent.FOCUS_OUT, _focusOutHandler, false, 0, true);
		stage.addEventListener(FocusEvent.FOCUS_IN, _focusInHandler, false, 0, true);
		stage.addEventListener(Event.RESIZE, _resizeHandler, false, 0, true);
		
		contextWidth = stage.stageWidth;
		contextHeight = stage.stageHeight;
		
		stage3D.context3D.enableErrorChecking = true;
		
		initialize();
	}
	
	private function _resizeHandler(e:Event):Void
	{
		setSize(stage.stageWidth, stage.stageHeight);	
	}
	
	private function _focusInHandler(e:Event):Void
	{
		start();
	}
	
	private function _focusOutHandler(e:Event):Void
	{
		stop();
	}
	
	private function _onEnterFrameHandler(e:Event):Void
	{
		update();
	}
	
	public function getStage3D():Stage3D
	{
		return stage3D;
	}
	
	/**
     * @return the {@link InputManager input manager}.
     */
	public function getInputManager():InputManager
	{
		return inputManager;
	}
	
	/**
     * @return the app state manager
     */
    public function getStateManager():AppStateManager
	{
        return stateManager;
    }
	
	/**
     * @return the render manager
     */
    public function getRenderManager():RenderManager
	{
        return renderManager;
    }
	
	/**
     * @return The renderer for the application, or null if was not started yet.
     */
    public function getRenderer():IRenderer
	{
        return renderer;
    }
	
	/**
     * @return The camera for the application, or null if was not started yet.
     */
	public function getCamera():Camera3D
	{
		return cam;
	}
}