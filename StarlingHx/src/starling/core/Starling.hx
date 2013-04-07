// =================================================================================================
//
//	Starling Framework
//	Copyright 2012 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.core;

import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.Program3D;
import flash.errors.Error;
import flash.errors.IllegalOperationError;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Mouse;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.Lib;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

import starling.animation.Juggler;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.events.EventDispatcher;
import starling.events.ResizeEvent;
import starling.events.TouchPhase;
import starling.utils.HAlign;
import starling.utils.VAlign;

/** Dispatched when a new render context is created. */
@:meta([Event(name="context3DCreate", type="starling.events.Event")])

/** Dispatched when the root class has been created. */
@:meta([Event(name="rootCreated", type="starling.events.Event")])

/** The Starling class represents the core of the Starling framework.
 *
 *  <p>The Starling framework makes it possible to create 2D applications and games that make
 *  use of the Stage3D architecture introduced in Flash Player 11. It implements a display tree
 *  system that is very similar to that of conventional Flash, while leveraging modern GPUs
 *  to speed up rendering.</p>
 *  
 *  <p>The Starling class represents the link between the conventional Flash display tree and
 *  the Starling display tree. To create a Starling-powered application, you have to create
 *  an instance of the Starling class:</p>
 *  
 *  <pre>var starling:Starling = new Starling(Game, stage);</pre>
 *  
 *  <p>The first parameter has to be a Starling display object class, e.g. a subclass of 
 *  <code>starling.display.Sprite</code>. In the sample above, the class "Game" is the
 *  application root. An instance of "Game" will be created as soon as Starling is initialized.
 *  The second parameter is the conventional (Flash) stage object. Per default, Starling will
 *  display its contents directly below the stage.</p>
 *  
 *  <p>It is recommended to store the Starling instance as a member variable, to make sure
 *  that the Garbage Collector does not destroy it. After creating the Starling object, you 
 *  have to start it up like this:</p>
 * 
 *  <pre>starling.start();</pre>
 * 
 *  <p>It will now render the contents of the "Game" class in the frame rate that is set up for
 *  the application (as defined in the Flash stage).</p> 
 *  
 *  <strong>Accessing the Starling object</strong>
 * 
 *  <p>From within your application, you can access the current Starling object anytime
 *  through the static method <code>Starling.current</code>. It will return the active Starling
 *  instance (most applications will only have one Starling object, anyway).</p> 
 * 
 *  <strong>Viewport</strong>
 * 
 *  <p>The area the Starling content is rendered into is, per default, the complete size of the 
 *  stage. You can, however, use the "viewPort" property to change it. This can be  useful 
 *  when you want to render only into a part of the screen, or if the player size changes. For
 *  the latter, you can listen to the RESIZE-event dispatched by the Starling
 *  stage.</p>
 * 
 *  <strong>Native overlay</strong>
 *  
 *  <p>Sometimes you will want to display native Flash content on top of Starling. That's what the
 *  <code>nativeOverlay</code> property is for. It returns a Flash Sprite lying directly
 *  on top of the Starling content. You can add conventional Flash objects to that overlay.</p>
 *  
 *  <p>Beware, though, that conventional Flash content on top of 3D content can lead to
 *  performance penalties on some (mobile) platforms. For that reason, always remove all child
 *  objects from the overlay when you don't need them any longer. Starling will remove the 
 *  overlay from the display list when it's empty.</p>
 *  
 *  <strong>Multitouch</strong>
 *  
 *  <p>Starling supports multitouch input on devices that provide it. During development, 
 *  where most of us are working with a conventional mouse and keyboard, Starling can simulate 
 *  multitouch events with the help of the "Shift" and "Ctrl" (Mac: "Cmd") keys. Activate
 *  this feature by enabling the <code>simulateMultitouch</code> property.</p>
 *  
 *  <strong>Handling a lost render context</strong>
 *  
 *  <p>On some operating systems and under certain conditions (e.g. returning from system
 *  sleep), Starling's stage3D render context may be lost. Starling can recover from a lost
 *  context if the class property "handleLostContext" is set to "true". Keep in mind, however, 
 *  that this comes at the price of increased memory consumption; Starling will cache textures 
 *  in RAM to be able to restore them when the context is lost.</p> 
 *  
 *  <p>In case you want to react to a context loss, Starling dispatches an event with
 *  the type "Event.CONTEXT3D_CREATE" when the context is restored. You can recreate any 
 *  invalid resources in a corresponding event listener.</p>
 * 
 *  <strong>Sharing a 3D Context</strong>
 * 
 *  <p>Per default, Starling handles the Stage3D context independently. If you want to combine
 *  Starling with another Stage3D engine, however, this may not be what you want. In this case,
 *  you can make use of the <code>shareContext</code> property:</p> 
 *  
 *  <ol>
 *    <li>Manually create and configure a context3D object that both frameworks can work with
 *        (through <code>stage3D.requestContext3D</code> and
 *        <code>context.configureBackBuffer</code>).</li>
 *    <li>Initialize Starling with the stage3D instance that contains that configured context.
 *        This will automatically enable <code>shareContext</code>.</li>
 *    <li>Call <code>start()</code> on your Starling instance (as usual). This will make  
 *        Starling queue input events (keyboard/mouse/touch).</li>
 *    <li>Create a game loop (e.g. using the native <code>ENTER_FRAME</code> event) and let it  
 *        call Starling's <code>nextFrame</code> as well as the equivalent method of the other 
 *        Stage3D engine. Surround those calls with <code>context.clear()</code> and 
 *        <code>context.present()</code>.</li>
 *  </ol>
 *  
 *  <p>The Starling wiki contains a <a href="http://goo.gl/BsXzw">tutorial</a> with more 
 *  information about this topic.</p>
 * 
 */ 
