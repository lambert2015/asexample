// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;

/** The VertexData class manages a raw list of vertex information, allowing direct upload
 *  to Stage3D vertex buffers. <em>You only have to work with this class if you create display 
 *  objects with a custom render function. If you don't plan to do that, you can safely 
 *  ignore it.</em>
 * 
 *  <p>To render objects with Stage3D, you have to organize vertex data in so-called
 *  vertex buffers. Those buffers reside in graphics memory and can be accessed very 
 *  efficiently by the GPU. Before you can move data into vertex buffers, you have to 
 *  set it up in conventional memory - that is, in a Vector object. The vector contains
 *  all vertex information (the coordinates, color, and texture coordinates) - one
 *  vertex after the other.</p>
 *  
 *  <p>To simplify creating and working with such a bulky list, the VertexData class was 
 *  created. It contains methods to specify and modify vertex data. The raw Vector managed 
 *  by the class can then easily be uploaded to a vertex buffer.</p>
 * 
 *  <strong>Premultiplied Alpha</strong>
 *  
 *  <p>The color values of the "BitmapData" object contain premultiplied alpha values, which 
 *  means that the <code>rgb</code> values were multiplied with the <code>alpha</code> value 
 *  before saving them. Since textures are created from bitmap data, they contain the values in 
 *  the same style. On rendering, it makes a difference in which way the alpha value is saved; 
 *  for that reason, the VertexData class mimics this behavior. You can choose how the alpha 
 *  values should be handled via the <code>premultipliedAlpha</code> property.</p>
 * 
 */ 
class VertexData 
{
	/** The total Float of elements (Floats) stored per vertex. */
	public static inline var ELEMENTS_PER_VERTEX:Int = 8;
	
	/** The offset of position data (x, y) within a vertex. */
	public static inline var POSITION_OFFSET:Int = 0;
	
	/** The offset of color data (r, g, b, a) within a vertex. */ 
	public static inline var COLOR_OFFSET:Int = 2;
	
	/** The offset of texture coordinates (u, v) within a vertex. */
	public static inline var TEXCOORD_OFFSET:Int = 6;
	
	public var tinted(get, null):Bool;
	public var premultipliedAlpha(get, null):Bool;
	public var numVertices(get, set):Int;
	public var rawData(get,null):Vector<Float>;
	
	private var mRawData:Vector<Float>;
	private var mPremultipliedAlpha:Bool;
	private var mNumVertices:Int;

	/** Helper object. */
	private static var sHelperPoint:Point = new Point();
	
	/** Create a new VertexData object with a specified Float of vertices. */
	public function new(numVertices:Int, premultipliedAlpha:Bool = false)
	{
		mRawData = new Vector<Float>();
		mPremultipliedAlpha = premultipliedAlpha;
		this.numVertices = numVertices;
	}

	/** Creates a duplicate of either the complete vertex data object, or of a subset. 
	 *  To clone all vertices, set 'numVertices' to '-1'. */
	public function clone(vertexID:Int = 0, numVertices:Int = -1):VertexData
	{
		if (numVertices < 0 || vertexID + numVertices > mNumVertices)
			numVertices = mNumVertices - vertexID;
		
		var clone:VertexData = new VertexData(0, mPremultipliedAlpha);
		clone.mNumVertices = numVertices; 
		clone.mRawData = mRawData.slice(vertexID * ELEMENTS_PER_VERTEX, 
										numVertices * ELEMENTS_PER_VERTEX); 
		clone.mRawData.fixed = true;
		return clone;
	}
	
	/** Copies the vertex data (or a range of it, defined by 'vertexID' and 'numVertices') 
	 *  of this instance to another vertex data object, starting at a certain index. */
	public function copyTo(targetData:VertexData, targetVertexID:Int = 0,
						   vertexID:Int = 0, numVertices:Int = -1):Void
	{
		if (numVertices < 0 || vertexID + numVertices > mNumVertices)
			numVertices = mNumVertices - vertexID;
		
		// todo: check/convert pma
		
		var targetRawData:Vector<Float> = targetData.mRawData;
		var targetIndex:Int = targetVertexID * ELEMENTS_PER_VERTEX;
		var sourceIndex:Int = vertexID * ELEMENTS_PER_VERTEX;
		var dataLength:Int = numVertices * ELEMENTS_PER_VERTEX;
		for (i in sourceIndex...dataLength)
			targetRawData[targetIndex++] = mRawData[i];
	}
	
	/** Appends the vertices from another VertexData object. */
	public function append(data:VertexData):Void
	{
		mRawData.fixed = false;
		
		var targetIndex:Int = mRawData.length;
		var rawData:Vector<Float> = data.mRawData;
		var rawDataLength:Int = rawData.length;
		
		for (i in 0...rawDataLength)
			mRawData[targetIndex++] = rawData[i];
		
		mNumVertices += data.numVertices;
		mRawData.fixed = true;
	}
	
	// functions
	
	/** Updates the position values of a vertex. */
	public function setPosition(vertexID:Int, x:Float, y:Float):Void
	{
		var offset:Int = getOffset(vertexID) + POSITION_OFFSET;
		mRawData[offset] = x;
		mRawData[offset+1] = y;
	}
	
