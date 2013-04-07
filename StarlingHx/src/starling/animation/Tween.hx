// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================


package starling.animation;

import flash.Vector;
import starling.events.Event;
import starling.events.EventDispatcher;

/** A Tween animates numeric properties of objects. It uses different transition functions 
 *  to give the animations various styles.
 *  
 *  <p>The primary use of this class is to do standard animations like movement, fading, 
 *  rotation, etc. But there are no limits on what to animate; as long as the property you want
 *  to animate is numeric (<code>int, uint, Number</code>), the tween can handle it. For a list 
 *  of available Transition types, look at the "Transitions" class.</p> 
 *  
 *  <p>Here is an example of a tween that moves an object to the right, rotates it, and 
 *  fades it out:</p>
 *  
 *  <listing>
 *  var tween:Tween = new Tween(object, 2.0, Transitions.EASE_IN_OUT);
 *  tween.animate("x", object.x + 50);
 *  tween.animate("rotation", deg2rad(45));
 *  tween.fadeTo(0);    // equivalent to 'animate("alpha", 0)'
 *  Starling.juggler.add(tween);</listing> 
 *  
 *  <p>Note that the object is added to a juggler at the end of this sample. That's because a 
 *  tween will only be executed if its "advanceTime" method is executed regularly - the 
 *  juggler will do that for you, and will remove the tween when it is finished.</p>
 *  
 *  @see Juggler
 *  @see Transitions
 */ 
class Tween extends EventDispatcher implements IAnimatable
{
	private var mTarget:Dynamic;
	private var mTransitionFunc:Function;
	private var mTransitionName:String;
	
	private var mProperties:Vector<String>;
	private var mStartValues:Vector<Float>;
	private var mEndValues:Vector<Float>;

	private var mOnStart:Function;
	private var mOnUpdate:Function;
	private var mOnRepeat:Function;
	private var mOnComplete:Function;  
	
	private var mOnStartArgs:Array;
	private var mOnUpdateArgs:Array;
	private var mOnRepeatArgs:Array;
	private var mOnCompleteArgs:Array;
	
	private var mTotalTime:Float;
	private var mCurrentTime:Float;
	private var mDelay:Float;
	private var mRoundToInt:Bool;
	private var mNextTween:Tween;
	private var mRepeatCount:Int;
	private var mRepeatDelay:Float;
	private var mReverse:Bool;
	private var mCurrentCycle:Int;
	
	/** Creates a tween with a target, duration (in seconds) and a transition function.
	 *  @param target the object that you want to animate
	 *  @param time the duration of the Tween
	 *  @param transition can be either a String (e.g. one of the constants defined in the
	 *         Transitions class) or a function. Look up the 'Transitions' class for a   
	 *         documentation about the required function signature. */ 
	public function new(target:Dynamic, time:Float, transition:Dynamic="linear")        
	{
		 reset(target, time, transition);
	}

	/** Resets the tween to its default values. Useful for pooling tweens. */
	public function reset(target:Dynamic, time:Float, transition:Dynamic="linear"):Tween
	{
		mTarget = target;
		mCurrentTime = 0;
		mTotalTime = Math.max(0.0001, time);
		mDelay = mRepeatDelay = 0.0;
		mOnStart = mOnUpdate = mOnComplete = null;
		mOnStartArgs = mOnUpdateArgs = mOnCompleteArgs = null;
		mRoundToInt = mReverse = false;
		mRepeatCount = 1;
		mCurrentCycle = -1;
		
		if (Std.is(transition,String))
			this.transition = cast(transition,String);
		else if (Std.is(transition,Function))
			this.transitionFunc = transition;
		else 
			throw new ArgumentError("Transition must be either a string or a function");
		
		if (mProperties)  
			mProperties.length  = 0; 
		else 
			mProperties  = new Array<String>();
			
		if (mStartValues) 
			mStartValues.length = 0; 
		else 
			mStartValues = new Array<Float>();
			
		if (mEndValues)   
			mEndValues.length   = 0; 
		else 
			mEndValues   = new Array<Float>();
		
		return this;
	}
	
	/** Animates the property of the target to a certain value. You can call this method multiple
	 *  times on one tween. */
	public function animate(property:String, endValue:Float):Void
	{
		if (mTarget == null) return; // tweening null just does nothing.
			   
		mProperties.push(property);
		mStartValues.push(Float.NaN);
		mEndValues.push(endValue);
	}
	
