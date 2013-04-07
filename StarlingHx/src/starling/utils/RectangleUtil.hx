// =================================================================================================
//
//	Starling Framework
//	Copyright 2012 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import flash.geom.Rectangle;

import starling.errors.AbstractClassError;

/** A utility class containing methods related to the Rectangle class. */
class RectangleUtil
{
	/** Calculates the intersection between two Rectangles. If the rectangles do not intersect,
	 *  this method returns an empty Rectangle object with its properties set to 0. */
	public static function intersect(rect1:Rectangle, rect2:Rectangle, 
									 resultRect:Rectangle=null):Rectangle
	{
		if (resultRect == null) resultRect = new Rectangle();
		
		var left:Float   = Math.max(rect1.x, rect2.x);
		var right:Float  = Math.min(rect1.x + rect1.width, rect2.x + rect2.width);
		var top:Float    = Math.max(rect1.y, rect2.y);
		var bottom:Float = Math.min(rect1.y + rect1.height, rect2.y + rect2.height);
		
		if (left > right || top > bottom)
			resultRect.setEmpty();
		else
			resultRect.setTo(left, top, right-left, bottom-top);
		
		return resultRect;
	}
	
	/** Calculates a rectangle with the same aspect ratio as the given 'rectangle',
	 *  centered within 'into'.  
	 * 
	 *  <p>This method is useful for calculating the optimal viewPort for a certain display 
	 *  size. You can use different scale modes to specify how the result should be calculated;
	 *  furthermore, you can avoid pixel alignment errors by only allowing whole-number  
	 *  multipliers/divisors (e.g. 3, 2, 1, 1/2, 1/3).</p>
	 *  
	 *  @see starling.utils.ScaleMode
	 */
	public static function fit(rectangle:Rectangle, into:Rectangle, 
							   scaleMode:String="showAll", pixelPerfect:Bool=false,
							   resultRect:Rectangle=null):Rectangle
	{
		if (!ScaleMode.isValid(scaleMode)) throw new ArgumentError("Invalid scaleMode: " + scaleMode);
		if (resultRect == null) resultRect = new Rectangle();
		
		var width:Float   = rectangle.width;
		var height:Float  = rectangle.height;
		var factorX:Float = into.width  / width;
		var factorY:Float = into.height / height;
		var factor:Float  = 1.0;
		
		if (scaleMode == ScaleMode.SHOW_ALL)
		{
			factor = factorX < factorY ? factorX : factorY;
			if (pixelPerfect) factor = nextSuitableScaleFactor(factor, false);
		}
		else if (scaleMode == ScaleMode.NO_BORDER)
		{
			factor = factorX > factorY ? factorX : factorY;
			if (pixelPerfect) factor = nextSuitableScaleFactor(factor, true);
		}
		
		width  *= factor;
		height *= factor;
		
		resultRect.setTo(
			into.x + (into.width  - width)  / 2,
			into.y + (into.height - height) / 2,
			width, height);
		
		return resultRect;
	}
	
	/** Calculates the next whole-number multiplier or divisor, moving either up or down. */
	private static function nextSuitableScaleFactor(factor:Float, up:Bool):Float
	{
		var divisor:Float = 1.0;
		
		if (up)
		{
			if (factor >= 0.5) return Math.ceil(factor);
			else
			{
				while (1.0 / (divisor + 1) > factor)
					++divisor;
			}
		}
		else
		{
			if (factor >= 1.0) return Math.floor(factor);
			else
			{
				while (1.0 / divisor > factor)
					++divisor;
			}
		}
		
		return 1.0 / divisor;
	}
}