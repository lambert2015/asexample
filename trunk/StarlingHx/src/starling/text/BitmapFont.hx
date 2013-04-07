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

import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.Vector;
import flash.xml.XML;

import starling.display.Image;
import starling.display.QuadBatch;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.HAlign;
import starling.utils.VAlign;

/** The BitmapFont class parses bitmap font files and arranges the glyphs 
 *  in the form of a text.
 *
 *  The class parses the XML format as it is used in the 
 *  <a href="http://www.angelcode.com/products/bmfont/">AngelCode Bitmap Font Generator</a> or
 *  the <a href="http://glyphdesigner.71squared.com/">Glyph Designer</a>. 
 *  This is what the file format looks like:
 *
 *  <pre> 
 *  &lt;font&gt;
 *    &lt;info face="BranchingMouse" size="40" /&gt;
 *    &lt;common lineHeight="40" /&gt;
 *    &lt;pages&gt;  &lt;!-- currently, only one page is supported --&gt;
 *      &lt;page id="0" file="texture.png" /&gt;
 *    &lt;/pages&gt;
 *    &lt;chars&gt;
 *      &lt;char id="32" x="60" y="29" width="1" height="1" xoffset="0" yoffset="27" xadvance="8" /&gt;
 *      &lt;char id="33" x="155" y="144" width="9" height="21" xoffset="0" yoffset="6" xadvance="9" /&gt;
 *    &lt;/chars&gt;
 *    &lt;kernings&gt; &lt;!-- Kerning is optional --&gt;
 *      &lt;kerning first="83" second="83" amount="-4"/&gt;
 *    &lt;/kernings&gt;
 *  &lt;/font&gt;
 *  </pre>
 *  
 *  Pass an instance of this class to the method <code>registerBitmapFont</code> of the
 *  TextField class. Then, set the <code>fontName</code> property of the text field to the 
 *  <code>name</code> value of the bitmap font. This will make the text field use the bitmap
 *  font.  
 */ 
class BitmapFont
{
	/** Use this constant for the <code>fontSize</code> property of the TextField class to 
	 *  render the bitmap font in exactly the size it was created. */ 
	public static inline var NATIVE_SIZE:Int = -1;
	
	/** The font name of the embedded minimal bitmap font. Use this e.g. for debug output. */
	public static inline var MINI:String = "mini";
	
	private static inline var CHAR_SPACE:Int           = 32;
	private static inline var CHAR_TAB:Int             =  9;
	private static inline var CHAR_NEWLINE:Int         = 10;
	private static inline var CHAR_CARRIAGE_RETURN:Int = 13;
	
	private var mTexture:Texture;
	private var mChars:Dictionary;
	private var mName:String;
	private var mSize:Float;
	private var mLineHeight:Float;
	private var mBaseline:Float;
	private var mHelperImage:Image;
	private var mCharLocationPool:Vector<CharLocation>;
	
	/** Creates a bitmap font by parsing an XML file and uses the specified texture. 
	 *  If you don't pass any data, the "mini" font will be created. */
	public function new(texture:Texture=null, fontXml:XML=null)
	{
		// if no texture is passed in, we create the minimal, embedded font
		if (texture == null && fontXml == null)
		{
			texture = MiniBitmapFont.texture;
			fontXml = MiniBitmapFont.xml;
		}
		
		mName = "unknown";
		mLineHeight = mSize = mBaseline = 14;
		mTexture = texture;
		mChars = new Dictionary();
		mHelperImage = new Image(texture);
		mCharLocationPool = new Vector<CharLocation>();
		
		if (fontXml) parseFontXml(fontXml);
	}
	
	/** Disposes the texture of the bitmap font! */
	public function dispose():Void
	{
		if (mTexture)
			mTexture.dispose();
	}
	