	/** Animates the 'scaleX' and 'scaleY' properties of an object simultaneously. */
	public function scaleTo(factor:Float):Void
	{
		animate("scaleX", factor);
		animate("scaleY", factor);
	}
	
	/** Animates the 'x' and 'y' properties of an object simultaneously. */
	public function moveTo(x:Float, y:Float):Void
	{
		animate("x", x);
		animate("y", y);
	}
	
	/** Animates the 'alpha' property of an object to a certain target value. */ 
	public function fadeTo(alpha:Float):Void
	{
		animate("alpha", alpha);
	}
	
	/** @inheritDoc */
	public function advanceTime(time:Float):Void
	{
		if (time == 0 || (mRepeatCount == 1 && mCurrentTime == mTotalTime)) return;
		
		var i:Int;
		var previousTime:Float = mCurrentTime;
		var restTime:Float = mTotalTime - mCurrentTime;
		var carryOverTime:Float = time > restTime ? time - restTime : 0.0;
		
		mCurrentTime = Math.min(mTotalTime, mCurrentTime + time);
		
		if (mCurrentTime <= 0) return; // the delay is not over yet

		if (mCurrentCycle < 0 && previousTime <= 0 && mCurrentTime > 0)
		{
			mCurrentCycle++;
			if (mOnStart != null) mOnStart.apply(null, mOnStartArgs);
		}

		var ratio:Float = mCurrentTime / mTotalTime;
		var reversed:Bool = mReverse && (mCurrentCycle % 2 == 1);
		var numProperties:Int = mStartValues.length;

		for (i in 0...numProperties)
		{                
			if (isNaN(mStartValues[i])) 
				mStartValues[i] = cast(mTarget[mProperties[i]],Float);
			
			var startValue:Float = mStartValues[i];
			var endValue:Float = mEndValues[i];
			var delta:Float = endValue - startValue;
			var transitionValue:Float = reversed ?
				mTransitionFunc(1.0 - ratio) : mTransitionFunc(ratio);
			
			var currentValue:Float = startValue + transitionValue * delta;
			if (mRoundToInt) currentValue = Math.round(currentValue);
			mTarget[mProperties[i]] = currentValue;
		}

		if (mOnUpdate != null) 
			mOnUpdate.apply(null, mOnUpdateArgs);
		
		if (previousTime < mTotalTime && mCurrentTime >= mTotalTime)
		{
			if (mRepeatCount == 0 || mRepeatCount > 1)
			{
				mCurrentTime = -mRepeatDelay;
				mCurrentCycle++;
				if (mRepeatCount > 1) mRepeatCount--;
				if (mOnRepeat != null) mOnRepeat.apply(null, mOnRepeatArgs);
			}
			else
			{
				// save callback & args: they might be changed through an event listener
				var onComplete:Function = mOnComplete;
				var onCompleteArgs:Array = mOnCompleteArgs;
				
				// in the 'onComplete' callback, people might want to call "tween.reset" and
				// add it to another juggler; so this event has to be dispatched *before*
				// executing 'onComplete'.
				dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				if (onComplete != null) onComplete.apply(null, onCompleteArgs);
			}
		}
		
		if (carryOverTime) 
			advanceTime(carryOverTime);
	}
	
	/** The end value a certain property is animated to. Throws an ArgumentError if the 
	 *  property is not being animated. */
	public function getEndValue(property:String):Float
	{
		var index:Int = mProperties.indexOf(property);
		if (index == -1) 
			throw new ArgumentError("The property '" + property + "' is not animated");
		else 
			return cast(mEndValues[index],Float);
	}
	
	/** Indicates if the tween is finished. */
	private function get_isComplete():Bool 
	{ 
		return mCurrentTime >= mTotalTime && mRepeatCount == 1; 
	}        
	
	/** The target object that is animated. */
	private function get_target():Dynamic { return mTarget; }
	
	/** The transition method used for the animation. @see Transitions */
	private function get_transition():String { return mTransitionName; }
	private function set_transition(value:String):String 
	{ 
		mTransitionName = value;
		mTransitionFunc = Transitions.getTransition(value);
		
		if (mTransitionFunc == null)
			throw new ArgumentError("Invalid transiton: " + value);
		
		return mTransitionName;
	}
	
	/** The actual transition function used for the animation. */
	private function get_transitionFunc():Function { return mTransitionFunc; }
	private function set_transitionFunc(value:Function):Void
	{
		mTransitionName = "custom";
		mTransitionFunc = value;
	}
	
	/** The total time the tween will take per repetition (in seconds). */
	private function get_totalTime():Float { return mTotalTime; }
	
