package org.angle3d.cinematic;

import org.angle3d.cinematic.event.CinematicEvent;

//TODO 重命名
class KeyFrame
{
	private var tracks:Vector<CinematicEvent>;
	private var index:Int;

	public function new()
	{
		tracks = new Vector<CinematicEvent>();
	}

	public function isEmpty():Bool
	{
		return tracks.length == 0;
	}

	public function trigger():Vector<CinematicEvent>
	{
		var length:Int = tracks.length;
		for (var i:Int = 0; i < length; i++)
		{
			tracks[i].play();
		}
		return tracks;
	}

	public function getTracks():Vector<CinematicEvent>
	{
		return tracks;
	}

	public function addTrack(track:CinematicEvent):Void
	{
		tracks.push(track);
	}

	public function setTracks(tracks:Vector<CinematicEvent>):Void
	{
		this.tracks = tracks;
	}

	public function getIndex():Int
	{
		return index;
	}

	public function setIndex(index:Int):Void
	{
		this.index = index;
	}
}

