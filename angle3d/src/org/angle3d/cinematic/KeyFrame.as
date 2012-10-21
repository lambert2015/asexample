package org.angle3d.cinematic
{


	import org.angle3d.cinematic.event.CinematicEvent;

	//TODO 重命名
	public class KeyFrame
	{
		private var tracks:Vector.<CinematicEvent>;
		private var index:int;

		public function KeyFrame()
		{
			tracks = new Vector.<CinematicEvent>();
		}

		public function trigger():Vector.<CinematicEvent>
		{
			var length:int = tracks.length;
			for (var i:int = 0; i < length; i++)
			{
				tracks[i].play();
			}
			return tracks;
		}

		public function getTracks():Vector.<CinematicEvent>
		{
			return tracks;
		}

		public function addTrack(track:CinematicEvent):void
		{
			tracks.push(track);
		}

		public function setTracks(tracks:Vector.<CinematicEvent>):void
		{
			this.tracks = tracks;
		}

		public function getIndex():int
		{
			return index;
		}

		public function setIndex(index:int):void
		{
			this.index = index;
		}
	}
}

