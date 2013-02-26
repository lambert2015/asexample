package org.angle3d.cinematic.events;
import flash.events.Event;
import org.angle3d.cinematic.tracks.CinematicTrack;

/**
 * ...
 * @author andy
 */
class CinematicEvent extends Event
{
	public static inline var PLAY:String = "play";
	public static inline var PAUSE:String = "pause";
	public static inline var STOP:String = "stop";
	
	private var track:CinematicTrack;

	public function new(track:CinematicTrack, type:String, bubbles:Bool = false, cancelable:Bool = false) 
	{
		super(type, bubbles, cancelable);
		
		this.track = track;
	}
	
	public function getTrack():CinematicTrack
	{
		return this.track;
	}
	
}