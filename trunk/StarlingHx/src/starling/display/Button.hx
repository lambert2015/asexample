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

import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.HAlign;
import starling.utils.VAlign;

/** Dispatched when the user triggers the button. Bubbles. */
@:meta([Event(name="triggered", type="starling.events.Event")])

/** A simple button composed of an image and, optionally, text.
 *  
 *  <p>You can pass a texture for up- and downstate of the button. If you do not provide a down 
 *  state, the button is simply scaled a little when it is touched.
 *  In addition, you can overlay a text on the button. To customize the text, almost the 
 *  same options as those of text fields are provided. In addition, you can move the text to a 
 *  certain position with the help of the <code>textBounds</code> property.</p>
 *  
 *  <p>To react on touches on a button, there is special <code>triggered</code>-event type. Use
 *  this event instead of normal touch events - that way, users can cancel button activation
 *  by moving the mouse/finger away from the button before releasing.</p> 
 */ 
class Button extends DisplayObjectContainer
{
	private static inline var MAX_DRAG_DIST:Float = 50;
	
	private var mUpState:Texture;
	private var mDownState:Texture;
	
	private var mContents:Sprite;
	private var mBackground:Image;
	private var mTextField:TextField;
	private var mTextBounds:Rectangle;
	
	private var mScaleWhenDown:Float;
	private var mAlphaWhenDisabled:Float;
	private var mEnabled:Bool;
	private var mIsDown:Bool;
	private var mUseHandCursor:Bool;
	
	/** Creates a button with textures for up- and down-state or text. */
	public function new(upState:Texture, text:String="", downState:Texture=null)
	{
		if (upState == null) throw new ArgumentError("Texture cannot be null");
		
		mUpState = upState;
		mDownState = downState ? downState : upState;
		mBackground = new Image(upState);
		mScaleWhenDown = downState ? 1.0 : 0.9;
		mAlphaWhenDisabled = 0.5;
		mEnabled = true;
		mIsDown = false;
		mUseHandCursor = true;
		mTextBounds = new Rectangle(0, 0, upState.width, upState.height);            
		
		mContents = new Sprite();
		mContents.addChild(mBackground);
		addChild(mContents);
		addEventListener(TouchEvent.TOUCH, onTouch);
		
		if (text.length != 0) this.text = text;
	}
	
	private function resetContents():Void
	{
		mIsDown = false;
		mBackground.texture = mUpState;
		mContents.x = mContents.y = 0;
		mContents.scaleX = mContents.scaleY = 1.0;
	}
	
	private function createTextField():Void
	{
		if (mTextField == null)
		{
			mTextField = new TextField(mTextBounds.width, mTextBounds.height, "");
			mTextField.vAlign = VAlign.CENTER;
			mTextField.hAlign = HAlign.CENTER;
			mTextField.touchable = false;
			mTextField.autoScale = true;
			mContents.addChild(mTextField);
		}
		
		mTextField.width  = mTextBounds.width;
		mTextField.height = mTextBounds.height;
		mTextField.x = mTextBounds.x;
		mTextField.y = mTextBounds.y;
	}
	
	private function onTouch(event:TouchEvent):Void
	{
		Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
			MouseCursor.BUTTON : MouseCursor.AUTO;
		
		var touch:Touch = event.getTouch(this);
		if (!mEnabled || touch == null) return;
		
		if (touch.phase == TouchPhase.BEGAN && !mIsDown)
		{
			mBackground.texture = mDownState;
			mContents.scaleX = mContents.scaleY = mScaleWhenDown;
			mContents.x = (1.0 - mScaleWhenDown) / 2.0 * mBackground.width;
			mContents.y = (1.0 - mScaleWhenDown) / 2.0 * mBackground.height;
			mIsDown = true;
		}
		else if (touch.phase == TouchPhase.MOVED && mIsDown)
		{
			// reset button when user dragged too far away after pushing
			var buttonRect:Rectangle = getBounds(stage);
			if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
				touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
				touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
				touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
			{
				resetContents();
			}
		}
		else if (touch.phase == TouchPhase.ENDED && mIsDown)
		{
			resetContents();
			dispatchEventWith(Event.TRIGGERED, true);
		}
	}
	
