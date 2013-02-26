package org.angle3d.animation;

/**
 * ...
 * @author andy
 */

interface Track 
{
	/**
     * Sets the time of the animation.
     * 
     * Internally, the track will retrieve objects from the control
     * and modify them according to the properties of the channel and the
     * given parameters.
     * 
     * @param time The time in the animation
     * @param weight The weight from 0 to 1 on how much to apply the track 
     * @param control The control which the track should effect
     * @param channel The channel which the track should effect
     */
    function setTime(time:Float,weight:Float,control:AnimControl,channel:AnimChannel):Void;

    /**
     * @return the length of the track
     */
    function getLength():Float;

    /**
     * This method creates a clone of the current object.
     * @return a clone of the current object
     */
    function clone():Track;
	
}