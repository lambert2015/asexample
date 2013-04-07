// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;

import flash.display.BitmapData;
import flash.display.StageQuality;
import flash.filters.BitmapFilter;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Dictionary;
import haxe.ds.StringMap;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.display.QuadBatch;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.HAlign;
import starling.utils.VAlign;

/** A TextField displays text, either using standard true type fonts or custom bitmap fonts.
 *  
 *  <p>You can set all properties you are used to, like the font name and size, a color, the 
 *  horizontal and vertical alignment, etc. The border property is helpful during development, 
 *  because it lets you see the bounds of the textfield.</p>
 *  
 *  <p>There are two types of fonts that can be displayed:</p>
 *  
 *  <ul>
 *    <li>Standard true type fonts. This renders the text just like a conventional Flash
 *        TextField. It is recommended to embed the font, since you cannot be sure which fonts
 *        are available on the client system, and since this enhances rendering quality. 
 *        Simply pass the font name to the corresponding property.</li>
 *    <li>Bitmap fonts. If you need speed or fancy font effects, use a bitmap font instead. 
 *        That is a font that has its glyphs rendered to a texture atlas. To use it, first 
 *        register the font with the method <code>registerBitmapFont</code>, and then pass 
 *        the font name to the corresponding property of the text field.</li>
 *  </ul> 
 *    
 *  For bitmap fonts, we recommend one of the following tools:
 * 
 *  <ul>
 *    <li>Windows: <a href="http://www.angelcode.com/products/bmfont">Bitmap Font Generator</a>
 *       from Angel Code (free). Export the font data as an XML file and the texture as a png 
 *       with white characters on a transparent background (32 bit).</li>
 *    <li>Mac OS: <a href="http://glyphdesigner.71squared.com">Glyph Designer</a> from 
 *        71squared or <a href="http://http://www.bmglyph.com">bmGlyph</a> (both commercial). 
 *        They support Starling natively.</li>
 *  </ul> 
 */
class TextField extends DisplayObjectContainer
{
	// the name container with the registered bitmap fonts
	private static inline var BITMAP_FONT_DATA_NAME:String = "starling.display.TextField.BitmapFonts";
	
	private var mFontSize:Float;
	private var mColor:UInt;
	private var mText:String;
	private var mFontName:String;
	private var mHAlign:String;
	private var mVAlign:String;
	private var mBold:Bool;
	private var mItalic:Bool;
	private var mUnderline:Bool;
	private var mAutoScale:Bool;
	private var mKerning:Bool;
	private var mNativeFilters:Array<BitmapFilter> ;
	private var mRequiresRedraw:Bool;
	private var mIsRenderedText:Bool;
	private var mTextBounds:Rectangle;
	
	private var mHitArea:DisplayObject;
	private var mBorder:DisplayObjectContainer;
	
	private var mImage:Image;
	private var mQuadBatch:QuadBatch;
	
	// this object will be used for text rendering
	private static var sNativeTextField:flash.text.TextField = new flash.text.TextField();
	
	/** Create a new text field with the given properties. */
	public function new(width:Int, height:Int, text:String, fontName:String="Verdana",
							  fontSize:Float=12, color:UInt=0x0, bold:Bool=false)
	{
		mText = text ? text : "";
		mFontSize = fontSize;
		mColor = color;
		mHAlign = HAlign.CENTER;
		mVAlign = VAlign.CENTER;
		mBorder = null;
		mKerning = true;
		mBold = bold;
		this.fontName = fontName;
		
		mHitArea = new Quad(width, height);
		mHitArea.alpha = 0.0;
		addChild(mHitArea);
		
		addEventListener(Event.FLATTEN, onFlatten);
	}
	
	/** Disposes the underlying texture data. */
	public override function dispose():Void
	{
		removeEventListener(Event.FLATTEN, onFlatten);
		if (mImage) 
			mImage.texture.dispose();
		if (mQuadBatch)
			mQuadBatch.dispose();
		super.dispose();
	}
	
	private function onFlatten():Void
	{
		if (mRequiresRedraw) 
			redrawContents();
	}
	
	/** @inheritDoc */
	public override function render(support:RenderSupport, parentAlpha:Float):Void
	{
		if (mRequiresRedraw) 
			redrawContents();
		super.render(support, parentAlpha);
	}
	
	private function redrawContents():Void
	{
		if (mIsRenderedText) 
			createRenderedContents();
		else                 
			createComposedContents();
		
		mRequiresRedraw = false;
	}
	
