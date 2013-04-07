// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;

import flash.display3D.textures.TextureBase;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.utils.VertexData;

/** A SubTexture represents a section of another texture. This is achieved solely by 
 *  manipulation of texture coordinates, making the class very efficient. 
 *
 *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
 */ 
class SubTexture extends Texture
{
	private var mParent:Texture;
	private var mClipping:Rectangle;
	private var mRootClipping:Rectangle;
	private var mOwnsParent:Bool;
	
	/** Helper object. */
	private static var sTexCoords:Point = new Point();
	
	/** Creates a new subtexture containing the specified region (in points) of a parent 
	 *  texture. If 'ownsParent' is true, the parent texture will be disposed automatically
	 *  when the subtexture is disposed. */
	public function new(parentTexture:Texture, region:Rectangle,
							   ownsParent:Bool=false)
	{
		mParent = parentTexture;
		mOwnsParent = ownsParent;
		
		if (region == null) setClipping(new Rectangle(0, 0, 1, 1));
		else setClipping(new Rectangle(region.x / parentTexture.width,
									   region.y / parentTexture.height,
									   region.width / parentTexture.width,
									   region.height / parentTexture.height));
	}
	
	/** Disposes the parent texture if this texture owns it. */
	public override function dispose():Void
	{
		if (mOwnsParent) mParent.dispose();
		super.dispose();
	}
	
	private function setClipping(value:Rectangle):Void
	{
		mClipping = value;
		mRootClipping = value.clone();
		
		var parentTexture:SubTexture = mParent as SubTexture;
		while (parentTexture)
		{
			var parentClipping:Rectangle = parentTexture.mClipping;
			mRootClipping.x = parentClipping.x + mRootClipping.x * parentClipping.width;
			mRootClipping.y = parentClipping.y + mRootClipping.y * parentClipping.height;
			mRootClipping.width  *= parentClipping.width;
			mRootClipping.height *= parentClipping.height;
			parentTexture = parentTexture.mParent as SubTexture;
		}
	}
	
	/** @inheritDoc */
	public override function adjustVertexData(vertexData:VertexData, vertexID:Int, count:Int):Void
	{
		super.adjustVertexData(vertexData, vertexID, count);
		
		var clipX:Float = mRootClipping.x;
		var clipY:Float = mRootClipping.y;
		var clipWidth:Float  = mRootClipping.width;
		var clipHeight:Float = mRootClipping.height;
		var endIndex:Int = vertexID + count;
		
		for (var i:Int=vertexID; i<endIndex; ++i)
		{
			vertexData.getTexCoords(i, sTexCoords);
			vertexData.setTexCoords(i, clipX + sTexCoords.x * clipWidth,
									   clipY + sTexCoords.y * clipHeight);
		}
	}
	
	/** The texture which the subtexture is based on. */ 
	private function get_parent():Texture { return mParent; }
	
	/** Indicates if the parent texture is disposed when this object is disposed. */
	private function get_ownsParent():Bool { return mOwnsParent; }
	
	/** The clipping rectangle, which is the region provided on initialization 
	 *  scaled into [0.0, 1.0]. */
	private function get_clipping():Rectangle { return mClipping.clone(); }
	
	/** @inheritDoc */
	private override function get_base():TextureBase { return mParent.base; }
	
	/** @inheritDoc */
	private override function get_root():ConcreteTexture { return mParent.root; }
	
	/** @inheritDoc */
	private override function get_format():String { return mParent.format; }
	
	/** @inheritDoc */
	private override function get_width():Float { return mParent.width * mClipping.width; }
	
	/** @inheritDoc */
	private override function get_height():Float { return mParent.height * mClipping.height; }
	
	/** @inheritDoc */
	private override function get_nativeWidth():Float { return mParent.nativeWidth * mClipping.width; }
	
	/** @inheritDoc */
	private override function get_nativeHeight():Float { return mParent.nativeHeight * mClipping.height; }
	
	/** @inheritDoc */
	private override function get_mipMapping():Bool { return mParent.mipMapping; }
	
	/** @inheritDoc */
	private override function get_premultipliedAlpha():Bool { return mParent.premultipliedAlpha; }
	
	/** @inheritDoc */
	private override function get_scale():Float { return mParent.scale; } 
	
}