class Starling extends EventDispatcher
{
	/** The version of the Starling framework. */
	public static inline var VERSION:String = "1.3";
	
	/** The key for the shader programs stored in 'contextData' */
	private static inline var PROGRAM_DATA_NAME:String = "Starling.programs"; 
	
	// members
	
	private var mStage3D:Stage3D;
	private var mStage:Stage; // starling.display.stage!
	private var mRootClass:Class<Dynamic>;
	private var mRoot:DisplayObject;
	private var mJuggler:Juggler;
	private var mStarted:Bool;        
	private var mSupport:RenderSupport;
	private var mTouchProcessor:TouchProcessor;
	private var mAntiAliasing:Int;
	private var mSimulateMultitouch:Bool;
	private var mEnableErrorChecking:Bool;
	private var mLastFrameTimestamp:Float;
	private var mLeftMouseDown:Bool;
	private var mStatsDisplay:StatsDisplay;
	private var mShareContext:Bool;
	private var mProfile:String;
	private var mSupportHighResolutions:Bool;
	private var mContext:Context3D;
	
	private var mViewPort:Rectangle;
	private var mPreviousViewPort:Rectangle;
	private var mClippedViewPort:Rectangle;
	
	private var mNativeStage:flash.display.Stage;
	private var mNativeOverlay:flash.display.Sprite;
	private var mNativeStageContentScaleFactor:Float;
	
	private static var sCurrent:Starling;
	private static var sHandleLostContext:Bool;
	private static var sContextData:ObjectMap<Stage3D,Context3D>;
	
	// construction
	
	/** Creates a new Starling instance. 
	 *  @param rootClass  A subclass of a Starling display object. It will be created as soon as
	 *                    initialization is finished and will become the first child of the
	 *                    Starling stage.
	 *  @param stage      The Flash (2D) stage.
	 *  @param viewPort   A rectangle describing the area into which the content will be 
	 *                    rendered. @default stage size
	 *  @param stage3D    The Stage3D object into which the content will be rendered. If it 
	 *                    already contains a context, <code>sharedContext</code> will be set
	 *                    to <code>true</code>. @default the first available Stage3D.
	 *  @param renderMode Use this parameter to force "software" rendering. 
	 *  @param profile    The Context3DProfile that should be requested.
	 */
	public function new(rootClass:Class<Dynamic>, stage:flash.display.Stage, 
							 viewPort:Rectangle=null, stage3D:Stage3D=null,
							 renderMode:String="auto", profile:String="baselineConstrained") 
	{
		#if debug
		if (stage == null) 
			throw new ArgumentError("Stage must not be null");
		if (rootClass == null) 
			throw new ArgumentError("Root class must not be null");
		#end
			
			
		if (viewPort == null) 
			viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		if (stage3D == null) 
			stage3D = stage.stage3Ds[0];
		
		makeCurrent();
		
		mRootClass = rootClass;
		mViewPort = viewPort;
		mPreviousViewPort = new Rectangle();
		mStage3D = stage3D;
		mStage = new Stage(viewPort.width, viewPort.height, stage.color);
		mNativeOverlay = new Sprite();
		mNativeStage = stage;
		mNativeStage.addChild(mNativeOverlay);
		mNativeStageContentScaleFactor = 1.0;
		mTouchProcessor = new TouchProcessor(mStage);
		mJuggler = new Juggler();
		mAntiAliasing = 0;
		mSimulateMultitouch = false;
		mEnableErrorChecking = false;
		mProfile = profile;
		mSupportHighResolutions = false;
		mLastFrameTimestamp = flash.Lib.getTimer() / 1000.0;
		mSupport  = new RenderSupport();
		
		// for context data, we actually reference by stage3D, since it survives a context loss
		sContextData.set(stage3D,new ObjectMap<Stage3D,Context3D>());
		sContextData.get(stage3D).set(PROGRAM_DATA_NAME, new StringMap<Program3D>());
		
		// all other modes are problematic in Starling, so we force those here
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		// register touch/mouse event handlers            
		for (touchEventType in touchEventTypes)
			stage.addEventListener(touchEventType, onTouch, false, 0, true);
		
		// register other event handlers
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
		stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
		stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);
		
