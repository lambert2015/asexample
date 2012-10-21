package org.angle3d.cinematic
{

	/**
	 * <code>LoopMode</code> determines how animations repeat, or if they
	 * do not repeat.
	 */

	public class LoopMode
	{

		/**
		 * The animation will play repeatedly, when it reaches the end
		 * the animation will play again from the beginning, and so on.
		 */
		public static const Loop:int=0;

		/**
		 * The animation will not loop. It will play until the last frame, and then
		 * freeze at that frame. It is possible to decide to play a new animation
		 * when that happens by using a AnimEventListener.
		 */
		public static const DontLoop:int=1;

		/**
		 * The animation will cycle back and forth. When reaching the end, the
		 * animation will play backwards from the last frame until it reaches
		 * the first frame.
		 */
		public static const Cycle:int=2;
	}
}