	/** The scale factor of the button on touch. Per default, a button with a down state 
	  * texture won't scale. */
	private function get_scaleWhenDown():Float { return mScaleWhenDown; }
	private function set_scaleWhenDown(value:Float):Void { mScaleWhenDown = value; }
	
	/** The alpha value of the button when it is disabled. @default 0.5 */
	private function get_alphaWhenDisabled():Float { return mAlphaWhenDisabled; }
	private function set_alphaWhenDisabled(value:Float):Void { mAlphaWhenDisabled = value; }
	
	/** Indicates if the button can be triggered. */
	private function get_enabled():Bool { return mEnabled; }
	private function set_enabled(value:Bool):Void
	{
		if (mEnabled != value)
		{
			mEnabled = value;
			mContents.alpha = value ? 1.0 : mAlphaWhenDisabled;
			resetContents();
		}
	}
	
	/** The text that is displayed on the button. */
	private function get_text():String { return mTextField ? mTextField.text : ""; }
	private function set_text(value:String):Void
	{
		createTextField();
		mTextField.text = value;
	}
   
	/** The name of the font displayed on the button. May be a system font or a registered 
	  * bitmap font. */
	private function get_fontName():String { return mTextField ? mTextField.fontName : "Verdana"; }
	private function set_fontName(value:String):Void
	{
		createTextField();
		mTextField.fontName = value;
	}
	
	/** The size of the font. */
	private function get_fontSize():Float { return mTextField ? mTextField.fontSize : 12; }
	private function set_fontSize(value:Float):Void
	{
		createTextField();
		mTextField.fontSize = value;
	}
	
	/** The color of the font. */
	private function get_fontColor():UInt { return mTextField ? mTextField.color : 0x0; }
	private function set_fontColor(value:UInt):Void
	{
		createTextField();
		mTextField.color = value;
	}
	
	/** Indicates if the font should be bold. */
	private function get_fontBold():Bool { return mTextField ? mTextField.bold : false; }
	private function set_fontBold(value:Bool):Void
	{
		createTextField();
		mTextField.bold = value;
	}
	
	/** The texture that is displayed when the button is not being touched. */
	private function get_upState():Texture { return mUpState; }
	private function set_upState(value:Texture):Void
	{
		if (mUpState != value)
		{
			mUpState = value;
			if (!mIsDown) mBackground.texture = value;
		}
	}
	
	/** The texture that is displayed while the button is touched. */
	private function get_downState():Texture { return mDownState; }
	private function set_downState(value:Texture):Void
	{
		if (mDownState != value)
		{
			mDownState = value;
			if (mIsDown) mBackground.texture = value;
		}
	}
	
	/** The vertical alignment of the text on the button. */
	private function get_textVAlign():String { return mTextField.vAlign; }
	private function set_textVAlign(value:String):Void
	{
		createTextField();
		mTextField.vAlign = value;
	}
	
	/** The horizontal alignment of the text on the button. */
	private function get_textHAlign():String { return mTextField.hAlign; }
	private function set_textHAlign(value:String):Void
	{
		createTextField();
		mTextField.hAlign = value;
	}
	
	/** The bounds of the textfield on the button. Allows moving the text to a custom position. */
	private function get_textBounds():Rectangle { return mTextBounds.clone(); }
	private function set_textBounds(value:Rectangle):Void
	{
		mTextBounds = value.clone();
		createTextField();
	}
	
	/** Indicates if the mouse cursor should transform into a hand while it's over the button. 
	 *  @default true */
	private override function get_useHandCursor():Bool { return mUseHandCursor; }
	private override function set_useHandCursor(value:Bool):Void { mUseHandCursor = value; }
}