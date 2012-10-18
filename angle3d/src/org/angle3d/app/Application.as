package org.angle3d.app
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.angle3d.app.state.AppStateManager;
	import org.angle3d.input.InputManager;
	import org.angle3d.manager.ShaderManager;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.DefaultRenderer;
	import org.angle3d.renderer.IRenderer;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;

	/**
	 * The <code>Application</code> public class represents an instance of a
	 * real-time 3D rendering jME application.
	 *
	 * An <code>Application</code> provides all the tools that are commonly used in jME3
	 * applications.
	 *
	 * jME3 applications should extend this public class and call start() to begin the
	 * application.
	 *
	 */
	public class Application extends Sprite
	{
		protected var renderer : IRenderer;
		protected var renderManager : RenderManager;

		protected var viewPort : ViewPort;
		protected var cam : Camera3D;

		protected var guiViewPort : ViewPort;
		protected var guiCam : Camera3D;

		protected var stage3D : Stage3D;

		protected var contextWidth : int;
		protected var contextHeight : int;

		protected var inputEnabled : Boolean;
		protected var inputManager : InputManager;
		protected var stateManager : AppStateManager;

		//time per frame(ms)
		protected var timePerFrame : Number;
		protected var oldTime : int;
		
		protected var _context3DProfile:String;

		public function Application()
		{
			super();

			inputEnabled = true;
			oldTime = -1;

			this.addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}

		public function setSize(w : int, h : int) : void
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
		public function start() : void
		{
			stage.addEventListener(Event.ENTER_FRAME, _onEnterFrameHandler, false, 0, true);
		}

		public function reshape(w : int, h : int) : void
		{
			if (renderManager != null)
			{
				renderManager.reshape(w, h);
			}
		}

		public function stop() : void
		{
			stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrameHandler);
		}

		public function update() : void
		{
			if (oldTime <= -1)
			{
				timePerFrame = 0;
				oldTime = getTimer();
				return;
			}

			var curTime : int = getTimer();
			timePerFrame = (curTime - oldTime) * 0.001;
			oldTime = curTime;

			if (inputEnabled)
			{
				inputManager.update(timePerFrame);
			}
		}

		public function getGuiViewPort() : ViewPort
		{
			return guiViewPort;
		}

		public function getViewPort() : ViewPort
		{
			return viewPort;
		}

		protected function initialize(width : int, height : int) : void
		{
			initShaderManager();
			initCamera(width, height);
			initStateManager();
			initInput();
		}

		protected function initInput() : void
		{
			inputManager = new InputManager();
			inputManager.initialize(stage);
		}

		protected function initStateManager() : void
		{
			stateManager = new AppStateManager(this);
		}
		
		protected function initShaderManager() : void
		{
			ShaderManager.init(_context3DProfile,stage3D.context3D);
		}

		/**
		 * Creates the camera to use for rendering. Default values are perspective
		 * projection with 45° field of view, with near and far values 1 and 1000
		 * units respectively.
		 */
		protected function initCamera(width : int, height : int) : void
		{
			setSize(width, height);

			cam = new Camera3D(width, height);

			cam.setFrustumPerspective(60, width / height, 1, 5000);
			cam.location = new Vector3f(0, 0, 10);
			cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);

			renderer = new DefaultRenderer(stage3D);
			renderManager = new RenderManager(renderer);

			viewPort = renderManager.createMainView("Default", cam);
			viewPort.setClearFlags(true, true, true);

			guiCam = new Camera3D(width, height);
			guiViewPort = renderManager.createPostView("Gui Default", guiCam);
			guiViewPort.setClearFlags(false, false, false);
		}

		protected function _addedToStageHandler(e : Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			
			//StageProxy.stage = stage;

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initContext3D();
		}
		
		protected function initContext3D():void
		{
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, _context3DCreateHandler);
			
			_context3DProfile = Context3DProfile.BASELINE;
			stage3D.requestContext3D(Context3DRenderMode.AUTO,Context3DProfile.BASELINE);
		}

		protected function _context3DCreateHandler(e : Event) : void
		{
			CF::DEBUG
			{
				trace(stage3D.context3D.driverInfo);
				stage3D.context3D.enableErrorChecking = true;
			}
				
			if(isSoftware(stage3D.context3D.driverInfo))
			{
				_context3DProfile = Context3DProfile.BASELINE_CONSTRAINED;
				stage3D.requestContext3D(Context3DRenderMode.AUTO,Context3DProfile.BASELINE_CONSTRAINED);
			}
			else
			{
				stage.addEventListener(Event.RESIZE, _resizeHandler, false, 0, true);
				initialize(stage.stageWidth, stage.stageHeight);
			}
		}
		
		private function isSoftware(driverInfo:String):Boolean
		{
			return driverInfo.indexOf("Software") > -1;
		}

		protected function _resizeHandler(e : Event) : void
		{
			setSize(stage.stageWidth, stage.stageHeight);
		}

		protected function _onEnterFrameHandler(e : Event) : void
		{
			update();
		}
	}
}

