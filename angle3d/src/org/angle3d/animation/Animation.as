package org.angle3d.animation
{
	import org.angle3d.utils.TempVars;

	/**
	 * The animation public class updates the animation target with the tracks of a given type.
	 *
	 */
	public class Animation
	{
		/**
		 * The name of the animation.
		 */
		public var name:String;

		/**
		 * The length of the animation.
		 */
		public var time:Number;

		/**
		 * The tracks of the animation.
		 */
		public var tracks:Vector.<Track>;

		public function Animation(name:String, time:Number)
		{
			this.name = name;
			this.time = time;

			tracks = new Vector.<Track>();
		}

		public function setTracks(tracks:Vector.<Track>):void
		{
			this.tracks = tracks;
		}

		public function addTrack(track:Track):void
		{
			tracks.push(track);
		}

		/**
		 * This method sets the current time of the animation.
		 * This method behaves differently for every known track type.
		 * Override this method if you have your own type of track.
		 *
		 * @param time the time of the animation
		 * @param blendWeight the blend weight factor
		 * @param control the animation control
		 * @param channel the animation channel
		 */
		public function setTime(time:Number, blendWeight:Number, control:AnimControl, channel:AnimChannel, vars:TempVars):void
		{
			if (tracks == null)
				return;

			var length:int = tracks.length;
			for (var i:int = 0; i < length; i++)
			{
				tracks[i].setCurrentTime(time, blendWeight, control, channel, vars);
			}
		}

		/**
		 * This method creates a clone of the current object.
		 * @return a clone of the current object
		 */
		public function clone(newName:String):Animation
		{
			var result:Animation = new Animation(newName, this.time);
			result.tracks = new Vector.<Track>();
			var length:int = tracks.length;
			for (var i:int = 0; i < length; i++)
			{
				result.tracks[i] = tracks[i].clone();
			}
			return result;
		}
	}
}

