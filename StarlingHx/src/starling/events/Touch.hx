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

import flash.geom.Matrix;
import flash.geom.Point;

import starling.core.starling_internal;
import starling.display.DisplayObject;
import starling.utils.MatrixUtil;
import starling.utils.formatString;

use namespace starling_internal;

/** A Touch object contains information about the presence or movement of a finger 
 *  or the mouse on the screen.
 *  
 *  <p>You receive objects of this type from a TouchEvent. When such an event is triggered, you can 
 *  query it for all touches that are currently present on the screen. One Touch object contains
 *  information about a single touch. A touch object always moves through a series of
 *  TouchPhases. Have a look at the TouchPhase class for more information.</p>
 *  
 *  <strong>The position of a touch</strong>
 *  
 *  <p>You can get the current and previous position in stage coordinates with the corresponding 
 *  properties. However, you'll want to have the position in a different coordinate system 
 *  most of the time. For this reason, there are methods that convert the current and previous 
 *  touches into the local coordinate system of any object.</p>
 * 
 *  @see TouchEvent
 *  @see TouchPhase
 */  
class Touch
{
	private var mID:Int;
	private var mGlobalX:Float;
	private var mGlobalY:Float;
	private var mPreviousGlobalX:Float;
	private var mPreviousGlobalY:Float;
	private var mTapCount:Int;
	private var mPhase:String;
	private var mTarget:DisplayObject;
	private var mTimestamp:Float;
	private var mPressure:Float;
	private var mWidth:Float;
	private var mHeight:Float;
	private var mBubbleChain:Vector<EventDispatcher>;
	
	/** Helper object. */
	private static var sHelperMatrix:Matrix = new Matrix();
	
	/** Creates a new Touch object. */
	public function new(id:Int, globalX:Float, globalY:Float, phase:String, target:DisplayObject)
	{
		mID = id;
		mGlobalX = mPreviousGlobalX = globalX;
		mGlobalY = mPreviousGlobalY = globalY;
		mTapCount = 0;
		mPhase = phase;
		mTarget = target;
		mPressure = mWidth = mHeight = 1.0;
		mBubbleChain = new <EventDispatcher>[];
		updateBubbleChain();
	}
	
	/** Converts the current location of a touch to the local coordinate system of a display 
	 *  object. If you pass a 'resultPoint', the result will be stored in this point instead 
	 *  of creating a new object.*/
	public function getLocation(space:DisplayObject, resultPoint:Point=null):Point
	{
		if (resultPoint == null) resultPoint = new Point();
		space.base.getTransformationMatrix(space, sHelperMatrix);
		return MatrixUtil.transformCoords(sHelperMatrix, mGlobalX, mGlobalY, resultPoint); 
	}
	
	/** Converts the previous location of a touch to the local coordinate system of a display 
	 *  object. If you pass a 'resultPoint', the result will be stored in this point instead 
	 *  of creating a new object.*/
	public function getPreviousLocation(space:DisplayObject, resultPoint:Point=null):Point
	{
		if (resultPoint == null) resultPoint = new Point();
		space.base.getTransformationMatrix(space, sHelperMatrix);
		return MatrixUtil.transformCoords(sHelperMatrix, mPreviousGlobalX, mPreviousGlobalY, resultPoint);
	}
	
	/** Returns the movement of the touch between the current and previous location. 
	 *  If you pass a 'resultPoint', the result will be stored in this point instead 
	 *  of creating a new object. */ 
	public function getMovement(space:DisplayObject, resultPoint:Point=null):Point
	{
		if (resultPoint == null) resultPoint = new Point();
		getLocation(space, resultPoint);
		var x:Float = resultPoint.x;
		var y:Float = resultPoint.y;
		getPreviousLocation(space, resultPoint);
		resultPoint.setTo(x - resultPoint.x, y - resultPoint.y);
		return resultPoint;
	}
	
	/** Indicates if the target or one of its children is touched. */ 
	public function isTouching(target:DisplayObject):Bool
	{
		return mBubbleChain.indexOf(target) != -1;
	}
	
