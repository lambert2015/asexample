package org.angle3d.cinematic.event
{
	import org.angle3d.cinematic.LoopMode;
	import org.angle3d.app.Application;
	import org.angle3d.cinematic.PlayState;
	import org.angle3d.cinematic.Cinematic;

	/**
	 * ...
	 * @author andy
	 */

	public interface CinematicEvent
	{
		/**
		 * Starts the animation
		 */
		function play():void;

		/**
		 * Stops the animation
		 */
		function stop():void;

		/**
		 * Pauses the animation
		 */
		function pause():void;

		/**
		 * Returns the actual duration of the animation
		 */
		function getDuration():Number;

		/**
		 * Sets the speed of the animation (1 is normal speed, 2 is twice faster)
		 * @param speed
		 */
		function setSpeed(speed:Number):void;

		/**
		 * returns the speed of the animation
		 * @return
		 */
		function getSpeed():Number;

		/**
		 * returns the PlayState of the animation
		 * @return
		 */
		function getPlayState():int;

		/**
		 * @param loopMode Set the loop mode for the channel. The loop mode
		 * determines what will happen to the animation once it finishes
		 * playing.
		 *
		 * For more information, see the LoopMode enum public class.
		 * @see LoopMode
		 */
		function setLoopMode(loop:int):void;

		/**
		 * @return The loop mode currently set for the animation. The loop mode
		 * determines what will happen to the animation once it finishes
		 * playing.
		 *
		 * For more information, see the LoopMode enum public class.
		 * @see LoopMode
		 */
		function getLoopMode():int;

		/**
		 * returns the initial duration of the animation at speed = 1 in seconds.
		 * @return
		 */
		function getInitialDuration():Number;

		/**
		 * Sets the duration of the antionamtion at speed = 1 in seconds
		 * @param initialDuration
		 */
		function setInitialDuration(initialDuration:Number):void;

		/**
		 * called internally in the update method, place here anything you want to run in the update loop
		 * @param tpf time per frame
		 */
		function internalUpdate(tpf:Number):void;

		/**
		 * initialize this event
		 * @param app the application
		 * @param cinematic the cinematic
		 */
		function init(app:Application, cinematic:Cinematic):void;

		/**
		 * When this method is invoked, the event should fast forward to the given time according tim 0 is the start of the event.
		 * @param time the time to fast forward to
		 */
		function setTime(time:Number):void;

		/**
		 * returns the current time of the cinematic event
		 * @return the time
		 */
		function getTime():Number;
	}
}

