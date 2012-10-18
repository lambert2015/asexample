package org.angle3d.cinematic.events;
import flash.events.Event;
import org.angle3d.cinematic.tracks.CinematicTrack;
import org.angle3d.cinematic.tracks.MotionTrack;

/**
 * ...
 * @author andy
 */
class MotionPathEvent extends Event
{
	public static inline var ON_WAYPOINT_REACH:String = "onWayPointReach";
	
	private var motionControl:MotionTrack;
	private var wayPointIndex:Int;

	public function new(motionControl:MotionTrack, wayPointIndex:Int, type:String, bubbles:Bool = false, cancelable:Bool = false) 
	{
		super(type, bubbles, cancelable);
		
		this.motionControl = motionControl;
		this.wayPointIndex = wayPointIndex;
	}
	
	public function getWayPointIndex():Int
	{
		return this.wayPointIndex;
	}
	
	public function getMotionControl():MotionTrack
	{
		return this.motionControl;
	}
}