	/** Returns a description of the object. */
	public function toString():String
	{
		return formatString("Touch {0}: globalX={1}, globalY={2}, phase={3}",
							mID, mGlobalX, mGlobalY, mPhase);
	}
	
	/** Creates a clone of the Touch object. */
	public function clone():Touch
	{
		var clone:Touch = new Touch(mID, mGlobalX, mGlobalY, mPhase, mTarget);
		clone.mPreviousGlobalX = mPreviousGlobalX;
		clone.mPreviousGlobalY = mPreviousGlobalY;
		clone.mTapCount = mTapCount;
		clone.mTimestamp = mTimestamp;
		clone.mPressure = mPressure;
		clone.mWidth = mWidth;
		clone.mHeight = mHeight;
		return clone;
	}
	
	// helper methods
	
	private function updateBubbleChain():Void
	{
		if (mTarget)
		{
			var length:Int = 1;
			var element:DisplayObject = mTarget;
			
			mBubbleChain.length = 1;
			mBubbleChain[0] = element;
			
			while ((element = element.parent) != null)
				mBubbleChain[int(length++)] = element;
		}
		else
		{
			mBubbleChain.length = 0;
		}
	}
	
	// properties
	
	/** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
	private function get_id():Int { return mID; }
	
	/** The x-position of the touch in stage coordinates. */
	private function get_globalX():Float { return mGlobalX; }

	/** The y-position of the touch in stage coordinates. */
	private function get_globalY():Float { return mGlobalY; }
	
	/** The previous x-position of the touch in stage coordinates. */
	private function get_previousGlobalX():Float { return mPreviousGlobalX; }
	
	/** The previous y-position of the touch in stage coordinates. */
	private function get_previousGlobalY():Float { return mPreviousGlobalY; }
	
	/** The number of taps the finger made in a short amount of time. Use this to detect 
	 *  double-taps / double-clicks, etc. */ 
	private function get_tapCount():Int { return mTapCount; }
	
	/** The current phase the touch is in. @see TouchPhase */
	private function get_phase():String { return mPhase; }
	
	/** The display object at which the touch occurred. */
	private function get_target():DisplayObject { return mTarget; }
	
	/** The moment the touch occurred (in seconds since application start). */
	private function get_timestamp():Float { return mTimestamp; }
	
	/** A value between 0.0 and 1.0 indicating force of the contact with the device. 
	 *  If the device does not support detecting the pressure, the value is 1.0. */ 
	private function get_pressure():Float { return mPressure; }
	
	/** Width of the contact area. 
	 *  If the device does not support detecting the pressure, the value is 1.0. */
	private function get_width():Float { return mWidth; }
	
	/** Height of the contact area. 
	 *  If the device does not support detecting the pressure, the value is 1.0. */
	private function get_height():Float { return mHeight; }
	
	// internal methods
	
	/** @private 
	 *  Dispatches a touch event along the current bubble chain (which is updated each time
	 *  a target is set). */
	starling_internal function dispatchEvent(event:TouchEvent):Void
	{
		if (mTarget) event.dispatch(mBubbleChain);
	}
	
	/** @private */
	starling_internal function get_bubbleChain():Vector<EventDispatcher>
	{
		return mBubbleChain.concat();
	}
	
	/** @private */
	starling_internal function setTarget(value:DisplayObject):Void 
	{ 
		mTarget = value;
		updateBubbleChain();
	}
	
	/** @private */
	starling_internal function setPosition(globalX:Float, globalY:Float):Void
	{
		mPreviousGlobalX = mGlobalX;
		mPreviousGlobalY = mGlobalY;
		mGlobalX = globalX;
		mGlobalY = globalY;
	}
	
	/** @private */
	starling_internal function setSize(width:Float, height:Float):Void 
	{ 
		mWidth = width;
		mHeight = height;
	}
	
	/** @private */
	starling_internal function setPhase(value:String):Void { mPhase = value; }
	
	/** @private */
	starling_internal function setTapCount(value:Int):Void { mTapCount = value; }
	
	/** @private */
	starling_internal function setTimestamp(value:Float):Void { mTimestamp = value; }
	
	/** @private */
	starling_internal function setPressure(value:Float):Void { mPressure = value; }
}