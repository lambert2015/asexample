// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import flash.errors.ArgumentError;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.Vector;
import starling.core.RenderSupport;
import starling.errors.AbstractClassError;
import starling.errors.AbstractMethodError;
import starling.events.EventDispatcher;
import starling.events.TouchEvent;
import starling.filters.FragmentFilter;
import starling.utils.MatrixUtil;


/** Dispatched when an object is added to a parent. */
@:meta([Event(name="added", type="starling.events.Event")])
/** Dispatched when an object is connected to the stage (directly or indirectly). */
@:meta([Event(name="addedToStage", type="starling.events.Event")])
/** Dispatched when an object is removed from its parent. */
@:meta([Event(name="removed", type="starling.events.Event")])
/** Dispatched when an object is removed from the stage and won't be rendered any longer. */ 
@:meta([Event(name="removedFromStage", type="starling.events.Event")])
/** Dispatched once every frame on every object that is connected to the stage. */ 
@:meta([Event(name="enterFrame", type="starling.events.EnterFrameEvent")])
/** Dispatched when an object is touched. Bubbles. */
@:meta([Event(name="touch", type="starling.events.TouchEvent")])

/**
 *  The DisplayObject class is the base class for all objects that are rendered on the 
 *  screen.
 *  
 *  <p><strong>The Display Tree</strong></p> 
 *  
 *  <p>In Starling, all displayable objects are organized in a display tree. Only objects that
 *  are part of the display tree will be displayed (rendered).</p> 
 *   
 *  <p>The display tree consists of leaf nodes (Image, Quad) that will be rendered directly to
 *  the screen, and of container nodes (subclasses of "DisplayObjectContainer", like "Sprite").
 *  A container is simply a display object that has child nodes - which can, again, be either
 *  leaf nodes or other containers.</p> 
 *  
 *  <p>At the base of the display tree, there is the Stage, which is a container, too. To create
 *  a Starling application, you create a custom Sprite subclass, and Starling will add an
 *  instance of this class to the stage.</p>
 *  
 *  <p>A display object has properties that define its position in relation to its parent
 *  (x, y), as well as its rotation and scaling factors (scaleX, scaleY). Use the 
 *  <code>alpha</code> and <code>visible</code> properties to make an object translucent or 
 *  invisible.</p>
 *  
 *  <p>Every display object may be the target of touch events. If you don't want an object to be
 *  touchable, you can disable the "touchable" property. When it's disabled, neither the object
 *  nor its children will receive any more touch events.</p>
 *    
 *  <strong>Transforming coordinates</strong>
 *  
 *  <p>Within the display tree, each object has its own local coordinate system. If you rotate
 *  a container, you rotate that coordinate system - and thus all the children of the 
 *  container.</p>
 *  
 *  <p>Sometimes you need to know where a certain point lies relative to another coordinate 
 *  system. That's the purpose of the method <code>getTransformationMatrix</code>. It will  
 *  create a matrix that represents the transformation of a point in one coordinate system to 
 *  another.</p> 
 *  
 *  <strong>Subclassing</strong>
 *  
 *  <p>Since DisplayObject is an abstract class, you cannot instantiate it directly, but have 
 *  to use one of its subclasses instead. There are already a lot of them available, and most 
 *  of the time they will suffice.</p> 
 *  
 *  <p>However, you can create custom subclasses as well. That way, you can create an object
 *  with a custom render function. You will need to implement the following methods when you 
 *  subclass DisplayObject:</p>
 *  
 *  <ul>
 *    <li><code>function render(support:RenderSupport, parentAlpha:Float):Void</code></li>
 *    <li><code>function getBounds(targetSpace:DisplayObject, 
 *                                 resultRect:Rectangle=null):Rectangle</code></li>
 *  </ul>
 *  
 *  <p>Have a look at the Quad class for a sample implementation of the 'getBounds' method.
 *  For a sample on how to write a custom render function, you can have a look at this
 *  <a href="http://wiki.starling-framework.org/manual/custom_display_objects">article</a>
 *  in the Starling Wiki.</p> 
 * 
 *  <p>When you override the render method, it is important that you call the method
 *  'finishQuadBatch' of the support object. This forces Starling to render all quads that 
 *  were accumulated before by different render methods (for performance reasons). Otherwise, 
 *  the z-ordering will be incorrect.</p> 
 * 
 *  @see DisplayObjectContainer
 *  @see Sprite
 *  @see Stage 
 */
class DisplayObject extends EventDispatcher
{
	public var stage(get, null):Stage;
	// members
	