	private function parseFontXml(fontXml:XML):Void
	{
		var scale:Float = mTexture.scale;
		var frame:Rectangle = mTexture.frame;
		
		mName = fontXml.info.attribute("face");
		mSize = Std.parseFloat(fontXml.info.attribute("size")) / scale;
		mLineHeight = Std.parseFloat(fontXml.common.attribute("lineHeight")) / scale;
		mBaseline = Std.parseFloat(fontXml.common.attribute("base")) / scale;
		
		if (fontXml.info.attribute("smooth").toString() == "0")
			smoothing = TextureSmoothing.NONE;
		
		if (mSize <= 0)
		{
			trace("[Starling] Warning: invalid font size in '" + mName + "' font.");
			mSize = (mSize == 0.0 ? 16.0 : mSize * -1.0);
		}
		
		for (charElement in fontXml.chars.char)
		{
			var id:Int = Std.parseInt(charElement.attribute("id"));
			var xOffset:Float = Std.parseFloat(charElement.attribute("xoffset")) / scale;
			var yOffset:Float = Std.parseFloat(charElement.attribute("yoffset")) / scale;
			var xAdvance:Float = Std.parseFloat(charElement.attribute("xadvance")) / scale;
			
			var region:Rectangle = new Rectangle();
			region.x = Std.parseFloat(charElement.attribute("x")) / scale + frame.x;
			region.y = Std.parseFloat(charElement.attribute("y")) / scale + frame.y;
			region.width  = Std.parseFloat(charElement.attribute("width")) / scale;
			region.height = Std.parseFloat(charElement.attribute("height")) / scale;
			
			var texture:Texture = Texture.fromTexture(mTexture, region);
			var bitmapChar:BitmapChar = new BitmapChar(id, texture, xOffset, yOffset, xAdvance); 
			addChar(id, bitmapChar);
		}
		
		for (kerningElement in fontXml.kernings.kerning)
		{
			var first:Int = Std.parseInt(kerningElement.attribute("first"));
			var second:Int = Std.parseInt(kerningElement.attribute("second"));
			var amount:Float = Std.parseFloat(kerningElement.attribute("amount")) / scale;
			if (second in mChars) getChar(second).addKerning(first, amount);
		}
	}
	
	/** Returns a single bitmap char with a certain character ID. */
	public function getChar(charID:Int):BitmapChar
	{
		return mChars[charID];   
	}
	
	/** Adds a bitmap char with a certain character ID. */
	public function addChar(charID:Int, bitmapChar:BitmapChar):Void
	{
		mChars[charID] = bitmapChar;
	}
	
	/** Creates a sprite that contains a certain text, made up by one image per char. */
	public function createSprite(width:Float, height:Float, text:String,
								 fontSize:Float=-1, color:UInt=0xffffff, 
								 hAlign:String="center", vAlign:String="center",      
								 autoScale:Bool=true, 
								 kerning:Bool=true):Sprite
	{
		var charLocations:Vector<CharLocation> = arrangeChars(width, height, text, fontSize, 
															   hAlign, vAlign, autoScale, kerning);
		var numChars:Int = charLocations.length;
		var sprite:Sprite = new Sprite();
		
		for (i in 0...numChars)
		{
			var charLocation:CharLocation = charLocations[i];
			var char:Image = charLocation.char.createImage();
			char.x = charLocation.x;
			char.y = charLocation.y;
			char.scaleX = char.scaleY = charLocation.scale;
			char.color = color;
			sprite.addChild(char);
		}
		
		return sprite;
	}
	
	/** Draws text into a QuadBatch. */
	public function fillQuadBatch(quadBatch:QuadBatch, width:Float, height:Float, text:String,
								  fontSize:Float=-1, color:UInt=0xffffff, 
								  hAlign:String="center", vAlign:String="center",      
								  autoScale:Bool=true, 
								  kerning:Bool=true):Void
	{
		var charLocations:Vector<CharLocation> = arrangeChars(width, height, text, fontSize, 
															   hAlign, vAlign, autoScale, kerning);
		var numChars:Int = charLocations.length;
		mHelperImage.color = color;
		
		if (numChars > 8192)
			throw new ArgumentError("Bitmap Font text is limited to 8192 characters.");

		for (i in 0...numChars)
		{
			var charLocation:CharLocation = charLocations[i];
			mHelperImage.texture = charLocation.char.texture;
			mHelperImage.readjustSize();
			mHelperImage.x = charLocation.x;
			mHelperImage.y = charLocation.y;
			mHelperImage.scaleX = mHelperImage.scaleY = charLocation.scale;
			quadBatch.addImage(mHelperImage);
		}
	}
	
