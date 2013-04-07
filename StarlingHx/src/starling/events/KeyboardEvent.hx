// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events;

/** A KeyboardEvent is dispatched in response to user input through a keyboard.
 * 
 *  <p>This is Starling's version of the Flash KeyboardEvent class. It contains the same 
 *  properties as the Flash equivalent.</p> 
 * 
 *  <p>To be notified of keyboard events, add an event listener to the Starling stage. Children
 *  of the stage won't be notified of keybaord input. Starling has no concept of a "Focus"
 *  like native Flash.</p>
 *  
 *  @see starling.display.Stage
 */  
class KeyboardEvent extends Event
{
	/** Event type for a key that was released. */
	public static inline var KEY_UP:String = "keyUp";
	
	/** Event type for a key that was pressed. */
	public static inline var KEY_DOWN:String = "keyDown";
	
	/** Contains the character code of the key. */
	public var charCode(default, null):UInt;
	
	/** The key code of the key. */
	public var keyCode(default, null):UInt;
	
	/** Indicates the location of the key on the keyboard. This is useful for differentiating 
	 *  keys that appear more than once on a keyboard. @see Keylocation */ 
	public var keyLocation(default, null):UInt;
	
	/** Indicates whether the Alt key is active on Windows or Linux; 
	 *  indicates whether the Option key is active on Mac OS. */
	public var altKey(default, null):Bool;
	
	/** Indicates whether the Ctrl key is active on Windows or Linux; 
	 *  indicates whether either the Ctrl or the Command key is active on Mac OS. */
	public var ctrlKey(default, null):Bool;
	
	/** Indicates whether the Shift key modifier is active (true) or inactive (false). */
	public var shiftKey(default, null):Bool;
	
	/** Creates a new KeyboardEvent. */
	public function new(type:String, charCode:UInt = 0, keyCode:UInt = 0,
								  keyLocation:UInt = 0, ctrlKey:Bool = false, 
								  altKey:Bool = false, shiftKey:Bool = false)
	{
		super(type, false, keyCode);
		this.charCode = charCode;
		this.keyCode = keyCode;
		this.keyLocation = keyLocation;
		this.ctrlKey = ctrlKey;
		this.altKey = altKey;
		this.shiftKey = shiftKey;
	}
}