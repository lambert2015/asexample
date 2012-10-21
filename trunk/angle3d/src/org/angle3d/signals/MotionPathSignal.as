package org.angle3d.signals
{
	import org.angle3d.cinematic.event.MotionEvent;
	import org.osflash.signals.Signal;

	public class MotionPathSignal extends Signal
	{
		private var _curWayPoint:int;

		private var _motionEvent:MotionEvent;

		public function MotionPathSignal()
		{
			super();
			//this.valueClasses = [MotionPathSignal];
		}

		/**
		 * Dispatches Signal.
		 *
		 * @param args1 MotionPath - MotionPath.
		 * @param args2 curWayPoint - current way point index
		 */
		override public function dispatch(... args):void
		{
			_motionEvent = args[0];
			_curWayPoint = args[1];

			super.dispatch.apply(null, [this]);
		}

		public function get curWayPoint():int
		{
			return _curWayPoint
		}

		public function get motionEvent():MotionEvent
		{
			return _motionEvent;
		}
	}
}

