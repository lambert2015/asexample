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

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.TextureBase;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import starling.utils.MathUtil;

import starling.core.Starling;
import starling.errors.AbstractClassError;
import starling.errors.MissingContextError;
import starling.utils.VertexData;

/** <p>A texture stores the information that represents an image. It cannot be added to the
 *  display list directly; instead it has to be mapped onto a display object. In Starling, 
 *  that display object is the class "Image".</p>
 * 
 *  <strong>Texture Formats</strong>
 *  
 *  <p>Since textures can be created from a "BitmapData" object, Starling supports any bitmap
 *  format that is supported by Flash. And since you can render any Flash display object into
 *  a BitmapData object, you can use this to display non-Starling content in Starling - e.g.
 *  Shape objects.</p>
 *  
 *  <p>Starling also supports ATF textures (Adobe Texture Format), which is a container for
 *  compressed texture formats that can be rendered very efficiently by the GPU. Refer to 
 *  the Flash documentation for more information about this format.</p>
 *  
 *  <strong>Mip Mapping</strong>
 *  
 *  <p>MipMaps are scaled down versions of a texture. When an image is displayed smaller than
 *  its natural size, the GPU may display the mip maps instead of the original texture. This
 *  reduces aliasing and accelerates rendering. It does, however, also need additional memory;
 *  for that reason, you can choose if you want to create them or not.</p>  
 *  
 *  <strong>Texture Frame</strong>
 *  
 *  <p>The frame property of a texture allows you let a texture appear inside the bounds of an
 *  image, leaving a transparent space around the texture. The frame rectangle is specified in 
 *  the coordinate system of the texture (not the image):</p>
 *  
 *  <listing>
 *  var frame:Rectangle = new Rectangle(-10, -10, 30, 30); 
 *  var texture:Texture = Texture.fromTexture(anotherTexture, null, frame);
 *  var image:Image = new Image(texture);</listing>
 *  
 *  <p>This code would create an image with a size of 30x30, with the texture placed at 
 *  <code>x=10, y=10</code> within that image (assuming that 'anotherTexture' has a width and 
 *  height of 10 pixels, it would appear in the middle of the image).</p>
 *  
 *  <p>The texture atlas makes use of this feature, as it allows to crop transparent edges
 *  of a texture and making up for the changed size by specifying the original texture frame.
 *  Tools like <a href="http://www.texturepacker.com/">TexturePacker</a> use this to  
 *  optimize the atlas.</p>
 * 
 *  <strong>Texture Coordinates</strong>
 *  
 *  <p>If, on the other hand, you want to show only a part of the texture in an image
 *  (i.e. to crop the the texture), you can either create a subtexture (with the method 
 *  'Texture.fromTexture()' and specifying a rectangle for the region), or you can manipulate 
 *  the texture coordinates of the image object. The method 'image.setTexCoords' allows you 
 *  to do that.</p>
 *  
 *  @see starling.display.Image
 *  @see TextureAtlas
 */ 
class Texture
{
	private var mFrame:Rectangle;
	private var mRepeat:Bool;
	
	/** helper object */
	private static var sOrigin:Point = new Point();
	
	/** @private */
	public function new()
	{
		if (Capabilities.isDebugger && 
			getQualifiedClassName(this) == "starling.textures::Texture")
		{
			throw new AbstractClassError();
		}
		
		mRepeat = false;
	}
	
	/** Disposes the underlying texture data. Note that not all textures need to be disposed: 
	 *  SubTextures (created with 'Texture.fromTexture') just reference other textures and
	 *  and do not take up resources themselves; this is also true for textures from an 
	 *  atlas. */
	public function dispose():Void
	{ 
		// override in subclasses
	}
	
	/** Creates a texture object from a bitmap.
	 *  Beware: you must not dispose 'data' if Starling should handle a lost device context. */
	public static function fromBitmap(data:Bitmap, generateMipMaps:Bool=true,
									  optimizeForRenderToTexture:Bool=false,
									  scale:Float=1):Texture
	{
		return fromBitmapData(data.bitmapData, generateMipMaps, optimizeForRenderToTexture, scale);
	}
	