	private var mX:Float;
	private var mY:Float;
	private var mPivotX:Float;
	private var mPivotY:Float;
	private var mScaleX:Float;
	private var mScaleY:Float;
	private var mSkewX:Float;
	private var mSkewY:Float;
	private var mRotation:Float;
	private var mAlpha:Float;
	private var mVisible:Bool;
	private var mTouchable:Bool;
	private var mBlendMode:String;
	private var mName:String;
	private var mUseHandCursor:Bool;
	private var mParent:DisplayObjectContainer;  
	private var mTransformationMatrix:Matrix;
	private var mOrientationChanged:Bool;
	private var mFilter:FragmentFilter;
	
	/** Helper objects. */
	private static var sAncestors:Vector<DisplayObject> = new Vector<DisplayObject>();
	private static var sHelperRect:Rectangle = new Rectangle();
	private static var sHelperMatrix:Matrix  = new Matrix();
	
	/** @private */ 
	public function new()
	{
		#if debug
		if(ClassUtil.getQualifiedClassName(this) == "starling.display::DisplayObject")
		{
			throw new AbstractClassError();
		}
		#end
		
		mX = mY = mPivotX = mPivotY = mRotation = mSkewX = mSkewY = 0.0;
		mScaleX = mScaleY = mAlpha = 1.0;            
		mVisible = mTouchable = true;
		mBlendMode = BlendMode.AUTO;
		mTransformationMatrix = new Matrix();
		mOrientationChanged = mUseHandCursor = false;
	}
	
	/** Disposes all resources of the display object. 
	  * GPU buffers are released, event listeners are removed, filters are disposed. */
	public function dispose():Void
	{
		if (mFilter) mFilter.dispose();
		removeEventListeners();
	}
	
	/** Removes the object from its parent, if it has one. */
	public function removeFromParent(dispose:Bool=false):Void
	{
		if (mParent) mParent.removeChild(this, dispose);
	}
	
	/** Creates a matrix that represents the transformation from the local coordinate system 
	 *  to another. If you pass a 'resultMatrix', the result will be stored in this matrix
	 *  instead of creating a new object. */ 
	public function getTransformationMatrix(targetSpace:DisplayObject, 
											resultMatrix:Matrix=null):Matrix
	{
		var commonParent:DisplayObject;
		var currentObject:DisplayObject;
		
		if (resultMatrix) resultMatrix.identity();
		else resultMatrix = new Matrix();
		
		if (targetSpace == this)
		{
			return resultMatrix;
		}
		else if (targetSpace == mParent || (targetSpace == null && mParent == null))
		{
			resultMatrix.copyFrom(transformationMatrix);
			return resultMatrix;
		}
		else if (targetSpace == null || targetSpace == base)
		{
			// targetCoordinateSpace 'null' represents the target space of the base object.
			// -> move up from this to base
			
			currentObject = this;
			while (currentObject != targetSpace)
			{
				resultMatrix.concat(currentObject.transformationMatrix);
				currentObject = currentObject.mParent;
			}
			
			return resultMatrix;
		}
		else if (targetSpace.mParent == this) // optimization
		{
			targetSpace.getTransformationMatrix(this, resultMatrix);
			resultMatrix.invert();
			
			return resultMatrix;
		}
		
		// 1. find a common parent of this and the target space
		
		commonParent = null;
		currentObject = this;
		
		while (currentObject)
		{
			sAncestors.push(currentObject);
			currentObject = currentObject.mParent;
		}
		
		currentObject = targetSpace;
		while (currentObject && sAncestors.indexOf(currentObject) == -1)
			currentObject = currentObject.mParent;
		
		sAncestors.length = 0;
		
		if (currentObject) commonParent = currentObject;
		else throw new ArgumentError("Object not connected to target");
		
		// 2. move up from this to common parent
		
		currentObject = this;
		while (currentObject != commonParent)
		{
			resultMatrix.concat(currentObject.transformationMatrix);
			currentObject = currentObject.mParent;
		}
		
		if (commonParent == targetSpace)
			return resultMatrix;
		
		// 3. now move up from target until we reach the common parent
		
		sHelperMatrix.identity();
		currentObject = targetSpace;
		while (currentObject != commonParent)
		{
			sHelperMatrix.concat(currentObject.transformationMatrix);
			currentObject = currentObject.mParent;
		}
		
		// 4. now combine the two matrices
		
		sHelperMatrix.invert();
		resultMatrix.concat(sHelperMatrix);
		
		return resultMatrix;
	}        
	