	private function createRenderedContents():Void
	{
		if (mQuadBatch)
		{ 
			mQuadBatch.removeFromParent(true); 
			mQuadBatch = null; 
		}
		
		var scale:Float  = Starling.contentScaleFactor;
		var width:Float  = mHitArea.width  * scale;
		var height:Float = mHitArea.height * scale;
		
		var textFormat:TextFormat = new TextFormat(mFontName, 
			mFontSize * scale, mColor, mBold, mItalic, mUnderline, null, null, mHAlign);
		textFormat.kerning = mKerning;
		
		sNativeTextField.defaultTextFormat = textFormat;
		sNativeTextField.width = width;
		sNativeTextField.height = height;
		sNativeTextField.antiAliasType = AntiAliasType.ADVANCED;
		sNativeTextField.selectable = false;            
		sNativeTextField.multiline = true;            
		sNativeTextField.wordWrap = true;            
		sNativeTextField.text = mText;
		sNativeTextField.embedFonts = true;
		sNativeTextField.filters = mNativeFilters;
		
		// we try embedded fonts first, non-embedded fonts are just a fallback
		if (sNativeTextField.textWidth == 0.0 || sNativeTextField.textHeight == 0.0)
			sNativeTextField.embedFonts = false;
		
		formatText(sNativeTextField, textFormat);
		
		if (mAutoScale)
			autoScaleNativeTextField(sNativeTextField);
		
		var textWidth:Float  = sNativeTextField.textWidth;
		var textHeight:Float = sNativeTextField.textHeight;
		
		var xOffset:Float = 0.0;
		if (mHAlign == HAlign.LEFT)       
			xOffset = 2; // flash adds a 2 pixel offset
		else if (mHAlign == HAlign.CENTER) 
			xOffset = (width - textWidth) / 2.0;
		else if (mHAlign == HAlign.RIGHT) 
			xOffset =  width - textWidth - 2;

		var yOffset:Float = 0.0;
		if (mVAlign == VAlign.TOP)         
			yOffset = 2; // flash adds a 2 pixel offset
		else if (mVAlign == VAlign.CENTER) 
			yOffset = (height - textHeight) / 2.0;
		else if (mVAlign == VAlign.BOTTOM) 
			yOffset =  height - textHeight - 2;
		
		var bitmapData:BitmapData = new BitmapData(width, height, true, 0x0);
		var drawMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, int(yOffset)-2); 
		var drawWithQualityFunc:Dynamic = 
				untyped bitmapData.hasOwnProperty("drawWithQuality") ? bitmapData["drawWithQuality"] : null;
		
		// Beginning with AIR 3.3, we can force a drawing quality. Since "LOW" produces
		// wrong output oftentimes, we force "MEDIUM" if possible.
		
		if (drawWithQualityFunc != null)
			untyped drawWithQualityFunc(bitmapData, sNativeTextField, drawMatrix, 
									 null, null, null, false, StageQuality.MEDIUM);
		else
			bitmapData.draw(sNativeTextField, drawMatrix);
		
		sNativeTextField.text = "";
		
		// update textBounds rectangle
		if (mTextBounds == null) mTextBounds = new Rectangle();
		mTextBounds.setTo(xOffset   / scale, yOffset    / scale,
						  textWidth / scale, textHeight / scale);
		
