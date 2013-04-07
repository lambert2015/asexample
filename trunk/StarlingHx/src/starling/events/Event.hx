// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events;

import flash.Vector;
import starling.utils.StringUtil;

/** Event objects are passed as parameters to event listeners when an event occurs.  
 *  This is Starling's version of the Flash Event class. 
 *
 *  <p>EventDispatchers create instances of this class and send them to registered listeners. 
 *  An event object contains information that characterizes an event, most importantly the 
 *  event type and if the event bubbles. The target of an event is the object that 
 *  dispatched it.</p>
 * 
 *  <p>For some event types, this information is sufficient; other events may need additional 
 *  information to be carried to the listener. In that case, you can subclass "Event" and add 
 *  properties with all the information you require. The "EnterFrameEvent" is an example for 
 *  this practice; it adds a property about the time that has passed since the last frame.</p>
 * 
 *  <p>Furthermore, the event class contains methods that can stop the event from being 
 *  processed by other listeners - either completely or at the next bubble stage.</p>
 * 
 *  @see EventDispatcher
 */
class Event
{
	/** Event type for a display object that is added to a parent. */
	public static inline var ADDED:String = "added";
	/** Event type for a display object that is added to the stage */
	public static inline var ADDED_TO_STAGE:String = "addedToStage";
	/** Event type for a display object that is entering a new frame. */
	public static inline var ENTER_FRAME:String = "enterFrame";
	/** Event type for a display object that is removed from its parent. */
	public static inline var REMOVED:String = "removed";
	/** Event type for a display object that is removed from the stage. */
	public static inline var REMOVED_FROM_STAGE:String = "removedFromStage";
	/** Event type for a triggered button. */
	public static inline var TRIGGERED:String = "triggered";
	/** Event type for a display object that is being flattened. */
	public static inline var FLATTEN:String = "flatten";
	/** Event type for a resized Flash Player. */
	public static inline var RESIZE:String = "resize";
	/** Event type that may be used whenever something finishes. */
	public static inline var COMPLETE:String = "complete";
	/** Event type for a (re)created stage3D rendering context. */
	public static inline var CONTEXT3D_CREATE:String = "context3DCreate";
	/** Event type that indicates that the root DisplayObject has been created. */
	public static inline var ROOT_CREATED:String = "rootCreated";
	/** Event type for an animated object that requests to be removed from the juggler. */
	public static inline var REMOVE_FROM_JUGGLER:String = "removeFromJuggler";
	
	/** An event type to be utilized in custom events. Not used by Starling right now. */
	public static inline var CHANGE:String = "change";
	/** An event type to be utilized in custom events. Not used by Starling right now. */
	public static inline var CANCEL:String = "cancel";
	/** An event type to be utilized in custom events. Not used by Starling right now. */
	public static inline var SCROLL:String = "scroll";
	/** An event type to be utilized in custom events. Not used by Starling right now. */
	public static inline var OPEN:String = "open";
	/** An event type to be utilized in custom events. Not used by Starling right now. */
	public static inline var CLOSE:String = "close";
	/** An event type to be utilized in custom events. Not used by Starling right now. */
	public static inline var SELECT:String = "select";
	
	private static var sEventPool:Vector<Event> = new Vector<Event>();
	
	private var mTarget:EventDispatcher;
	private var mCurrentTarget:EventDispatcher;
	private var mType:String;
	private var mBubbles:Bool;
	private var mStopsPropagation:Bool;
	private var mStopsImmediatePropagation:Bool;
	private var mData:Dynamic;
	
	/** Creates an event object that can be passed to listeners. */
	public function new(type:String, bubbles:Bool = false, data:Dynamic = null)
	{
		mType = type;
		mBubbles = bubbles;
		mData = data;
	}
	
	/** Prevents listeners at the next bubble stage from receiving the event. */
	public function stopPropagation():Void
	{
		mStopsPropagation = true;            
	}
	
	/** Prevents any other listeners from receiving the event. */
	public function stopImmediatePropagation():Void
	{
		mStopsPropagation = mStopsImmediatePropagation = true;
	}
	
	/** Returns a description of the event, containing type and bubble information. */
	public function toString():String
	{
		var str : String = untyped __global__["flash.utils.getQualifiedClassName"](this);
		return StringUtil.formatString("[{0} type=\"{1}\" bubbles={2}]", 
			str.split("::").pop(), mType, mBubbles);
	}
	
	public var bubbles(get, null):Bool;
	/** Indicates if event will bubble. */
	private function get_bubbles():Bool 
	{ 
		return mBubbles; 
	}
	
	public var target(get, null):EventDispatcher;
	/** The object that dispatched the event. */
	private function get_target():EventDispatcher 
	{ 
		return mTarget; 
	}
	
	public var currentTarget(get, null):EventDispatcher;
	/** The object the event is currently bubbling at. */
	private function get_currentTarget():EventDispatcher 
	{
		return mCurrentTarget; 
	}
	
	public var type(get, null):String;
	/** A string that identifies the event. */
	private function get_type():String 
	{ 
		return mType; 
	}
	
	public var data(get, null):Dynamic;
	/** Arbitrary data that is attached to the event. */
	private function get_data():Dynamic 
	{ 
		return mData; 
	}
	
	// properties for internal use
	
	/** @private */
	public function setTarget(value:EventDispatcher):Void 
	{ 
		mTarget = value; 
	}
	
	/** @private */
	public function setCurrentTarget(value:EventDispatcher):Void 
	{ 
		mCurrentTarget = value; 
	} 
	
	/** @private */
	public function setData(value:Dynamic):Void 
	{
		mData = value; 
	}
	
	public var stopsPropagation(get, null):Bool;
	/** @private */
	private function get_stopsPropagation():Bool 
	{ 
		return mStopsPropagation; 
	}
	
	public var stopsImmediatePropagation(get, null):Bool;
	/** @private */
	private function get_stopsImmediatePropagation():Bool 
	{ 
		return mStopsImmediatePropagation; 
	}
	
	// event pooling
	
	/** @private */
	public static function fromPool(type:String, bubbles:Bool=false, data:Dynamic=null):Event
	{
		if (sEventPool.length > 0) 
			return sEventPool.pop().reset(type, bubbles, data);
		else 
			return new Event(type, bubbles, data);
	}
	
	/** @private */
	public static function toPool(event:Event):Void
	{
		event.mData = event.mTarget = event.mCurrentTarget = null;
		sEventPool.push(event);
	}
	
	/** @private */
	public function reset(type:String, bubbles:Bool = false, data:Dynamic = null):Event
	{
		mType = type;
		mBubbles = bubbles;
		mData = data;
		mTarget = mCurrentTarget = null;
		mStopsPropagation = mStopsImmediatePropagation = false;
		return this;
	}
}