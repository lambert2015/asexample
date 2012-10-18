package org.angle3d.cinematic.event
{
	import flash.utils.getTimer;

	import org.angle3d.app.Application;
	import org.angle3d.cinematic.Cinematic;
	import org.angle3d.cinematic.LoopMode;
	import org.angle3d.cinematic.PlayState;
	import org.angle3d.signals.CinematicSignal;
	import org.angle3d.utils.TimerUtil;

	/**
	 * This calls contains basic behavior of a cinematic event
	 * every cinematic event must extend this public class
	 *
	 * A cinematic event must be given an inital duration in seconds (duration of the event at speed = 1) (default is 10)
	 * @author Nehon
	 */
	public class AbstractCinematicEvent implements CinematicEvent
	{
		protected var playState : int;
		protected var speed : Number;
		protected var initialDuration : Number;
		protected var duration : Number;
		protected var loopMode : int;
		protected var time : Number;

		protected var start : Number;

		/**
		 * the last time the event was paused
		 */
		protected var elapsedTimePause : Number;

		protected var _onStartSignal : CinematicSignal;
		protected var _onPauseSignal : CinematicSignal;
		protected var _onStopSignal : CinematicSignal;

		public function AbstractCinematicEvent(initialDuration : Number = 10, mode : int = 0)
		{
			super();

			this.loopMode = mode;
			this.initialDuration = initialDuration;
			duration = initialDuration / speed;

			speed = 1;
			playState = PlayState.Stopped;
			time = 0;
			start = 0;
			elapsedTimePause = 0;

			_initSignals();
		}

		protected function _initSignals() : void
		{
			_onStartSignal = new CinematicSignal();
			_onPauseSignal = new CinematicSignal();
			_onStopSignal = new CinematicSignal();
		}

		public function get onStartSignal() : CinematicSignal
		{
			return _onStartSignal;
		}

		public function get onPauseSignal() : CinematicSignal
		{
			return _onPauseSignal;
		}

		public function get onStopSignal() : CinematicSignal
		{
			return _onStopSignal;
		}

		public function play() : void
		{
			onPlay();

			playState = PlayState.Playing;

			start = TimerUtil.getTimeInSeconds();

			_onStartSignal.dispatch(this);
		}

		public function onPlay() : void
		{

		}

		public function internalUpdate(tpf : Number) : void
		{
			if (playState == PlayState.Playing)
			{
				time = (elapsedTimePause + getTimer() - start) * speed;

				onUpdate(tpf);

				if (time >= duration && loopMode == LoopMode.DontLoop)
				{
					stop();
				}
			}

		}

		public function onUpdate(tpf : Number) : void
		{

		}

		/**
		 * stops the animation, next time play() is called the animation will start from the begining.
		 */
		public function stop() : void
		{
			onStop();

			time = 0;
			playState = PlayState.Stopped;
			elapsedTimePause = 0;

			_onStopSignal.dispatch(this);
		}

		public function onStop() : void
		{

		}

		public function pause() : void
		{
			onPause();

			playState = PlayState.Paused;
			elapsedTimePause = time;

			_onPauseSignal.dispatch(this);
		}

		public function onPause() : void
		{

		}

		/**
		 * returns the actual duration of the animtion (initialDuration/speed)
		 * @return
		 */
		public function getDuration() : Number
		{
			return initialDuration / speed;
		}

		/**
		 * Sets the speed of the animation.
		 * At speed = 1, the animation will last initialDuration seconds,
		 * At speed = 2 the animation will last initialDuraiton/2...
		 * @param speed
		 */
		public function setSpeed(speed : Number) : void
		{
			this.speed = speed;
		}

		/**
		 * returns the speed of the animation.
		 * @return
		 */
		public function getSpeed() : Number
		{
			return speed;
		}

		/**
		 * Returns the current playstate of the animation
		 * @return
		 */
		public function getPlayState() : int
		{
			return playState;
		}

		/**
		 * returns the initial duration of the animation at speed = 1 in seconds.
		 * @return
		 */
		public function getInitialDuration() : Number
		{
			return initialDuration;
		}

		/**
		 * Sets the duration of the antionamtion at speed = 1 in seconds
		 * @param initialDuration
		 */
		public function setInitialDuration(initialDuration : Number) : void
		{
			this.initialDuration = initialDuration;
		}

		/**
		 * retursthe loopMode of the animation
		 * @see LoopMode
		 * @return
		 */
		public function getLoopMode() : int
		{
			return loopMode;
		}

		/**
		 * Sets the loopMode of the animation
		 * @see LoopMode
		 * @param loopMode
		 */
		public function setLoopMode(loopMode : int) : void
		{
			this.loopMode = loopMode;
		}

		public function init(app : Application, cinematic : Cinematic) : void
		{

		}

		/**
		 * When this method is invoked, the event should fast forward to the given time according tim 0 is the start of the event.
		 * @param time the time to fast forward to
		 */
		public function setTime(time : Number) : void
		{
			elapsedTimePause = time / speed;
			if (playState == PlayState.Playing)
			{
				start = getTimer();
			}
		}

		/**
		 * 已运行时间(秒)
		 * @return
		 */
		public function getTime() : Number
		{
			return time;
		}
	}
}