	/** Returns a rectangle that completely encloses the object as it appears in another 
	 *  coordinate system. If you pass a 'resultRectangle', the result will be stored in this 
	 *  rectangle instead of creating a new object. */ 
	public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
	{
		throw new AbstractMethodError("Method needs to be implemented in subclass");
		return null;
	}
	
	/** Returns the object that is found topmost beneath a point in local coordinates, or nil if 
	 *  the test fails. If "forTouch" is true, untouchable and invisible objects will cause
	 *  the test to fail. */
	public function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
	{
		// on a touch test, invisible or untouchable objects cause the test to fail
		if (forTouch && (!mVisible || !mTouchable)) return null;
		
		// otherwise, check bounding box
		if (getBounds(this, sHelperRect).containsPoint(localPoint)) return this;
		else return null;
	}
	
	/** Transforms a point from the local coordinate system to global (stage) coordinates.
	 *  If you pass a 'resultPoint', the result will be stored in this point instead of 
	 *  creating a new object. */
	public function localToGlobal(localPoint:Point, resultPoint:Point=null):Point
	{
		getTransformationMatrix(base, sHelperMatrix);
		return MatrixUtil.transformCoords(sHelperMatrix, localPoint.x, localPoint.y, resultPoint);
	}
	
	/** Transforms a point from global (stage) coordinates to the local coordinate system.
	 *  If you pass a 'resultPoint', the result will be stored in this point instead of 
	 *  creating a new object. */
	public function globalToLocal(globalPoint:Point, resultPoint:Point=null):Point
	{
		getTransformationMatrix(base, sHelperMatrix);
		sHelperMatrix.invert();
		return MatrixUtil.transformCoords(sHelperMatrix, globalPoint.x, globalPoint.y, resultPoint);
	}
	