	/** Arranges the characters of a text inside a rectangle, adhering to the given settings. 
	 *  Returns a Vector of CharLocations. */
	private function arrangeChars(width:Float, height:Float, text:String, fontSize:Float = -1,
								  hAlign:String = "center", vAlign:String = "center",
								  autoScale:Bool = true, kerning:Bool = true):Vector<CharLocation>
	{
		if (text == null || text.length == 0) 
			return new Vector<CharLocation>();
			
		if (fontSize < 0) 
			fontSize *= -mSize;
		
		var lines:Vector<Vector<CharLocation>>;
		var finished:Bool = false;
		var charLocation:CharLocation;
		var numChars:Int;
		var containerWidth:Float;
		var containerHeight:Float;
		var scale:Float;
		
		while (!finished)
		{
			scale = fontSize / mSize;
			containerWidth  = width / scale;
			containerHeight = height / scale;
			
			lines = new Vector<Vector<CharLocation>>();
			
			if (mLineHeight <= containerHeight)
			{
				var lastWhiteSpace:Int = -1;
				var lastCharID:Int = -1;
				var currentX:Float = 0;
				var currentY:Float = 0;
				var currentLine:Vector<CharLocation> = new Vector<CharLocation>();
				
				numChars = text.length;
				for (i in 0...numChars)
				{
					var lineFull:Bool = false;
					var charID:Int = text.charCodeAt(i);
					var char:BitmapChar = getChar(charID);
					
					if (charID == CHAR_NEWLINE || charID == CHAR_CARRIAGE_RETURN)
					{
						lineFull = true;
					}
					else if (char == null)
					{
						trace("[Starling] Missing character: " + charID);
					}
					else
					{
						if (charID == CHAR_SPACE || charID == CHAR_TAB)
							lastWhiteSpace = i;
						
						if (kerning)
							currentX += char.getKerning(lastCharID);
						
						charLocation = mCharLocationPool.length ?
							mCharLocationPool.pop() : new CharLocation(char);
						
						charLocation.char = char;
						charLocation.x = currentX + char.xOffset;
						charLocation.y = currentY + char.yOffset;
						currentLine.push(charLocation);
						
						currentX += char.xAdvance;
						lastCharID = charID;
						
						if (charLocation.x + char.width > containerWidth)
						{
							// remove characters and add them again to next line
							var numCharsToRemove:Int = lastWhiteSpace == -1 ? 1 : i - lastWhiteSpace;
							var removeIndex:Int = currentLine.length - numCharsToRemove;
							
							currentLine.splice(removeIndex, numCharsToRemove);
							
							if (currentLine.length == 0)
								break;
							
							i -= numCharsToRemove;
							lineFull = true;
						}
					}
					
					if (i == numChars - 1)
					{
						lines.push(currentLine);
						finished = true;
					}
					else if (lineFull)
					{
						lines.push(currentLine);
						
						if (lastWhiteSpace == i)
							currentLine.pop();
						
						if (currentY + 2*mLineHeight <= containerHeight)
						{
							currentLine = new Vector<CharLocation>();
							currentX = 0;
							currentY += mLineHeight;
							lastWhiteSpace = -1;
							lastCharID = -1;
						}
						else
						{
							break;
						}
					}
				} // for each char
			} // if (mLineHeight <= containerHeight)
			
			if (autoScale && !finished)
			{
				fontSize -= 1;
				lines.length = 0;
			}
			else
			{
				finished = true; 
			}
		} // while (!finished)
		
		var finalLocations:Vector<CharLocation> = new Vector<CharLocation>();
		var numLines:Int = lines.length;
		var bottom:Float = currentY + mLineHeight;
		var yOffset:Int = 0;
		
		if (vAlign == VAlign.BOTTOM)      yOffset =  containerHeight - bottom;
		else if (vAlign == VAlign.CENTER) yOffset = (containerHeight - bottom) / 2;
		
		for (lineID in 0...numLines)
		{
			var line:Vector<CharLocation> = lines[lineID];
			numChars = line.length;
			
			if (numChars == 0) continue;
			
			var xOffset:Int = 0;
			var lastLocation:CharLocation = line[line.length-1];
			var right:Float = lastLocation.x - lastLocation.char.xOffset 
											  + lastLocation.char.xAdvance;
			
			if (hAlign == HAlign.RIGHT)       xOffset =  containerWidth - right;
			else if (hAlign == HAlign.CENTER) xOffset = (containerWidth - right) / 2;
			
			for (c in 0...numChars)
			{
				charLocation = line[c];
				charLocation.x = scale * (charLocation.x + xOffset);
				charLocation.y = scale * (charLocation.y + yOffset);
				charLocation.scale = scale;
				
				if (charLocation.char.width > 0 && charLocation.char.height > 0)
					finalLocations.push(charLocation);
				
				// return to pool for next call to "arrangeChars"
				mCharLocationPool.push(charLocation);
			}
		}
		
		return finalLocations;
	}
	
	/** The name of the font as it was parsed from the font file. */
	private function get_name():String { return mName; }
	
	/** The native size of the font. */
	private function get_size():Float { return mSize; }
	
	/** The height of one line in pixels. */
	private function get_lineHeight():Float { return mLineHeight; }
	private function set_lineHeight(value:Float):Float { return mLineHeight = value; }
	
	/** The smoothing filter that is used for the texture. */ 
	private function get_smoothing():String { return mHelperImage.smoothing; }
	private function set_smoothing(value:String):String { return mHelperImage.smoothing = value; } 
	
	/** The baseline of the font. */
	private function get_baseline():Float { return mBaseline; }
}

class CharLocation
{
    public var char:BitmapChar;
    public var scale:Float;
    public var x:Float;
    public var y:Float;
    
    public function new(char:BitmapChar)
    {
        this.char = char;
    }
}