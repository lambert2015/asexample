// =================================================================================================
//
//	Starling Framework
//	Copyright 2012 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;

import flash.display3D.Context3DTextureFormat;
import flash.utils.ByteArray;

/** A parser for the ATF data format. */
internal class AtfData
{
	private var mFormat:String;
	private var mWidth:Int;
	private var mHeight:Int;
	private var mNumTextures:Int;
	private var mData:ByteArray;
	
	/** Create a new instance by parsing the given byte array. */
	public function new(data:ByteArray)
	{
		var signature:String = String.fromCharCode(data[0], data[1], data[2]);
		if (signature != "ATF") throw new ArgumentError("Invalid ATF data");
		
		switch (data[6])
		{
			case 0,1: mFormat = Context3DTextureFormat.BGRA; 
			case 2,3: mFormat = Context3DTextureFormat.COMPRESSED; 
			case 4,5: mFormat = "compressedAlpha";  // explicit string to stay compatible 
														// with older versions
			default: throw new Error("Invalid ATF format");
		}
		
		mWidth = Math.pow(2, data[7]); 
		mHeight = Math.pow(2, data[8]);
		mNumTextures = data[9];
		mData = data;
	}
	
	private function get_format():String { return mFormat; }
	private function get_width():Int { return mWidth; }
	private function get_height():Int { return mHeight; }
	private function get_numTextures():Int { return mNumTextures; }
	private function get_data():ByteArray { return mData; }
}