		mStage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false, 10, true);
		mStage3D.addEventListener(ErrorEvent.ERROR, onStage3DError, false, 10, true);
		
		if (mStage3D.context3D != null && 
			mStage3D.context3D.driverInfo != "Disposed")
		{
			mShareContext = true;
			setTimeout(initialize, 1); // we don't call it right away, because Starling should
									   // behave the same way with or without a shared context
		}
		else
		{
			mShareContext = false;
			
			try
			{
				// "Context3DProfile" is only available starting with Flash Player 11.4/AIR 3.4.
				// to stay compatible with older versions, we check if the parameter is available.
				
				var requestContext3D:Dynamic = mStage3D.requestContext3D;
				if (untyped requestContext3D.length == 1) 
					requestContext3D(renderMode);
				else 
					requestContext3D(renderMode, profile);
			}
			catch (e:Error)
			{
				showFatalError("Context3D error: " + e.message);
			}
		}
	}
	
	/** Disposes all children of the stage and the render context; removes all registered
	 *  event listeners. */
	public function dispose():Void
	{
		stop();
		
		mNativeStage.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
		mNativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey, false);
		mNativeStage.removeEventListener(KeyboardEvent.KEY_UP, onKey, false);
		mNativeStage.removeEventListener(Event.RESIZE, onResize, false);
		mNativeStage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave, false);
		mNativeStage.removeChild(mNativeOverlay);
		
		mStage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false);
		mStage3D.removeEventListener(ErrorEvent.ERROR, onStage3DError, false);
		
		for (touchEventType in touchEventTypes)
			mNativeStage.removeEventListener(touchEventType, onTouch, false);
		
		if (mStage) 
			mStage.dispose();
		if (mSupport) 
			mSupport.dispose();
		if (mTouchProcessor) 
			mTouchProcessor.dispose();
		if (sCurrent == this) 
			sCurrent = null;
			
		if (mContext != null && !mShareContext) 
		{
			// Per default, the context is recreated as long as there are listeners on it.
			// Beginning with AIR 3.6, we can avoid that with an additional parameter.
			
			var disposeContext3D:Dynamic = mContext.dispose;
			if (untyped disposeContext3D.length == 1) 
				disposeContext3D(false);
			else 
				disposeContext3D();
		}
	}
	
	// functions
	
	private function initialize():Void
	{
		makeCurrent();
		
		initializeGraphicsAPI();
		initializeRoot();
		
		mTouchProcessor.simulateMultitouch = mSimulateMultitouch;
		mLastFrameTimestamp = flash.Lib.getTimer() / 1000.0;
	}
	
	private function initializeGraphicsAPI():Void
	{
		mContext = mStage3D.context3D;
		mContext.enableErrorChecking = mEnableErrorChecking;
		contextData.set(PROGRAM_DATA_NAME, new StringMap<Program3D>());
		
		updateViewPort(true);
		
		#if debug
		trace("[Starling] Initialization complete.");
		trace("[Starling] Display Driver:", mContext.driverInfo);
		#end
		
		dispatchEventWith(starling.events.Event.CONTEXT3D_CREATE, false, mContext);
	}
	
	private function initializeRoot():Void
	{
		if (mRoot == null)
		{
			mRoot = cast(Type.createInstance(mRootClass), DisplayObject);
			if (mRoot == null) throw new Error("Invalid root class: " + mRootClass);
			mStage.addChildAt(mRoot, 0);
		
			dispatchEventWith(starling.events.Event.ROOT_CREATED, false, mRoot);
		}
	}
	
	/** Calls <code>advanceTime()</code> (with the time that has passed since the last frame)
	 *  and <code>render()</code>. */ 
	public function nextFrame():Void
	{
		var now:Float = flash.Lib.getTimer() / 1000.0;
		var passedTime:Float = now - mLastFrameTimestamp;
		mLastFrameTimestamp = now;
		
		advanceTime(passedTime);
		render();
	}
	
	/** Dispatches ENTER_FRAME events on the display list, advances the Juggler 
	 *  and processes touches. */
	public function advanceTime(passedTime:Float):Void
	{
		makeCurrent();
		
		mTouchProcessor.advanceTime(passedTime);
		mStage.advanceTime(passedTime);
		mJuggler.advanceTime(passedTime);
	}
	
	/** Renders the complete display list. Before rendering, the context is cleared; afterwards,
	 *  it is presented. This can be avoided by enabling <code>shareContext</code>.*/ 
	public function render():Void
	{
		if (!contextValid)
			return;
		
		makeCurrent();
		updateViewPort();
		updateNativeOverlay();
		mSupport.nextFrame();
		
		if (!mShareContext)
			RenderSupport.clear(mStage.color, 1.0);
		
		var scaleX:Float = mViewPort.width  / mStage.stageWidth;
		var scaleY:Float = mViewPort.height / mStage.stageHeight;
		
		mContext.setDepthTest(false, Context3DCompareMode.ALWAYS);
		mContext.setCulling(Context3DTriangleFace.NONE);
		
		mSupport.renderTarget = null; // back buffer
		mSupport.setOrthographicProjection(
			mViewPort.x < 0 ? -mViewPort.x / scaleX : 0.0, 
			mViewPort.y < 0 ? -mViewPort.y / scaleY : 0.0,
			mClippedViewPort.width  / scaleX, 
			mClippedViewPort.height / scaleY);
		
		mStage.render(mSupport, 1.0);
		mSupport.finishQuadBatch();
		
		if (mStatsDisplay)
			mStatsDisplay.drawCount = mSupport.drawCount;
		
		if (!mShareContext)
			mContext.present();
	}
	
	private function updateViewPort(forceUpdate:Bool=false):Void
	{
		// the last set viewport is stored in a variable; that way, people can modify the
		// viewPort directly (without a copy) and we still know if it has changed.
		
		if (forceUpdate || mPreviousViewPort.width != mViewPort.width || 
			mPreviousViewPort.height != mViewPort.height ||
			mPreviousViewPort.x != mViewPort.x || mPreviousViewPort.y != mViewPort.y)
		{
			mPreviousViewPort.setTo(mViewPort.x, mViewPort.y, mViewPort.width, mViewPort.height);
			
			// Constrained mode requires that the viewport is within the native stage bounds;
			// thus, we use a clipped viewport when configuring the back buffer. (In baseline
			// mode, that's not necessary, but it does not hurt either.)
			
			mClippedViewPort = mViewPort.intersection(
				new Rectangle(0, 0, mNativeStage.stageWidth, mNativeStage.stageHeight));
			
			if (!mShareContext)
			{
				// setting x and y might move the context to invalid bounds (since changing
				// the size happens in a separate operation) -- so we have no choice but to
				// set the backbuffer to a very small size first, to be on the safe side.
				
				if (mProfile == "baselineConstrained")
					mSupport.configureBackBuffer(32, 32, mAntiAliasing, false);
				
				mStage3D.x = mClippedViewPort.x;
				mStage3D.y = mClippedViewPort.y;
				
				mSupport.configureBackBuffer(mClippedViewPort.width, mClippedViewPort.height,
					mAntiAliasing, false, mSupportHighResolutions);
				
				if (mSupportHighResolutions && "contentsScaleFactor" in mNativeStage)
					mNativeStageContentScaleFactor = mNativeStage["contentsScaleFactor"];
				else
					mNativeStageContentScaleFactor = 1.0;
			}
			else
			{
				mSupport.backBufferWidth  = mClippedViewPort.width;
				mSupport.backBufferHeight = mClippedViewPort.height;
			}
		}
	}

	private function updateNativeOverlay():Void
	{
		mNativeOverlay.x = mViewPort.x;
		mNativeOverlay.y = mViewPort.y;
		mNativeOverlay.scaleX = mViewPort.width / mStage.stageWidth;
		mNativeOverlay.scaleY = mViewPort.height / mStage.stageHeight;
	}
	
	private function showFatalError(message:String):Void
	{
		var textField:TextField = new TextField();
		var textFormat:TextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
		textFormat.align = TextFormatAlign.CENTER;
		textField.defaultTextFormat = textFormat;
		textField.wordWrap = true;
		textField.width = mStage.stageWidth * 0.75;
		textField.autoSize = TextFieldAutoSize.CENTER;
		textField.text = message;
		textField.x = (mStage.stageWidth - textField.width) / 2;
		textField.y = (mStage.stageHeight - textField.height) / 2;
		textField.background = true;
		textField.backgroundColor = 0x440000;
		nativeOverlay.addChild(textField);
	}
	
	/** Make this Starling instance the <code>current</code> one. */
	public function makeCurrent():Void
	{
		sCurrent = this;
	}
	
	/** As soon as Starling is started, it will queue input events (keyboard/mouse/touch);   
	 *  furthermore, the method <code>nextFrame</code> will be called once per Flash Player
	 *  frame. (Except when <code>shareContext</code> is enabled: in that case, you have to
	 *  call that method manually.) */
	public function start():Void 
	{ 
		mStarted = true; 
		mLastFrameTimestamp = flash.Lib.getTimer() / 1000.0;
	}
	
	/** Stops all logic processing and freezes the game in its current state. The content
	 *  is still being rendered once per frame, though, because otherwise the conventional
	 *  display list would no longer be updated. */
	public function stop():Void 
	{ 
		mStarted = false; 
	}
	
	// event handlers
	
	private function onStage3DError(event:ErrorEvent):Void
	{
		if (event.errorID == 3702)
		{
			var mode:String = Capabilities.playerType == "Desktop" ? "renderMode" : "wmode";
			showFatalError("Context3D not available! Possible reasons: wrong " + mode +
						   " or missing device support.");
		}
		else
			showFatalError("Stage3D error: " + event.text);
	}
	
	private function onContextCreated(event:Event):Void
	{
		if (!Starling.handleLostContext && mContext)
		{
			stop();
			event.stopImmediatePropagation();
			showFatalError("Fatal error: The application lost the device context!");
			trace("[Starling] The device context was lost. " + 
				  "Enable 'Starling.handleLostContext' to avoid this error.");
		}
		else
		{
			initialize();
		}
	}
	
	private function onEnterFrame(event:Event):Void
	{
		// On mobile, the native display list is only updated on stage3D draw calls. 
		// Thus, we render even when Starling is paused.
		
		if (!mShareContext)
		{
			if (mStarted) 
				nextFrame();
			else          
				render();
		}
	}
	
	private function onKey(event:KeyboardEvent):Void
	{
		if (!mStarted) return;
		
		makeCurrent();
		mStage.dispatchEvent(new starling.events.KeyboardEvent(
			event.type, event.charCode, event.keyCode, event.keyLocation, 
			event.ctrlKey, event.altKey, event.shiftKey));
	}
	
	private function onResize(event:Event):Void
	{
		var stage:flash.display.Stage = cast(event.target,flash.display.Stage); 
		mStage.dispatchEvent(new ResizeEvent(Event.RESIZE, stage.stageWidth, stage.stageHeight));
	}

	private function onMouseLeave(event:Event):Void
	{
		mTouchProcessor.enqueueMouseLeftStage();
	}
	
	private function onTouch(event:Event):Void
	{
		if (!mStarted) 
			return;
		
		var globalX:Float;
		var globalY:Float;
		var touchID:Int;
		var phase:String;
		var pressure:Float = 1.0;
		var width:Float = 1.0;
		var height:Float = 1.0;
		
		// figure out general touch properties
		if (Std.is(event,MouseEvent))
		{
			var mouseEvent:MouseEvent = cast(event,MouseEvent);
			globalX = mouseEvent.stageX;
			globalY = mouseEvent.stageY;
			touchID = 0;
			
			// MouseEvent.buttonDown returns true for both left and right button (AIR supports
			// the right mouse button). We only want to react on the left button for now,
			// so we have to save the state for the left button manually.
			if (event.type == MouseEvent.MOUSE_DOWN)    
				mLeftMouseDown = true;
			else if (event.type == MouseEvent.MOUSE_UP) 
				mLeftMouseDown = false;
		}
		else
		{
			var touchEvent:TouchEvent = cast(event,TouchEvent);
			globalX = touchEvent.stageX;
			globalY = touchEvent.stageY;
			touchID = touchEvent.touchPointID;
			pressure = touchEvent.pressure;
			width = touchEvent.sizeX;
			height = touchEvent.sizeY;
		}
		
		// figure out touch phase
		switch (event.type)
		{
			case TouchEvent.TOUCH_BEGIN: phase = TouchPhase.BEGAN; 
			case TouchEvent.TOUCH_MOVE:  phase = TouchPhase.MOVED; 
			case TouchEvent.TOUCH_END:   phase = TouchPhase.ENDED; 
			case MouseEvent.MOUSE_DOWN:  phase = TouchPhase.BEGAN; 
			case MouseEvent.MOUSE_UP:    phase = TouchPhase.ENDED; 
			case MouseEvent.MOUSE_MOVE: 
				phase = (mLeftMouseDown ? TouchPhase.MOVED : TouchPhase.HOVER); 
		}
		
		// move position into viewport bounds
		globalX = mStage.stageWidth  * (globalX - mViewPort.x) / mViewPort.width;
		globalY = mStage.stageHeight * (globalY - mViewPort.y) / mViewPort.height;
		
		// enqueue touch in touch processor
		mTouchProcessor.enqueue(touchID, phase, globalX, globalY, pressure, width, height);
	}
	
	private function get_touchEventTypes():Array<String>
	{
		return Mouse.supportsCursor || !multitouchEnabled ?
			[ MouseEvent.MOUSE_DOWN,  MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_UP ] :
			[ TouchEvent.TOUCH_BEGIN, TouchEvent.TOUCH_MOVE, TouchEvent.TOUCH_END ];  
	}
	
	// program management
	
	/** Registers a vertex- and fragment-program under a certain name. If the name was already
	 *  used, the previous program is overwritten. */
	public function registerProgram(name:String, vertexProgram:ByteArray, fragmentProgram:ByteArray):Void
	{
		deleteProgram(name);
		
		var program:Program3D = mContext.createProgram();
		program.upload(vertexProgram, fragmentProgram);            
		programs.set(name,program);
	}
	
	/** Deletes the vertex- and fragment-programs of a certain name. */
	public function deleteProgram(name:String):Void
	{
		var program:Program3D = getProgram(name);            
		if (program != null)
		{                
			program.dispose();
			programs.delete(name);
		}
	}
	
	/** Returns the vertex- and fragment-programs registered under a certain name. */
	public function getProgram(name:String):Program3D
	{
		return programs.get(name);
	}
	
	/** Indicates if a set of vertex- and fragment-programs is registered under a certain name. */
	public function hasProgram(name:String):Bool
	{
		return programs.exists(name);
	}
	
	public var programs(get, null):StringMap<Program3D>;
	public var contextValid(get, null):Bool;
	public var isStarted(get, null):Bool;
	public var juggler(get, null):Juggler;
	public var context(get, null):Context3D;
	public var contextData(get, null):ObjectMap<Stage3D,Context3D>;
	public var simulateMultitouch(get, set):Bool;
	public var enableErrorChecking(get, set):Bool;
	public var antiAliasing(get, set):Int;
	public var viewPort(get, set):Rectangle;
	public var contentScaleFactor(get, null):Float;
	public var nativeOverlay(get, null):Sprite;
	public var showStats(get, set):Bool;
	public var stage(get, null):Stage;
	public var stage3D(get, null):Stage3D;
	public var nativeStage(get, null):flash.display.Stage;
	public var root(get, null):DisplayObject;
	public var shareContext(get, set):Bool;
	public var profile(get, null):String;
	public var supportHighResolutions(get, set):Bool;
	public static var current(get, null):Starling;
	//public static var juggler(get, null):Juggler;
	//public static var context(get, null):Context3D;
	//public static var contentScaleFactor(get, null):Float;
	public static var multitouchEnabled(get, set):Bool;
	public static var handleLostContext(get, set):Bool;
	
	private function get_programs():StringMap<Program3D> 
	{ 
		return contextData[PROGRAM_DATA_NAME]; 
	}
	
	// properties
	
	/** Indicates if a context is available and non-disposed. */
	private function get_contextValid():Bool
	{
		return (mContext && mContext.driverInfo != "Disposed");
	}
	
	/** Indicates if this Starling instance is started. */
	private function get_isStarted():Bool 
	{ 
		return mStarted; 
	}
	
	/** The default juggler of this instance. Will be advanced once per frame. */
	private function get_juggler():Juggler 
	{ 
		return mJuggler; 
	}
	
	/** The render context of this instance. */
	private function get_context():Context3D 
	{ 
		return mContext; 
	}
	
	/** A dictionary that can be used to save custom data related to the current context. 
	 *  If you need to share data that is bound to a specific stage3D instance
	 *  (e.g. textures), use this dictionary instead of creating a static class variable.
	 *  The Dictionary is actually bound to the stage3D instance, thus it survives a 
	 *  context loss. */
	private function get_contextData():ObjectMap<Stage3D,Context3D>
	{
		return sContextData.get(mStage3D);
	}
	
	/** Indicates if multitouch simulation with "Shift" and "Ctrl"/"Cmd"-keys is enabled. 
	 *  @default false */
	private function get_simulateMultitouch():Bool 
	{ 
		return mSimulateMultitouch; 
	}
	private function set_simulateMultitouch(value:Bool):Bool
	{
		mSimulateMultitouch = value;
		if (mContext) mTouchProcessor.simulateMultitouch = value;
		return mSimulateMultitouch;
	}
	
	/** Indicates if Stage3D render methods will report errors. Activate only when needed,
	 *  as this has a negative impact on performance. @default false */
	private function get_enableErrorChecking():Bool 
	{ 
		return mEnableErrorChecking; 
	}
	private function set_enableErrorChecking(value:Bool):Bool 
	{ 
		mEnableErrorChecking = value;
		if (mContext) 
			mContext.enableErrorChecking = value;
		return mEnableErrorChecking; 
	}
	
	/** The antialiasing level. 0 - no antialasing, 16 - maximum antialiasing. @default 0 */
	private function get_antiAliasing():Int 
	{ 
		return mAntiAliasing; 
	}
	private function set_antiAliasing(value:Int):Int
	{
		if (mAntiAliasing != value)
		{
			mAntiAliasing = value;
			if (contextValid) updateViewPort(true);
		}
		return mAntiAliasing; 
	}
	
	/** The viewport into which Starling contents will be rendered. */
	private function get_viewPort():Rectangle
	{ 
		return mViewPort; 
	}
	private function set_viewPort(value:Rectangle):Rectangle 
	{ 
		return mViewPort = value.clone();
	}
	
	/** The ratio between viewPort width and stage width. Useful for choosing a different
	 *  set of textures depending on the display resolution. */
	private function get_contentScaleFactor():Float
	{
		return (mViewPort.width * mNativeStageContentScaleFactor) / mStage.stageWidth;
	}
	
	/** A Flash Sprite placed directly on top of the Starling content. Use it to display native
	 *  Flash components. */ 
	private function get_nativeOverlay():Sprite 
	{
		return mNativeOverlay; 
	}
	
	/** Indicates if a small statistics box (with FPS, memory usage and draw count) is displayed. */
	private function get_showStats():Bool 
	{ 
		return mStatsDisplay && mStatsDisplay.parent; 
	}
	private function set_showStats(value:Bool):Bool
	{
		if (value == showStats) 
			return;
		
		if (value)
		{
			if (mStatsDisplay) 
				mStage.addChild(mStatsDisplay);
			else               
				showStatsAt();
		}
		else
			mStatsDisplay.removeFromParent();
		
		return showStats;
	}
	
	/** Displays the statistics box at a certain position. */
	public function showStatsAt(hAlign:String = "left", vAlign:String = "top", scale:Float = 1):Void
	{
		if (mContext == null)
		{
			// Starling is not yet ready - we postpone this until it's initialized.
			addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}
		else
		{
			if (mStatsDisplay == null)
			{
				mStatsDisplay = new StatsDisplay();
				mStatsDisplay.touchable = false;
				mStage.addChild(mStatsDisplay);
			}
			
			var stageWidth:Int  = mStage.stageWidth;
			var stageHeight:Int = mStage.stageHeight;
			
			mStatsDisplay.scaleX = mStatsDisplay.scaleY = scale;
			
			if (hAlign == HAlign.LEFT) 
				mStatsDisplay.x = 0;
			else if (hAlign == HAlign.RIGHT) 
				mStatsDisplay.x = stageWidth - mStatsDisplay.width; 
			else
				mStatsDisplay.x = Std.int((stageWidth - mStatsDisplay.width) / 2);
			
			if (vAlign == VAlign.TOP) 
				mStatsDisplay.y = 0;
			else if (vAlign == VAlign.BOTTOM) 
				mStatsDisplay.y = stageHeight - mStatsDisplay.height;
			else 
				mStatsDisplay.y = Std.int((stageHeight - mStatsDisplay.height) / 2);
		}
		
		var onRootCreated:Void->Void = function():Void
		{
			showStatsAt(hAlign, vAlign, scale);
			removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}
	}
	
	/** The Starling stage object, which is the root of the display tree that is rendered. */
	private function get_stage():Stage
	{
		return mStage;
	}

	/** The Flash Stage3D object Starling renders into. */
	private function get_stage3D():Stage3D
	{
		return mStage3D;
	}
	
	/** The Flash (2D) stage object Starling renders beneath. */
	private function get_nativeStage():flash.display.Stage
	{
		return mNativeStage;
	}
	
	/** The instance of the root class provided in the constructor. Available as soon as 
	 *  the event 'ROOT_CREATED' has been dispatched. */
	private function get_root():DisplayObject
	{
		return mRoot;
	}
	
	/** Indicates if the Context3D render calls are managed externally to Starling, 
	 *  to allow other frameworks to share the Stage3D instance. @default false */
	private function get_shareContext() : Bool 
	{ 
		return mShareContext; 
	}
	private function set_shareContext(value : Bool) : Bool 
	{ 
		return mShareContext = value; 
	}
	
	/** The Context3D profile as requested in the constructor. Beware that if you are 
	 *  using a shared context, this might not be accurate. */
	private function get_profile():String 
	{ 
		return mProfile; 
	}
	
	/** Indicates that if the device supports HiDPI screens Starling will attempt to allocate
	 *  a larger back buffer than indicated via the viewPort size. Note that this is used
	 *  on Desktop only; mobile AIR apps still use the "requestedDisplayResolution" parameter
	 *  the application descriptor XML. */
	private function get_supportHighResolutions():Bool 
	{ 
		return mSupportHighResolutions; 
	}
	private function set_supportHighResolutions(value:Bool):Bool 
	{
		if (mSupportHighResolutions != value)
		{
			mSupportHighResolutions = value;
			if (contextValid) 
				updateViewPort(true);
		}
		return mSupportHighResolutions; 
	}
	
	// static properties
	
	/** The currently active Starling instance. */
	private static function get_current():Starling 
	{ 
		return sCurrent; 
	}
	
	/** The render context of the currently active Starling instance. */
	//private static function get_context():Context3D 
	//{
		//return sCurrent ? sCurrent.context : null; 
	//}
	
	/** The default juggler of the currently active Starling instance. */
	//private static function get_juggler():Juggler 
	//{ 
		//return sCurrent ? sCurrent.juggler : null; 
	//}
	
	/** The contentScaleFactor of the currently active Starling instance. */
	//private static function get_contentScaleFactor():Float 
	//{
		//return sCurrent ? sCurrent.contentScaleFactor : 1.0;
	//}
	
	/** Indicates if multitouch input should be supported. */
	private static function get_multitouchEnabled():Bool 
	{ 
		return Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT;
	}
	
	private static function set_multitouchEnabled(value:Bool):Bool
	{
		if (sCurrent) throw new IllegalOperationError(
			"'multitouchEnabled' must be set before Starling instance is created");
		else 
			Multitouch.inputMode = value ? MultitouchInputMode.TOUCH_POINT :
										   MultitouchInputMode.NONE;
		return multitouchEnabled;
	}
	
	/** Indicates if Starling should automatically recover from a lost device context.
	 *  On some systems, an upcoming screensaver or entering sleep mode may 
	 *  invalidate the render context. This setting indicates if Starling should recover from 
	 *  such incidents. Beware that this has a huge impact on memory consumption!
	 *  It is recommended to enable this setting on Android and Windows, but to deactivate it
	 *  on iOS and Mac OS X. @default false */
	private static function get_handleLostContext():Bool 
	{ 
		return sHandleLostContext; 
	}
	private static function set_handleLostContext(value:Bool):Bool 
	{
		if (sCurrent) throw new IllegalOperationError(
			"'handleLostContext' must be set before Starling instance is created");
		else
			sHandleLostContext = value;
		return sHandleLostContext; 
	}
}