		var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, scale);
		
		if (mImage == null) 
		{
			mImage = new Image(texture);
			mImage.touchable = false;
			addChild(mImage);
		}
		else 
		{ 
			mImage.texture.dispose();
			mImage.texture = texture; 
			mImage.readjustSize(); 
		}
	}

	/** formatText is called immediately before the text is rendered. The intent of formatText
	 *  is to be overridden in a subclass, so that you can provide custom formatting for TextField.
	 *  <code>textField</code> is the flash.text.TextField object that you can specially format;
	 *  <code>textFormat</code> is the default TextFormat for <code>textField</code>.
	 */
	private function formatText(textField:flash.text.TextField, textFormat:TextFormat):Void 
	{
	}

	private function autoScaleNativeTextField(textField:flash.text.TextField):Void
	{
		var size:Float   = Float(textField.defaultTextFormat.size);
		var maxHeight:Int = textField.height - 4;
		var maxWidth:Int  = textField.width - 4;
		
		while (textField.textWidth > maxWidth || textField.textHeight > maxHeight)
		{
			if (size <= 4) break;
			
			var format:TextFormat = textField.defaultTextFormat;
			format.size = size--;
			textField.setTextFormat(format);
		}
	}
	
	private function createComposedContents():Void
	{
		if (mImage) 
		{ 
			mImage.removeFromParent(true); 
			mImage = null; 
		}
		
		if (mQuadBatch == null) 
		{ 
			mQuadBatch = new QuadBatch(); 
			mQuadBatch.touchable = false;
			addChild(mQuadBatch); 
		}
		else
			mQuadBatch.reset();
		
		var bitmapFont:BitmapFont = bitmapFonts[mFontName];
		if (bitmapFont == null) throw new Error("Bitmap font not registered: " + mFontName);
		
		bitmapFont.fillQuadBatch(mQuadBatch,
			mHitArea.width, mHitArea.height, mText, mFontSize, mColor, mHAlign, mVAlign,
			mAutoScale, mKerning);
		
		mTextBounds = null; // will be created on demand
	}
	
	private function updateBorder():Void
	{
		if (mBorder == null) return;
		
		var width:Float  = mHitArea.width;
		var height:Float = mHitArea.height;
		
		var topLine:Quad    = cast(mBorder.getChildAt(0), Quad);
		var rightLine:Quad  = cast(mBorder.getChildAt(1), Quad);
		var bottomLine:Quad = cast(mBorder.getChildAt(2), Quad);
		var leftLine:Quad   = cast(mBorder.getChildAt(3), Quad);
		
		topLine.width    = width; topLine.height    = 1;
		bottomLine.width = width; bottomLine.height = 1;
		leftLine.width   = 1;     leftLine.height   = height;
		rightLine.width  = 1;     rightLine.height  = height;
		rightLine.x  = width  - 1;
		bottomLine.y = height - 1;
		topLine.color = rightLine.color = bottomLine.color = leftLine.color = mColor;
	}
	
	/** Returns the bounds of the text within the text field. */
	private function get_textBounds():Rectangle
	{
		if (mRequiresRedraw) redrawContents();
		if (mTextBounds == null) mTextBounds = mQuadBatch.getBounds(mQuadBatch);
		return mTextBounds.clone();
	}
	
	/** @inheritDoc */
	public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
	{
		return mHitArea.getBounds(targetSpace, resultRect);
	}
	
	/** @inheritDoc */
	private override function set_width(value:Float):Void
	{
		// different to ordinary display objects, changing the size of the text field should 
		// not change the scaling, but make the texture bigger/smaller, while the size 
		// of the text/font stays the same (this applies to the height, as well).
		
		mHitArea.width = value;
		mRequiresRedraw = true;
		updateBorder();
	}
	
	/** @inheritDoc */
	private override function set_height(value:Float):Float
	{
		mHitArea.height = value;
		mRequiresRedraw = true;
		updateBorder();
	}
	
	/** The displayed text. */
	private function get_text():String 
	{ 
		return mText; 
	}
	private function set_text(value:String):String
	{
		if (value == null) 
			value = "";
			
		if (mText != value)
		{
			mText = value;
			mRequiresRedraw = true;
		}
		return mText; 
	}
	
	/** The name of the font (true type or bitmap font). */
	private function get_fontName():String 
	{ 
		return mFontName; 
	}
	private function set_fontName(value:String):String
	{
		if (mFontName != value)
		{
			if (value == BitmapFont.MINI && bitmapFonts[value] == undefined)
				registerBitmapFont(new BitmapFont());
			
			mFontName = value;
			mRequiresRedraw = true;
			mIsRenderedText = bitmapFonts[value] == undefined;
		}
		return mFontName; 
	}
	
	/** The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for 
	 *  the original size. */
	private function get_fontSize():Float 
	{ 
		return mFontSize; 
	}
	private function set_fontSize(value:Float):Float
	{
		if (mFontSize != value)
		{
			mFontSize = value;
			mRequiresRedraw = true;
		}
		return mFontSize; 
	}
	
	/** The color of the text. For bitmap fonts, use <code>Color.WHITE</code> to use the
	 *  original, untinted color. @default black */
	private function get_color():UInt 
	{
		return mColor; 
	}
	private function set_color(value:UInt):UInt
	{
		if (mColor != value)
		{
			mColor = value;
			updateBorder();
			mRequiresRedraw = true;
		}
		return mColor;
	}
	
	/** The horizontal alignment of the text. @default center @see starling.utils.HAlign */
	private function get_hAlign():String 
	{ 
		return mHAlign; 
	}
	private function set_hAlign(value:String):String
	{
		#if debug
		if (!HAlign.isValid(value))
			throw new ArgumentError("Invalid horizontal align: " + value);
		#end
		
		if (mHAlign != value)
		{
			mHAlign = value;
			mRequiresRedraw = true;
		}
		return mHAlign; 
	}
	
	/** The vertical alignment of the text. @default center @see starling.utils.VAlign */
	private function get_vAlign():String 
	{
		return mVAlign; 
	}
	private function set_vAlign(value:String):String
	{
		#if debug
		if (!VAlign.isValid(value))
			throw new ArgumentError("Invalid vertical align: " + value);
		#end
		
		if (mVAlign != value)
		{
			mVAlign = value;
			mRequiresRedraw = true;
		}
		return mVAlign;
	}
	
	/** Draws a border around the edges of the text field. Useful for visual debugging. 
	 *  @default false */
	private function get_border():Bool 
	{ 
		return mBorder != null; 
	}
	private function set_border(value:Bool):Bool
	{
		if (value && mBorder == null)
		{                
			mBorder = new Sprite();
			addChild(mBorder);
			
			for (i in 0...4)
				mBorder.addChild(new Quad(1.0, 1.0));
			
			updateBorder();
		}
		else if (!value && mBorder != null)
		{
			mBorder.removeFromParent(true);
			mBorder = null;
		}
		return border;
	}
	
	/** Indicates whether the text is bold. @default false */
	private function get_bold():Bool 
	{ 
		return mBold; 
	}
	private function set_bold(value:Bool):Bool 
	{
		if (mBold != value)
		{
			mBold = value;
			mRequiresRedraw = true;
		}
		return mBold; 
	}
	
	/** Indicates whether the text is italicized. @default false */
	private function get_italic():Bool 
	{ 
		return mItalic; 
	}
	private function set_italic(value:Bool):Bool
	{
		if (mItalic != value)
		{
			mItalic = value;
			mRequiresRedraw = true;
		}
		return mItalic;
	}
	
	/** Indicates whether the text is underlined. @default false */
	private function get_underline():Bool 
	{ 
		return mUnderline; 
	}
	private function set_underline(value:Bool):Bool
	{
		if (mUnderline != value)
		{
			mUnderline = value;
			mRequiresRedraw = true;
		}
		return mUnderline;
	}
	
	/** Indicates whether kerning is enabled. @default true */
	private function get_kerning():Bool 
	{ 
		return mKerning; 
	}
	private function set_kerning(value:Bool):Bool
	{
		if (mKerning != value)
		{
			mKerning = value;
			mRequiresRedraw = true;
		}
		return mKerning;
	}
	
	/** Indicates whether the font size is scaled down so that the complete text fits
	 *  into the text field. @default false */
	private function get_autoScale():Bool 
	{ 
		return mAutoScale; 
	}
	private function set_autoScale(value:Bool):Bool
	{
		if (mAutoScale != value)
		{
			mAutoScale = value;
			mRequiresRedraw = true;
		}
		return mAutoScale;
	}

	/** The native Flash BitmapFilters to apply to this TextField. 
	 *  Only available when using standard (TrueType) fonts! */
	private function get_nativeFilters():Array<BitmapFilter> 
	{ 
		return mNativeFilters; 
	}
	private function set_nativeFilters(value:Array<BitmapFilter>) : Array<BitmapFilter> 
	{
		if (!mIsRenderedText)
			throw(new Error("The TextField.nativeFilters property cannot be used on Bitmap fonts."));
		
		mNativeFilters = value.concat();
		mRequiresRedraw = true;
		
		return mNativeFilters;
	}
	
	/** Makes a bitmap font available at any TextField in the current stage3D context.
	 *  The font is identified by its <code>name</code>.
	 *  Per default, the <code>name</code> property of the bitmap font will be used, but you 
	 *  can pass a custom name, as well. @returns the name of the font. */
	public static function registerBitmapFont(bitmapFont:BitmapFont, name:String = null):String
	{
		if (name == null) 
			name = bitmapFont.name;
		bitmapFonts.set(name, bitmapFont);
		return name;
	}
	
	/** Unregisters the bitmap font and, optionally, disposes it. */
	public static function unregisterBitmapFont(name:String, dispose:Bool = true):Void
	{
		if (dispose && bitmapFonts.exist(name))
			bitmapFonts.get(name).dispose();
		
		bitmapFonts.delete(name);
	}
	
	/** Returns a registered bitmap font (or null, if the font has not been registered). */
	public static function getBitmapFont(name:String):BitmapFont
	{
		return bitmapFonts.get(name);
	}
	
	public static var bitmapFonts(get,null):StringMap<BitmapFont>;
	/** Stores the currently available bitmap fonts. Since a bitmap font will only work
	 *  in one Stage3D context, they are saved in Starling's 'contextData' property. */
	private static function get_bitmapFonts():StringMap<BitmapFont>
	{
		var fonts:StringMap<BitmapFont> = Starling.current.contextData.get(BITMAP_FONT_DATA_NAME);
		
		if (fonts == null)
		{
			fonts = new StringMap<BitmapFont>();
			Starling.current.contextData.set(BITMAP_FONT_DATA_NAME,fonts);
		}
		
		return fonts;
	}
}