	/** The time that has passed since the tween was created. */
	private function get_currentTime():Float { return mCurrentTime; }
	
	/** The delay before the tween is started. @default 0 */
	private function get_delay():Float { return mDelay; }
	private function set_delay(value:Float):Void 
	{ 
		mCurrentTime = mCurrentTime + mDelay - value;
		mDelay = value;
	}
	
	/** The number of times the tween will be executed. 
	 *  Set to '0' to tween indefinitely. @default 1 */
	private function get_repeatCount():Int { return mRepeatCount; }
	private function set_repeatCount(value:Int):Void { mRepeatCount = value; }
	
	/** The amount of time to wait between repeat cycles, in seconds. @default 0 */
	private function get_repeatDelay():Float { return mRepeatDelay; }
	private function set_repeatDelay(value:Float):Void { mRepeatDelay = value; }
	
	/** Indicates if the tween should be reversed when it is repeating. If enabled, 
	 *  every second repetition will be reversed. @default false */
	private function get_reverse():Bool { return mReverse; }
	private function set_reverse(value:Bool):Bool { return mReverse = value; }
	
	/** Indicates if the numeric values should be cast to Integers. @default false */
	private function get_roundToInt():Bool { return mRoundToInt; }
	private function set_roundToInt(value:Bool):Bool { return mRoundToInt = value; }        
	
	/** A function that will be called when the tween starts (after a possible delay). */
	private function get_onStart():Function { return mOnStart; }
	private function set_onStart(value:Function):Void { return mOnStart = value; }
	
	/** A function that will be called each time the tween is advanced. */
	private function get_onUpdate():Function { return mOnUpdate; }
	private function set_onUpdate(value:Function):Void { return mOnUpdate = value; }
	
	/** A function that will be called each time the tween finishes one repetition
	 *  (except the last, which will trigger 'onComplete'). */
	private function get_onRepeat():Function { return mOnRepeat; }
	private function set_onRepeat(value:Function):Void { return mOnRepeat = value; }
	
	/** A function that will be called when the tween is complete. */
	private function get_onComplete():Function { return mOnComplete; }
	private function set_onComplete(value:Function):Void { return mOnComplete = value; }
	
	/** The arguments that will be passed to the 'onStart' function. */
	private function get_onStartArgs():Array<Dynamic> { return mOnStartArgs; }
	private function set_onStartArgs(value:Array<Dynamic>):Void { return mOnStartArgs = value; }
	
	/** The arguments that will be passed to the 'onUpdate' function. */
	private function get_onUpdateArgs():Array<Dynamic> { return mOnUpdateArgs; }
	private function set_onUpdateArgs(value:Array<Dynamic>):Void { return mOnUpdateArgs = value; }
	
	/** The arguments that will be passed to the 'onRepeat' function. */
	private function get_onRepeatArgs():Array<Dynamic> { return mOnRepeatArgs; }
	private function set_onRepeatArgs(value:Array<Dynamic>):Void { return mOnRepeatArgs = value; }
	
	/** The arguments that will be passed to the 'onComplete' function. */
	private function get_onCompleteArgs():Array<Dynamic> { return mOnCompleteArgs; }
	private function set_onCompleteArgs(value:Array<Dynamic>):Void { return mOnCompleteArgs = value; }
	
	/** Another tween that will be started (i.e. added to the same juggler) as soon as 
	 *  this tween is completed. */
	private function get_nextTween():Tween { return mNextTween; }
	private function set_nextTween(value:Tween):Tween { return mNextTween = value; }
	
	// tween pooling
	
	private static var sTweenPool:Vector<Tween> = new Vector<Tween>();
	
	/** @private */
	public static function fromPool(target:Dynamic, time:Float, 
											   transition:Dynamic="linear"):Tween
	{
		if (sTweenPool.length) return sTweenPool.pop().reset(target, time, transition);
		else return new Tween(target, time, transition);
	}
	
	/** @private */
	public static function toPool(tween:Tween):Void
	{
		// reset any object-references, to make sure we don't prevent any garbage collection
		tween.mOnStart = tween.mOnUpdate = tween.mOnRepeat = tween.mOnComplete = null;
		tween.mOnStartArgs = tween.mOnUpdateArgs = tween.mOnRepeatArgs = tween.mOnCompleteArgs = null;
		tween.mTarget = null;
		tween.mTransitionFunc = null;
		tween.removeEventListeners();
		sTweenPool.push(tween);
	}
}
