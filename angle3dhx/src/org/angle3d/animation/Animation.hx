package org.angle3d.animation;
import flash.Vector;

/**
 * The animation class updates the animation target with the tracks of a given type.
 * 
 * @author Kirill Vainer, Marcin Roguski (Kaelthas)
 */
class Animation 
{
	/** 
     * The name of the animation. 
     */
    private var name:String;
    
    /** 
     * The length of the animation. 
     */
    private var length:Float;
    
    /** 
     * The tracks of the animation. 
     */
    private var tracks:Vector<Track>;

	public function new(name:String,length:Float) 
	{
		this.name = name;
		this.length = length;
	}
	
	/**
     * The name of the bone animation
     * @return name of the bone animation
     */
	public function getName():String
	{
		return name;
	}
	
	/**
     * Returns the length in seconds of this animation
     * 
     * @return the length in seconds of this animation
     */
	public function getLength():Float
	{
		return length;
	}
	
	/**
     * This method sets the current time of the animation.
     * This method behaves differently for every known track type.
     * Override this method if you have your own type of track.
     * 
     * @param time the time of the animation
     * @param blendAmount the blend amount factor
     * @param control the animation control
     * @param channel the animation channel
     */
	public function setTime(time:Float, blendAmount:Float, control:AnimControl, channel:AnimChannel):Void
	{
		if (tracks == null)
            return;
        
        for (i in 0...tracks.length)
		{
            tracks[i].setTime(time, blendAmount, control, channel);
        }
	}
	
	/**
     * Set the {@link Track}s to be used by this animation.
     * <p>
     * The array should be organized so that the appropriate Track can
     * be retrieved based on a bone index. 
     * 
     * @param tracks The tracks to set.
     */
	public function setTracks(tracks:Vector<Track>):Void
	{
		this.tracks = tracks;
	}
	
	/**
     * Returns the tracks set in {@link #setTracks(com.jme3.animation.Track[]) }.
     * 
     * @return the tracks set previously
     */
	public function getTracks():Vector<Track>
	{
		return tracks;
	}
	
	
	/**
     * This method creates a clone of the current object.
     * @return a clone of the current object
     */
	public function clone():Animation
	{
		var result:Animation = new Animation(name + "_clone", this.length);
        result.tracks = new Vector<Track>();
        for (i in 0...tracks.length) 
		{
            result.tracks[i] = tracks[i].clone();
        }
        return result;
	}
}