package org.angle3d.cinematic;

import flash.Vector;
import org.angle3d.cinematic.tracks.CinematicTrack;

class KeyFrame 
{
	private var tracks:Vector<CinematicTrack>;
	private var index:Int;

	public function new() 
	{
		tracks = new Vector<CinematicTrack>();
	}
	
	public function trigger():Vector<CinematicTrack> 
	{
		for (i in 0...tracks.length)
		{
			tracks[i].play();
		}
		return tracks;
	}
	
	public function getTracks():Vector<CinematicTrack> 
	{
        return tracks;
    }
	
	public function addTrack(track:CinematicTrack):Void
	{
		tracks.push(track);
	}

    public function setTracks(tracks:Vector<CinematicTrack>):Void
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