	/** Creates a texture from bitmap data. 
	 *  Beware: you must not dispose 'data' if Starling should handle a lost device context. */
	public static function fromBitmapData(data:BitmapData, generateMipMaps:Bool=true,
										  optimizeForRenderToTexture:Bool=false,
										  scale:Float=1):Texture
	{
		var origWidth:Int   = data.width;
		var origHeight:Int  = data.height;
		var legalWidth:Int  = MathUtil.getNextPowerOfTwo(origWidth);
		var legalHeight:Int = MathUtil.getNextPowerOfTwo(origHeight);
		var context:Context3D = Starling.context;
		var potData:BitmapData;
		
		if (context == null) throw new MissingContextError();
		
		var nativeTexture:flash.display3D.textures.Texture = context.createTexture(
			legalWidth, legalHeight, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
		
		if (legalWidth > origWidth || legalHeight > origHeight)
		{
			potData = new BitmapData(legalWidth, legalHeight, true, 0);
			potData.copyPixels(data, data.rect, sOrigin);
			data = potData;
		}
		
		uploadBitmapData(nativeTexture, data, generateMipMaps);
		
		var concreteTexture:ConcreteTexture = new ConcreteTexture(
			nativeTexture, Context3DTextureFormat.BGRA, legalWidth, legalHeight,
			generateMipMaps, true, optimizeForRenderToTexture, scale);
		
		if (Starling.handleLostContext)
			concreteTexture.restoreOnLostContext(data);
		else if (potData)
			potData.dispose();
		
		if (origWidth == legalWidth && origHeight == legalHeight)
			return concreteTexture;
		else
			return new SubTexture(concreteTexture, 
								  new Rectangle(0, 0, origWidth/scale, origHeight/scale), 
								  true);
	}
	
	/** Creates a texture from the compressed ATF format. If you don't want to use any embedded
	 *  mipmaps, you can disable them by setting "useMipMaps" to <code>false</code>.
	 *  Beware: you must not dispose 'data' if Starling should handle a lost device context.
	 *  
	 *  <p>If you pass a function for the 'loadAsync' parameter, the method will return
	 *  immediately, while the texture will be created asynchronously. It can be used as soon
	 *  as the callback has been executed. This is the expected function definition:
	 *  <code>function(texture:Texture):void;</code></p> */ 
	public static function fromAtfData(data:ByteArray, scale:Float = 1, useMipMaps:Bool = true, 
									   loadAsync:Dynamic = null):Texture
	{
		var eventType:String = "textureReady"; // defined here for backwards compatibility
		
		var context:Context3D = Starling.context;
		if (context == null) throw new MissingContextError();
		
		var async:Bool = loadAsync != null;
		var atfData:AtfData = new AtfData(data);
		var nativeTexture:flash.display3D.textures.Texture = context.createTexture(
				atfData.width, atfData.height, atfData.format, false);
		
		uploadAtfData(nativeTexture, data, 0, async);
		
		var concreteTexture:ConcreteTexture = new ConcreteTexture(nativeTexture, atfData.format, 
			atfData.width, atfData.height, useMipMaps && atfData.numTextures > 1, 
			false, false, scale);
		
		if (Starling.handleLostContext) 
			concreteTexture.restoreOnLostContext(atfData);
		
		if (async)
			nativeTexture.addEventListener(eventType, onTextureReady);
		
		return concreteTexture;
		
		function onTextureReady(event:Event):Void
		{
			nativeTexture.removeEventListener(eventType, onTextureReady);
			if (loadAsync.length == 1) loadAsync(concreteTexture);
			else loadAsync();
		}
	}
	
	/** Creates a texture with a certain size and color.
	 *  
	 *  @param width:  in points; number of pixels depends on scale parameter
	 *  @param height: in points; number of pixels depends on scale parameter
	 *  @param color:  expected in ARGB format (inlude alpha!)
	 *  @param optimizeForRenderToTexture: indicates if this texture will be used as render target
	 *  @param scale:  if you omit this parameter, 'Starling.contentScaleFactor' will be used.
	 */
	public static function fromColor(width:Int, height:Int, color:UInt=0xffffffff,
									 optimizeForRenderToTexture:Bool=false, 
									 scale:Float=-1):Texture
	{
		if (scale <= 0) scale = Starling.contentScaleFactor;
		
		var bitmapData:BitmapData = new BitmapData(width*scale, height*scale, true, color);
		var texture:Texture = fromBitmapData(bitmapData, false, optimizeForRenderToTexture, scale);
		
		if (!Starling.handleLostContext)
			bitmapData.dispose();
		
		return texture;
	}
	
	/** Creates an empty texture of a certain size. Useful mainly for render textures. 
	 *  Beware that the texture can only be used after you either upload some color data or
	 *  clear the texture while it is an active render target. 
	 *  
	 *  @param width:  in points; number of pixels depends on scale parameter
	 *  @param height: in points; number of pixels depends on scale parameter
	 *  @param premultipliedAlpha: the PMA format you will use the texture with
	 *  @param optimizeForRenderToTexture: indicates if this texture will be used as render target
	 *  @param scale:  if you omit this parameter, 'Starling.contentScaleFactor' will be used.
	 */
	public static function empty(width:Int=64, height:Int=64, premultipliedAlpha:Bool=false,
								 optimizeForRenderToTexture:Bool=true,
								 scale:Float=-1):Texture
	{
		if (scale <= 0) scale = Starling.contentScaleFactor;
		
		var origWidth:Int  = width * scale;
		var origHeight:Int = height * scale;
		var legalWidth:Int  = MathUtil.getNextPowerOfTwo(origWidth);
		var legalHeight:Int = MathUtil.getNextPowerOfTwo(origHeight);
		var format:String = Context3DTextureFormat.BGRA;
		var context:Context3D = Starling.context;
		
		if (context == null) throw new MissingContextError();
		
		var nativeTexture:flash.display3D.textures.Texture = context.createTexture(
			legalWidth, legalHeight, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
		
		var concreteTexture:ConcreteTexture = new ConcreteTexture(nativeTexture, format,
			legalWidth, legalHeight, false, premultipliedAlpha, optimizeForRenderToTexture, scale);
		
		if (origWidth == legalWidth && origHeight == legalHeight)
			return concreteTexture;
		else
			return new SubTexture(concreteTexture, new Rectangle(0, 0, width, height), true);
	}
	
	/** Creates a texture that contains a region (in pixels) of another texture. The new
	 *  texture will reference the base texture; no data is duplicated. */
	public static function fromTexture(texture:Texture, region:Rectangle=null, frame:Rectangle=null):Texture
	{
		var subTexture:Texture = new SubTexture(texture, region);   
		subTexture.mFrame = frame;
		return subTexture;
	}
	
	/** Converts texture coordinates and vertex positions of raw vertex data into the format 
	 *  required for rendering. */
	public function adjustVertexData(vertexData:VertexData, vertexID:Int, count:Int):Void
	{
		if (mFrame)
		{
			if (count != 4) 
				throw new ArgumentError("Textures with a frame can only be used on quads");
			
			var deltaRight:Float  = mFrame.width  + mFrame.x - width;
			var deltaBottom:Float = mFrame.height + mFrame.y - height;
			
			vertexData.translateVertex(vertexID,     -mFrame.x, -mFrame.y);
			vertexData.translateVertex(vertexID + 1, -deltaRight, -mFrame.y);
			vertexData.translateVertex(vertexID + 2, -mFrame.x, -deltaBottom);
			vertexData.translateVertex(vertexID + 3, -deltaRight, -deltaBottom);
		}
	}
	
	/** @private Uploads the bitmap data to the native texture, optionally creating mipmaps. */
	public static function uploadBitmapData(nativeTexture:flash.display3D.textures.Texture,
											  data:BitmapData, generateMipmaps:Bool):Void
	{
		nativeTexture.uploadFromBitmapData(data);
		
		if (generateMipmaps && data.width > 1 && data.height > 1)
		{
			var currentWidth:Int  = data.width  >> 1;
			var currentHeight:Int = data.height >> 1;
			var level:Int = 1;
			var canvas:BitmapData = new BitmapData(currentWidth, currentHeight, true, 0);
			var transform:Matrix = new Matrix(.5, 0, 0, .5);
			var bounds:Rectangle = new Rectangle();
			
			while (currentWidth >= 1 || currentHeight >= 1)
			{
				bounds.width = currentWidth; bounds.height = currentHeight;
				canvas.fillRect(bounds, 0);
				canvas.draw(data, transform, null, null, null, true);
				nativeTexture.uploadFromBitmapData(canvas, level++);
				transform.scale(0.5, 0.5);
				currentWidth  = currentWidth  >> 1;
				currentHeight = currentHeight >> 1;
			}
			
			canvas.dispose();
		}
	}
	
	/** @private Uploads ATF data from a ByteArray to a native texture. */
	public static function uploadAtfData(nativeTexture:flash.display3D.textures.Texture, 
										   data:ByteArray, offset:Int=0, 
										   async:Bool=false):Void
	{
		nativeTexture.uploadCompressedTextureFromByteArray(data, offset, async);
	}
	
	// properties
	public var frame(get, null):Rectangle;
	public var repeat(get, set):Bool;
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var nativeWidth(get, null):Float;
	public var nativeHeight(get, null):Float;
	public var scale(get, null):Float;
	public var base(get, null):TextureBase;
	public var root(get, null):ConcreteTexture;
	public var format(get, null):String;
	public var mipMapping(get, null):Bool;
	public var premultipliedAlpha(get, null):Bool;
	
	/** The texture frame (see class description). */
	private function get_frame():Rectangle 
	{ 
		return mFrame ? mFrame.clone() : new Rectangle(0, 0, width, height);
		
		// the frame property is readonly - set the frame in the 'fromTexture' method.
		// why is it readonly? To be able to efficiently cache the texture coordinates on
		// rendering, textures need to be immutable (except 'repeat', which is not cached,
		// anyway).
	}
	
	/** Indicates if the texture should repeat like a wallpaper or stretch the outermost pixels.
	 *  Note: this only works in textures with sidelengths that are powers of two and 
	 *  that are not loaded from a texture atlas (i.e. no subtextures). @default false */
	private function get_repeat():Bool 
	{ 
		return mRepeat; 
	}
	private function set_repeat(value:Bool):Bool 
	{ 
		return mRepeat = value; 
	}
	
	/** The width of the texture in points. */
	private function get_width():Float 
	{ 
		return 0; 
	}
	
	/** The height of the texture in points. */
	private function get_height():Float 
	{ 
		return 0; 
	}

	/** The width of the texture in pixels (without scale adjustment). */
	private function get_nativeWidth():Float 
	{ 
		return 0; 
	}
	
	/** The height of the texture in pixels (without scale adjustment). */
	private function get_nativeHeight():Float 
	{ 
		return 0; 
	}
	
	/** The scale factor, which influences width and height properties. */
	private function get_scale():Float 
	{ 
		return 1.0;
	}
	
	/** The Stage3D texture object the texture is based on. */
	private function get_base():TextureBase 
	{ 
		return null; 
	}
	
	/** The concrete (power-of-two) texture the texture is based on. */
	private function get_root():ConcreteTexture 
	{ 
		return null; 
	}
	
	/** The <code>Context3DTextureFormat</code> of the underlying texture data. */
	private function get_format():String 
	{ 
		return Context3DTextureFormat.BGRA; 
	}
	
	/** Indicates if the texture contains mip maps. */ 
	private function get_mipMapping():Bool 
	{ 
		return false; 
	}
	
	/** Indicates if the alpha values are premultiplied into the RGB values. */
	private function get_premultipliedAlpha():Bool 
	{ 
		return false; 
	}
}