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

import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.TextureBase;

import starling.core.Starling;
import starling.events.Event;

/** A ConcreteTexture wraps a Stage3D texture object, storing the properties of the texture. */
class ConcreteTexture extends Texture
{
	private var mBase:TextureBase;
	private var mFormat:Context3DTextureFormat;
	private var mWidth:Int;
	private var mHeight:Int;
	private var mMipMapping:Bool;
	private var mPremultipliedAlpha:Bool;
	private var mOptimizedForRenderTexture:Bool;
	private var mData:Dynamic;
	private var mScale:Float;
	
	/** Creates a ConcreteTexture object from a TextureBase, storing information about size,
	 *  mip-mapping, and if the channels contain premultiplied alpha values. */
	public function new(base:TextureBase, format:Context3DTextureFormat, width:Int, height:Int, 
									mipMapping:Bool, premultipliedAlpha:Bool,
									optimizedForRenderTexture:Bool=false,
									scale:Float=1)
	{
		super();
		
		mScale = scale <= 0 ? 1.0 : scale;
		mBase = base;
		mFormat = format;
		mWidth = width;
		mHeight = height;
		mMipMapping = mipMapping;
		mPremultipliedAlpha = premultipliedAlpha;
		mOptimizedForRenderTexture = optimizedForRenderTexture;
	}
	
	/** Disposes the TextureBase object. */
	public override function dispose():Void
	{
		if (mBase) mBase.dispose();
		restoreOnLostContext(null); // removes event listener & data reference 
		super.dispose();
	}
	
	// texture backup (context lost)
	
	/** Instructs this instance to restore its base texture when the context is lost. 'data' 
	 *  can be either BitmapData or a ByteArray with ATF data. */ 
	public function restoreOnLostContext(data:Dynamic):Void
	{
		if (mData == null && data != null)
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		else if (data == null)
			Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		
		mData = data;
	}
	
	private function onContextCreated(event:Event):Void
	{
		var context:Context3D = Starling.current.context;
		var bitmapData:BitmapData = cast(mData,BitmapData);
		var atfData:AtfData = cast(mData,AtfData);
		var nativeTexture:flash.display3D.textures.Texture;
		
		if (bitmapData != null)
		{
			nativeTexture = context.createTexture(mWidth, mHeight, 
				Context3DTextureFormat.BGRA, mOptimizedForRenderTexture);
			Texture.uploadBitmapData(nativeTexture, bitmapData, mMipMapping);
		}
		else if (atfData != null)
		{
			nativeTexture = context.createTexture(atfData.width, atfData.height, atfData.format,
												  mOptimizedForRenderTexture);
			Texture.uploadAtfData(nativeTexture, atfData.data);
		}
		
		mBase = nativeTexture;
	}
	
	// properties
	
	/** Indicates if the base texture was optimized for being used in a render texture. */
	private function get_optimizedForRenderTexture():Bool { return mOptimizedForRenderTexture; }
	
	/** @inheritDoc */
	private override function get_base():TextureBase { return mBase; }
	
	/** @inheritDoc */
	private override function get_root():ConcreteTexture { return this; }
	
	/** @inheritDoc */
	private override function get_format():String { return mFormat; }
	
	/** @inheritDoc */
	private override function get_width():Float  { return mWidth / mScale;  }
	
	/** @inheritDoc */
	private override function get_height():Float { return mHeight / mScale; }
	
	/** @inheritDoc */
	private override function get_nativeWidth():Float { return mWidth; }
	
	/** @inheritDoc */
	private override function get_nativeHeight():Float { return mHeight; }
	
	/** The scale factor, which influences width and height properties. */
	private override function get_scale():Float { return mScale; }
	
	/** @inheritDoc */
	private override function get_mipMapping():Bool { return mMipMapping; }
	
	/** @inheritDoc */
	private override function get_premultipliedAlpha():Bool { return mPremultipliedAlpha; }
}