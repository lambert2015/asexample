package org.angle3d.cinematic.tracks;
import flash.events.EventDispatcher;
import flash.Lib;
import org.angle3d.animation.LoopMode;
import org.angle3d.app.Application;
import org.angle3d.cinematic.events.CinematicEvent;
import org.angle3d.cinematic.PlayState;
import org.angle3d.cinematic.Cinematic;
import org.angle3d.utils.TimerUtil;

/**
 * This calls contains basic behavior of a cinematic event
 * every cinematic event must extend this class
 * 
 * A cinematic event must be given an inital duration in seconds (duration of the event at speed = 1) (default is 10)
 * @author Nehon
 */
class AbstractCinematicTrack extends EventDispatcher,implements CinematicTrack
{
	private var playState:Int;
	private var speed:Float;
	private var initialDuration:Float;
	private var duration:Float;
	private var loopMode:Int;
	private var time:Float;
	
	private var start:Float;
	
	/**
     * the last time the event was paused
     */
    private var elapsedTimePause:Float;

	public function new(initialDuration:Float = 10, mode:Int = 0) 
	{
		super();
		
		speed = 1;
		playState = PlayState.Stopped;
		time = 0;
		start = 0;
		elapsedTimePause = 0;
		
		this.initialDuration = initialDuration;
        duration = initialDuration / speed;
		
		this.loopMode = mode;
	}
	
	public function play():Void
	{
		onPlay();
		
        playState = PlayState.Playing;
		
		start = TimerUtil.getTimeInSeconds();
		
		if (hasEventListener(CinematicEvent.PLAY))
		{
			dispatchEvent(new CinematicEvent(this, CinematicEvent.PLAY));
		}
	}
	
	public function onPlay():Void
	{
		
	}
	
	public function internalUpdate(tpf:Float):Void
	{
        if (playState == PlayState.Playing) 
		{
            time = (elapsedTimePause + Lib.getTimer() - start) * speed;

            onUpdate(tpf);
			
            if (time >= duration && loopMode == LoopMode.DontLoop) 
			{
                stop();
            }
        }

    }
	
	public function onUpdate(tpf:Float):Void
	{
		
	}
	
	/**
     * stops the animation, next time play() is called the animation will start from the begining.
     */
    public function stop():Void 
	{
        onStop();
		
        time = 0;
        playState = PlayState.Stopped;
		elapsedTimePause = 0;
		
        if (hasEventListener(CinematicEvent.STOP))
		{
			dispatchEvent(new CinematicEvent(this, CinematicEvent.STOP));
		}
    }
	
	public function onStop():Void
	{
		
	}
	
	public function pause():Void 
	{
        onPause();
		
        playState = PlayState.Paused;
		elapsedTimePause = time;
		
        if (hasEventListener(CinematicEvent.PAUSE))
		{
			dispatchEvent(new CinematicEvent(this, CinematicEvent.PAUSE));
		}
    }
	
	public function onPause():Void
	{
		
	}
	
	/**
     * returns the actual duration of the animtion (initialDuration/speed)
     * @return
     */
    public function getDuration():Float 
	{
        return initialDuration / speed;
    }

    /**
     * Sets the speed of the animation.
     * At speed = 1, the animation will last initialDuration seconds,
     * At speed = 2 the animation will last initialDuraiton/2...
     * @param speed
     */
    public function setSpeed(speed:Float):Void
	{
        this.speed = speed;
    }

    /**
     * returns the speed of the animation.
     * @return
     */
    public function getSpeed():Float 
	{
        return speed;
    }

    /**
     * Returns the current playstate of the animation
     * @return
     */
    public function getPlayState():Int 
	{
        return playState;
    }

    /**
     * returns the initial duration of the animation at speed = 1 in seconds.
     * @return
     */
    public function getInitialDuration():Float
	{
        return initialDuration;
    }

    /**
     * Sets the duration of the antionamtion at speed = 1 in seconds
     * @param initialDuration
     */
    public function setInitialDuration(initialDuration:Float):Void
	{
        this.initialDuration = initialDuration;
    }

    /**
     * retursthe loopMode of the animation
     * @see LoopMode
     * @return
     */
    public function getLoopMode():Int 
	{
        return loopMode;
    }

    /**
     * Sets the loopMode of the animation
     * @see LoopMode
     * @param loopMode
     */
    public function setLoopMode(loopMode:Int):Void
	{
        this.loopMode = loopMode;
    }
	
	public function init(app:Application, cinematic:Cinematic):Void
	{
		
    }
	
	/**
     * When this method is invoked, the event should fast forward to the given time according tim 0 is the start of the event.
     * @param time the time to fast forward to
     */
    public function setTime(time:Float):Void
	{
        elapsedTimePause = time/speed;
        if (playState == PlayState.Playing)
		{
            start = Lib.getTimer();
        }
    }

	/**
	 * 已运行时间(秒)
	 * @return
	 */
    public function getTime():Float
	{
        return time;
    }
	
}