	/** Renders the display object with the help of a support object. Never call this method
	 *  directly, except from within another render method.
	 *  @param support Provides utility functions for rendering.
	 *  @param parentAlpha The accumulated alpha value from the object's parent up to the stage. */
	public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		throw new AbstractMethodError("Method needs to be implemented in subclass");
	}
	
	/** Indicates if an object occupies any visible area. (Which is the case when its 'alpha', 
	 *  'scaleX' and 'scaleY' values are not zero, and its 'visible' property is enabled.) */
	private function get_hasVisibleArea():Bool
	{
		return mAlpha != 0.0 && mVisible && mScaleX != 0.0 && mScaleY != 0.0;
	}
	
	// internal methods
	
	/** @private */
	public function setParent(value:DisplayObjectContainer):Void 
	{
		// check for a recursion
		var ancestor:DisplayObject = value;
		while (ancestor != this && ancestor != null)
			ancestor = ancestor.mParent;
		
		if (ancestor == this)
			throw new ArgumentError("An object cannot be added as a child to itself or one " +
									"of its children (or children's children, etc.)");
		else
			mParent = value; 
	}
	
	// helpers
	
	private inline function isEquivalent(a:Float, b:Float, epsilon:Float = 0.0001):Bool
	{
		return (a - epsilon < b) && (a + epsilon > b);
	}
	
	private function normalizeAngle(angle:Float):Float
	{
		// move into range [-180 deg, +180 deg]
		while (angle < -Math.PI) angle += Math.PI * 2.0;
		while (angle >  Math.PI) angle -= Math.PI * 2.0;
		return angle;
	}
	
	// properties

	/** The transformation matrix of the object relative to its parent.
	 * 
	 *  <p>If you assign a custom transformation matrix, Starling will try to figure out  
	 *  suitable values for <code>x, y, scaleX, scaleY,</code> and <code>rotation</code>.
	 *  However, if the matrix was created in a different way, this might not be possible. 
	 *  In that case, Starling will apply the matrix, but not update the corresponding 
	 *  properties.</p>
	 * 
	 *  @returns CAUTION: not a copy, but the actual object! */
	private function get_transformationMatrix():Matrix
	{
		if (mOrientationChanged)
		{
			mOrientationChanged = false;
			
			if (mSkewX == 0.0 && mSkewY == 0.0)
			{
				// optimization: no skewing / rotation simplifies the matrix math
				
				if (mRotation == 0.0)
				{
					mTransformationMatrix.setTo(mScaleX, 0.0, 0.0, mScaleY, 
						mX - mPivotX * mScaleX, mY - mPivotY * mScaleY);
				}
				else
				{
					var cos:Float = Math.cos(mRotation);
					var sin:Float = Math.sin(mRotation);
					var a:Float   = mScaleX *  cos;
					var b:Float   = mScaleX *  sin;
					var c:Float   = mScaleY * -sin;
					var d:Float   = mScaleY *  cos;
					var tx:Float  = mX - mPivotX * a - mPivotY * c;
					var ty:Float  = mY - mPivotX * b - mPivotY * d;
					
					mTransformationMatrix.setTo(a, b, c, d, tx, ty);
				}
			}
			else
			{
				mTransformationMatrix.identity();
				mTransformationMatrix.scale(mScaleX, mScaleY);
				MatrixUtil.skew(mTransformationMatrix, mSkewX, mSkewY);
				mTransformationMatrix.rotate(mRotation);
				mTransformationMatrix.translate(mX, mY);
				
				if (mPivotX != 0.0 || mPivotY != 0.0)
				{
					// prepend pivot transformation
					mTransformationMatrix.tx = mX - mTransformationMatrix.a * mPivotX
												  - mTransformationMatrix.c * mPivotY;
					mTransformationMatrix.ty = mY - mTransformationMatrix.b * mPivotX 
												  - mTransformationMatrix.d * mPivotY;
				}
			}
		}
		
		return mTransformationMatrix; 
	}
	
	private function set_transformationMatrix(matrix:Matrix):Void
	{
		mOrientationChanged = false;
		mTransformationMatrix.copyFrom(matrix);

		mX = matrix.tx;
		mY = matrix.ty;
		
		mScaleX = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
		mSkewY  = Math.acos(matrix.a / mScaleX);
		
		if (!isEquivalent(matrix.b, mScaleX * Math.sin(mSkewY)))
		{
			mScaleX *= -1;
			mSkewY = Math.acos(matrix.a / mScaleX);
		}
		
		mScaleY = Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d);
		mSkewX  = Math.acos(matrix.d / mScaleY);
		
		if (!isEquivalent(matrix.c, -mScaleY * Math.sin(mSkewX)))
		{
			mScaleY *= -1;
			mSkewX = Math.acos(matrix.d / mScaleY);
		}
		
		if (isEquivalent(mSkewX, mSkewY))
		{
			mRotation = mSkewX;
			mSkewX = mSkewY = 0;
		}
		else
		{
			mRotation = 0;
		}
	}
	
	public var useHandCursor(get, set):Bool;
	/** Indicates if the mouse cursor should transform into a hand while it's over the sprite. 
	 *  @default false */
	private function get_useHandCursor():Bool 
	{ 
		return mUseHandCursor; 
	}
	
	private function set_useHandCursor(value:Bool):Void
	{
		if (value == mUseHandCursor) 
			return;
			
		mUseHandCursor = value;
		
		if (mUseHandCursor)
			addEventListener(TouchEvent.TOUCH, onTouch);
		else
			removeEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	private function onTouch(event:TouchEvent):Void
	{
		Mouse.cursor = event.interactsWith(this) ? MouseCursor.BUTTON : MouseCursor.AUTO;
	}
	
	/** The bounds of the object relative to the local coordinates of the parent. */
	private function get_bounds():Rectangle
	{
		return getBounds(mParent);
	}
	
	/** The width of the object in pixels. */
	private function get_width():Float { return getBounds(mParent, sHelperRect).width; }
	private function set_width(value:Float):Void
	{
		// this method calls 'this.scaleX' instead of changing mScaleX directly.
		// that way, subclasses reacting on size changes need to override only the scaleX method.
		
		scaleX = 1.0;
		var actualWidth:Float = width;
		if (actualWidth != 0.0) scaleX = value / actualWidth;
	}
	
	/** The height of the object in pixels. */
	private function get_height():Float { return getBounds(mParent, sHelperRect).height; }
	private function set_height(value:Float):Void
	{
		scaleY = 1.0;
		var actualHeight:Float = height;
		if (actualHeight != 0.0) scaleY = value / actualHeight;
	}
	
	/** The x coordinate of the object relative to the local coordinates of the parent. */
	private function get_x():Float { return mX; }
	private function set_x(value:Float):Void 
	{ 
		if (mX != value)
		{
			mX = value;
			mOrientationChanged = true;
		}
	}
	
	/** The y coordinate of the object relative to the local coordinates of the parent. */
	private function get_y():Float { return mY; }
	private function set_y(value:Float):Void 
	{
		if (mY != value)
		{
			mY = value;
			mOrientationChanged = true;
		}
	}
	
	/** The x coordinate of the object's origin in its own coordinate space (default: 0). */
	private function get_pivotX():Float { return mPivotX; }
	private function set_pivotX(value:Float):Void 
	{
		if (mPivotX != value)
		{
			mPivotX = value;
			mOrientationChanged = true;
		}
	}
	
	/** The y coordinate of the object's origin in its own coordinate space (default: 0). */
	private function get_pivotY():Float { return mPivotY; }
	private function set_pivotY(value:Float):Void 
	{ 
		if (mPivotY != value)
		{
			mPivotY = value;
			mOrientationChanged = true;
		}
	}
	
	/** The horizontal scale factor. '1' means no scale, negative values flip the object. */
	private function get_scaleX():Float { return mScaleX; }
	private function set_scaleX(value:Float):Void 
	{ 
		if (mScaleX != value)
		{
			mScaleX = value;
			mOrientationChanged = true;
		}
	}
	
	/** The vertical scale factor. '1' means no scale, negative values flip the object. */
	private function get_scaleY():Float { return mScaleY; }
	private function set_scaleY(value:Float):Void 
	{ 
		if (mScaleY != value)
		{
			mScaleY = value;
			mOrientationChanged = true;
		}
	}
	
	/** The horizontal skew angle in radians. */
	private function get_skewX():Float { return mSkewX; }
	private function set_skewX(value:Float):Void 
	{
		value = normalizeAngle(value);
		
		if (mSkewX != value)
		{
			mSkewX = value;
			mOrientationChanged = true;
		}
	}
	
	/** The vertical skew angle in radians. */
	private function get_skewY():Float { return mSkewY; }
	private function set_skewY(value:Float):Void 
	{
		value = normalizeAngle(value);
		
		if (mSkewY != value)
		{
			mSkewY = value;
			mOrientationChanged = true;
		}
	}
	
	/** The rotation of the object in radians. (In Starling, all angles are measured 
	 *  in radians.) */
	private function get_rotation():Float { return mRotation; }
	private function set_rotation(value:Float):Void 
	{
		value = normalizeAngle(value);

		if (mRotation != value)
		{            
			mRotation = value;
			mOrientationChanged = true;
		}
	}
	
	/** The opacity of the object. 0 = transparent, 1 = opaque. */
	private function get_alpha():Float { return mAlpha; }
	private function set_alpha(value:Float):Void 
	{ 
		mAlpha = value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value); 
	}
	
	/** The visibility of the object. An invisible object will be untouchable. */
	private function get_visible():Bool { return mVisible; }
	private function set_visible(value:Bool):Void { mVisible = value; }
	
	/** Indicates if this object (and its children) will receive touch events. */
	private function get_touchable():Bool { return mTouchable; }
	private function set_touchable(value:Bool):Void { mTouchable = value; }
	
	/** The blend mode determines how the object is blended with the objects underneath. 
	 *   @default auto
	 *   @see starling.display.BlendMode */ 
	private function get_blendMode():String { return mBlendMode; }
	private function set_blendMode(value:String):Void { mBlendMode = value; }
	
	/** The name of the display object (default: null). Used by 'getChildByName()' of 
	 *  display object containers. */
	private function get_name():String { return mName; }
	private function set_name(value:String):Void { mName = value; }
	
	/** The filter that is attached to the display object. The starling.filters 
	 *  package contains several classes that define specific filters you can use. 
	 *  Beware that you should NOT use the same filter on more than one object (for 
	 *  performance reasons). */ 
	private function get_filter():FragmentFilter { return mFilter; }
	private function set_filter(value:FragmentFilter):Void { mFilter = value; }
	
	/** The display object container that contains this display object. */
	private function get_parent():DisplayObjectContainer { return mParent; }
	
	/** The topmost object in the display tree the object is part of. */
	private function get_base():DisplayObject
	{
		var currentObject:DisplayObject = this;
		while (currentObject.mParent) currentObject = currentObject.mParent;
		return currentObject;
	}
	
	/** The root object the display object is connected to (i.e. an instance of the class 
	 *  that was passed to the Starling constructor), or null if the object is not connected
	 *  to the stage. */
	private function get_root():DisplayObject
	{
		var currentObject:DisplayObject = this;
		while (currentObject.mParent)
		{
			if (Std.is(currentObject.mParent, Stage)) 
				return currentObject;
			else currentObject = currentObject.parent;
		}
		
		return null;
	}
	
	/** The stage the display object is connected to, or null if it is not connected 
	 *  to the stage. */
	private function get_stage():Stage 
	{ 
		return cast(this.base, Stage); 
	}
}