	/** Returns the position of a vertex. */
	public function getPosition(vertexID:Int, position:Point):Void
	{
		var offset:Int = getOffset(vertexID) + POSITION_OFFSET;
		position.x = mRawData[offset];
		position.y = mRawData[offset+1];
	}
	
	/** Updates the RGB color values of a vertex. */ 
	public function setColor(vertexID:Int, color:UInt):Void
	{   
		var offset:Int = getOffset(vertexID) + COLOR_OFFSET;
		var multiplier:Float = mPremultipliedAlpha ? mRawData[offset + 3] : 1.0;
		mRawData[offset]     = ((color >> 16) & 0xff) / 255.0 * multiplier;
		mRawData[offset + 1] = ((color >>  8) & 0xff) / 255.0 * multiplier;
		mRawData[offset + 2] = ( color        & 0xff) / 255.0 * multiplier;
	}
	
	/** Returns the RGB color of a vertex (no alpha). */
	public function getColor(vertexID:Int):UInt
	{
		var offset:Int = getOffset(vertexID) + COLOR_OFFSET;
		var divisor:Float = mPremultipliedAlpha ? mRawData[offset + 3] : 1.0;
		
		if (divisor == 0) 
			return 0;
		else
		{
			var red:Float   = mRawData[offset]     / divisor;
			var green:Float = mRawData[offset + 1] / divisor;
			var blue:Float  = mRawData[offset + 2] / divisor;
			
			return ColorUtil.frgb(red, green, blue);
		}
	}
	
	/** Updates the alpha value of a vertex (range 0-1). */
	public function setAlpha(vertexID:Int, alpha:Float):Void
	{
		var offset:Int = getOffset(vertexID) + COLOR_OFFSET + 3;
		
		if (mPremultipliedAlpha)
		{
			if (alpha < 0.001) alpha = 0.001; // zero alpha would wipe out all color data
			var color:UInt = getColor(vertexID);
			mRawData[offset] = alpha;
			setColor(vertexID, color);
		}
		else
		{
			mRawData[offset] = alpha;
		}
	}
	
	/** Returns the alpha value of a vertex in the range 0-1. */
	public function getAlpha(vertexID:Int):Float
	{
		var offset:Int = getOffset(vertexID) + COLOR_OFFSET + 3;
		return mRawData[offset];
	}
	
	/** Updates the texture coordinates of a vertex (range 0-1). */
	public function setTexCoords(vertexID:Int, u:Float, v:Float):Void
	{
		var offset:Int = getOffset(vertexID) + TEXCOORD_OFFSET;
		mRawData[offset]        = u;
		mRawData[offset+1] = v;
	}
	
	/** Returns the texture coordinates of a vertex in the range 0-1. */
	public function getTexCoords(vertexID:Int, texCoords:Point):Void
	{
		var offset:Int = getOffset(vertexID) + TEXCOORD_OFFSET;
		texCoords.x = mRawData[offset];
		texCoords.y = mRawData[offset+1];
	}
	
	// utility functions
	
	/** Translate the position of a vertex by a certain offset. */
	public function translateVertex(vertexID:Int, deltaX:Float, deltaY:Float):Void
	{
		var offset:Int = getOffset(vertexID) + POSITION_OFFSET;
		mRawData[offset]        += deltaX;
		mRawData[offset+1] += deltaY;
	}

	/** Transforms the position of subsequent vertices by multiplication with a 
	 *  transformation matrix. */
	public function transformVertex(vertexID:Int, matrix:Matrix, numVertices:Int = 1):Void
	{
		var offset:Int = getOffset(vertexID) + POSITION_OFFSET;
		
		for (i in 0...numVertices)
		{
			var x:Float = mRawData[offset];
			var y:Float = mRawData[offset + 1];
			
			mRawData[offset]   = matrix.a * x + matrix.c * y + matrix.tx;
			mRawData[offset+1] = matrix.d * y + matrix.b * x + matrix.ty;
			
			offset += ELEMENTS_PER_VERTEX;
		}
	}
	
	/** Sets all vertices of the object to the same color values. */
	public function setUniformColor(color:UInt):Void
	{
		for (i in 0...mNumVertices)
			setColor(i, color);
	}
	
	/** Sets all vertices of the object to the same alpha values. */
	public function setUniformAlpha(alpha:Float):Void
	{
		for (i in 0...mNumVertices)
			setAlpha(i, alpha);
	}
	
	/** Multiplies the alpha value of subsequent vertices with a certain delta. */
	public function scaleAlpha(vertexID:Int, alpha:Float, numVertices:Int = 1):Void
	{
		if (alpha == 1.0) 
			return;
			
		if (numVertices < 0 || vertexID + numVertices > mNumVertices)
			numVertices = mNumVertices - vertexID;
		 
		var i:Int;
		
		if (mPremultipliedAlpha)
		{
			for (i in 0...numVertices)
				setAlpha(vertexID+i, getAlpha(vertexID+i) * alpha);
		}
		else
		{
			var offset:Int = getOffset(vertexID) + COLOR_OFFSET + 3;
			for (i in 0...numVertices)
				mRawData[offset + i*ELEMENTS_PER_VERTEX] *= alpha;
		}
	}
	
