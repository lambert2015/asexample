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

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.core.RenderSupport;
import starling.utils.VertexData;

/** A Quad represents a rectangle with a uniform color or a color gradient.
 *  
 *  <p>You can set one color per vertex. The colors will smoothly fade into each other over the area
 *  of the quad. To display a simple linear color gradient, assign one color to vertices 0 and 1 and 
 *  another color to vertices 2 and 3. </p> 
 *
 *  <p>The indices of the vertices are arranged like this:</p>
 *  
 *  <pre>
 *  0 - 1
 *  | / |
 *  2 - 3
 *  </pre>
 * 
 *  @see Image
 */
class Quad extends DisplayObject
{
	/** Helper objects. */
	private static var sHelperPoint:Point = new Point();
	private static var sHelperMatrix:Matrix = new Matrix();
	
	private var mTinted:Bool;
	
	/** The raw vertex data of the quad. */
	private var mVertexData:VertexData;
	
	/** Creates a quad with a certain size and color. The last parameter controls if the 
	 *  alpha value should be premultiplied into the color values on rendering, which can
	 *  influence blending output. You can use the default value in most cases.  */
	public function new(width:Float, height:Float, color:UInt = 0xffffff,
						 premultipliedAlpha:Bool = true)
	{
		mTinted = color != 0xffffff;
		
		mVertexData = new VertexData(4, premultipliedAlpha);
		mVertexData.setPosition(0, 0.0, 0.0);
		mVertexData.setPosition(1, width, 0.0);
		mVertexData.setPosition(2, 0.0, height);
		mVertexData.setPosition(3, width, height);            
		mVertexData.setUniformColor(color);
		
		onVertexDataChanged();
	}
	
	/** Call this method after manually changing the contents of 'mVertexData'. */
	private function onVertexDataChanged():Void
	{
		// override in subclasses, if necessary
	}
	
	/** @inheritDoc */
	public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle
	{
		if (resultRect == null) resultRect = new Rectangle();
		
		if (targetSpace == this) // optimization
		{
			mVertexData.getPosition(3, sHelperPoint);
			resultRect.setTo(0.0, 0.0, sHelperPoint.x, sHelperPoint.y);
		}
		else if (targetSpace == parent && rotation == 0.0) // optimization
		{
			var scaleX:Float = this.scaleX;
			var scaleY:Float = this.scaleY;
			mVertexData.getPosition(3, sHelperPoint);
			resultRect.setTo(x - pivotX * scaleX,      y - pivotY * scaleY,
							 sHelperPoint.x * scaleX, sHelperPoint.y * scaleY);
			if (scaleX < 0) { resultRect.width  *= -1; resultRect.x -= resultRect.width;  }
			if (scaleY < 0) { resultRect.height *= -1; resultRect.y -= resultRect.height; }
		}
		else
		{
			getTransformationMatrix(targetSpace, sHelperMatrix);
			mVertexData.getBounds(sHelperMatrix, 0, 4, resultRect);
		}
		
		return resultRect;
	}
	
	/** Returns the color of a vertex at a certain index. */
	public function getVertexColor(vertexID:Int):UInt
	{
		return mVertexData.getColor(vertexID);
	}
	
	/** Sets the color of a vertex at a certain index. */
	public function setVertexColor(vertexID:Int, color:UInt):Void
	{
		mVertexData.setColor(vertexID, color);
		onVertexDataChanged();
		
		if (color != 0xffffff) mTinted = true;
		else mTinted = mVertexData.tinted;
	}
	
	/** Returns the alpha value of a vertex at a certain index. */
	public function getVertexAlpha(vertexID:Int):Float
	{
		return mVertexData.getAlpha(vertexID);
	}
	
	/** Sets the alpha value of a vertex at a certain index. */
	public function setVertexAlpha(vertexID:Int, alpha:Float):Void
	{
		mVertexData.setAlpha(vertexID, alpha);
		onVertexDataChanged();
		
		if (alpha != 1.0) mTinted = true;
		else mTinted = mVertexData.tinted;
	}
	
	/** Returns the color of the quad, or of vertex 0 if vertices have different colors. */
	private function get_color():UInt 
	{ 
		return mVertexData.getColor(0); 
	}
	
	/** Sets the colors of all vertices to a certain value. */
	private function set_color(value:UInt):Void 
	{
		for (i in 0...4)
			setVertexColor(i, value);
		
		if (value != 0xffffff || alpha != 1.0) 
			mTinted = true;
		else 
			mTinted = mVertexData.tinted;
	}
	
	/** @inheritDoc **/
	private override function set_alpha(value:Float):Void
	{
		super.alpha = value;
		
		if (value < 1.0) mTinted = true;
		else mTinted = mVertexData.tinted;
	}
	
	/** Copies the raw vertex data to a VertexData instance. */
	public function copyVertexDataTo(targetData:VertexData, targetVertexID:Int=0):Void
	{
		mVertexData.copyTo(targetData, targetVertexID);
	}
	
	/** @inheritDoc */
	public override function render(support:RenderSupport, parentAlpha:Float):Void
	{
		support.batchQuad(this, parentAlpha);
	}
	
	/** Returns true if the quad (or any of its vertices) is non-white or non-opaque. */
	private function get_tinted():Bool 
	{ 
		return mTinted; 
	}
	
	/** Indicates if the rgb values are stored premultiplied with the alpha value; this can
	 *  affect the rendering. (Most developers don't have to care, though.) */
	private function get_premultipliedAlpha():Bool 
	{ 
		return mVertexData.premultipliedAlpha; 
	}
}
