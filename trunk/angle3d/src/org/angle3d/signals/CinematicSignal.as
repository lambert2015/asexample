package org.angle3d.signals
{
	import org.angle3d.cinematic.event.CinematicEvent;
	import org.osflash.signals.Signal;

	public class CinematicSignal extends Signal
	{
		private var _cinematicEvent:CinematicEvent;


		public function CinematicSignal()
		{
			super();
		}

		/**
		 * Dispatches Signal.
		 *
		 * @param args1 CinematicTrack - CinematicTrack.
		 */
		override public function dispatch(... args):void
		{
			_cinematicEvent=args[0];

			super.dispatch.apply(null, [this]);
		}

		public function get cinematicEvent():CinematicEvent
		{
			return _cinematicEvent;
		}
	}
}