	private inline function getOffset(vertexID:Int):Int
	{
		return vertexID * ELEMENTS_PER_VERTEX;
	}
	
	/** Calculates the bounds of the vertices, which are optionally transformed by a matrix. 
	 *  If you pass a 'resultRect', the result will be stored in this rectangle 
	 *  instead of creating a new object. To use all vertices for the calculation, set
	 *  'numVertices' to '-1'. */
	public function getBounds(transformationMatrix:Matrix = null, 
							  vertexID:Int = 0, numVertices:Int = -1,
							  resultRect:Rectangle = null):Rectangle
	{
		if (resultRect == null) 
			resultRect = new Rectangle();
			
		if (numVertices < 0 || vertexID + numVertices > mNumVertices)
			numVertices = mNumVertices - vertexID;
		
		var minX:Float = Math.POSITIVE_INFINITY, maxX:Float = -Math.POSITIVE_INFINITY;
		var minY:Float = Math.POSITIVE_INFINITY, maxY:Float = -Math.POSITIVE_INFINITY;
		var offset:Int = getOffset(vertexID) + POSITION_OFFSET;
		var x:Float, y:Float, i:Int;
		
		if (transformationMatrix == null)
		{
			for (i in 0...numVertices)
			{
				x = mRawData[offset];
				y = mRawData[offset+1];
				offset += ELEMENTS_PER_VERTEX;
				
				minX = minX < x ? minX : x;
				maxX = maxX > x ? maxX : x;
				minY = minY < y ? minY : y;
				maxY = maxY > y ? maxY : y;
			}
		}
		else
		{
			for (i in 0...numVertices)
			{
				x = mRawData[offset];
				y = mRawData[offset+1];
				offset += ELEMENTS_PER_VERTEX;
				
				MatrixUtil.transformCoords(transformationMatrix, x, y, sHelperPoint);
				minX = minX < sHelperPoint.x ? minX : sHelperPoint.x;
				maxX = maxX > sHelperPoint.x ? maxX : sHelperPoint.x;
				minY = minY < sHelperPoint.y ? minY : sHelperPoint.y;
				maxY = maxY > sHelperPoint.y ? maxY : sHelperPoint.y;
			}
		}
		
		resultRect.setTo(minX, minY, maxX - minX, maxY - minY);
		return resultRect;
	}
	
	// properties
	
	/** Indicates if any vertices have a non-white color or are not fully opaque. */
	private function get_tinted():Bool
	{
		var offset:Int = COLOR_OFFSET;
		
		for (i in 0...numVertices)
		{
			for (j in 0...4)
				if (mRawData[offset + j] != 1.0) 
					return true;

			offset += ELEMENTS_PER_VERTEX;
		}
		
		return false;
	}
	
	/** Changes the way alpha and color values are stored. Updates all exisiting vertices. */
	public function setPremultipliedAlpha(value:Bool, updateData:Bool = true):Void
	{
		if (value == mPremultipliedAlpha) return;
		
		if (updateData)
		{
			var dataLength:Int = mNumVertices * ELEMENTS_PER_VERTEX;
			
			var i:Int = COLOR_OFFSET;
			while (i < dataLength)
			{
				var alpha:Float = mRawData[i+3];
				var divisor:Float = mPremultipliedAlpha ? alpha : 1.0;
				var multiplier:Float = value ? alpha : 1.0;
				
				if (divisor != 0)
				{
					mRawData[i]   = mRawData[i]   / divisor * multiplier;
					mRawData[i+1] = mRawData[i+1] / divisor * multiplier;
					mRawData[i+2] = mRawData[i+2] / divisor * multiplier;
				}
				
				i += ELEMENTS_PER_VERTEX;
			}
		}
		
		mPremultipliedAlpha = value;
	}
	
	/** Indicates if the rgb values are stored premultiplied with the alpha value. */
	private function get_premultipliedAlpha():Bool 
	{ 
		return mPremultipliedAlpha; 
	}
	
	/** The total Float of vertices. */
	private function get_numVertices():Int 
	{ 
		return mNumVertices; 
	}
	private function set_numVertices(value:Int):Int
	{
		mRawData.fixed = false;
		
		var i:Int;
		var delta:Int = value - mNumVertices;
		
		for (i in 0...delta)
		{
			mRawData.push(0);
			mRawData.push(0);
			mRawData.push(0);
			mRawData.push(0);
			mRawData.push(0);
			mRawData.push(1);
			mRawData.push(0);
			mRawData.push(0); // alpha should be '1' per default
		}
		
		for (i in 0... -(delta * ELEMENTS_PER_VERTEX))
			mRawData.pop();
		
		mNumVertices = value;
		mRawData.fixed = true;
		
		return mNumVertices;
	}
	
	/** The raw vertex data; not a copy! */
	private function get_rawData():Vector<Float> 
	{ 
		return mRawData; 
	}
}

