package org.angle3d.cinematic;
import flash.Vector;
import org.angle3d.animation.LoopMode;
import org.angle3d.app.Application;
import org.angle3d.app.state.AppState;
import org.angle3d.app.state.AppStateManager;
import org.angle3d.cinematic.tracks.AbstractCinematicTrack;
import org.angle3d.cinematic.tracks.CinematicTrack;
import org.angle3d.renderer.Camera3D;
import org.angle3d.renderer.RenderManager;
import org.angle3d.scene.CameraNode;
import org.angle3d.scene.control.CameraControl;
import org.angle3d.scene.Node;
import org.angle3d.utils.HashMap;
/**
 * ...
 * @author andy
 */

class Cinematic extends AbstractCinematicTrack,implements AppState
{
	private var scene:Node;
	private var timeLine:TimeLine;
	private var lastFetchedKeyFrame:Int;
	private var tracks:Vector<CinematicTrack>;
	private var cameras:HashMap<String,CameraNode>;
	private var currentCam:CameraNode;
	private var initialized:Bool;
	private var scheduledPause:Int;

	public function new(scene:Node, initialDuration:Float = 10, loopMode:Int = 0)
	{
		super(initialDuration, loopMode);
		
		timeLine = new TimeLine();
		lastFetchedKeyFrame = -1;
		tracks = new Vector<CinematicTrack>();
		cameras = new HashMap<String,CameraNode>();
		initialized = false;
		scheduledPause = -1;
		
		this.scene = scene;
	}
	
	override public function onPlay():Void
	{
		if (isInitialized())
		{
			scheduledPause = -1;
			//enableCurrentCam(true);
            if (playState == PlayState.Paused) 
			{
                for (i in 0...tracks.length) 
				{
                    var ct:CinematicTrack = tracks[i];
                    if (ct.getPlayState() == PlayState.Paused) 
					{
                        ct.play();
                    }
                }
            }
		}
	}
	
	override public function onStop():Void
	{
		time = 0;
        lastFetchedKeyFrame = -1;
        for (i in 0...tracks.length) 
		{
            var ct:CinematicTrack = tracks[i];
            ct.stop();
        }
		enableCurrentCam(false);
	}
	
	override public function onPause():Void
	{
        for (i in 0...tracks.length) 
		{
            var ct:CinematicTrack = tracks[i];
            if (ct.getPlayState() == PlayState.Playing) 
			{
                ct.pause();
            }
        }
		//enableCurrentCam(false);
	}
	
	override public function setSpeed(speed:Float):Void 
	{
        super.setSpeed(speed);
        for (i in 0...tracks.length) 
		{
            var ct:CinematicTrack = tracks[i];
            ct.setSpeed(speed);
        }
	}
	
	public function initialize(stateManager:AppStateManager,app:Application):Void
	{
		init(app, this);
		for (i in 0...tracks.length) 
		{
            var ct:CinematicTrack = tracks[i];
            ct.init(app, this);
        }
		
		initialized = true;
    }
	
	public function setEnabled(enabled:Bool):Void
	{
        if (enabled) 
		{
            play();
        }
    }

	public function isEnabled():Bool
	{
        return playState == PlayState.Playing;
    }
	
	public function stateAttached(stateManager:AppStateManager):Void
	{
    }

    public function stateDetached(stateManager:AppStateManager):Void 
	{
        stop();
    }
	
	public function update(tpf:Float):Void
	{
		if (isInitialized())
		{
			internalUpdate(tpf);
		}
	}
	
	private function step():Void
	{
		if (playState != PlayState.Playing)
		{
			play();
			scheduledPause = 2;
		}
	}
	
	override public function onUpdate(tpf:Float):Void
	{
		if (scheduledPause >= 0) 
		{
            if (scheduledPause == 0) 
			{
                pause();
            }
            scheduledPause--;
        }
		
		for (i in 0...tracks.length) 
		{
            var ct:CinematicTrack = tracks[i];
            ct.internalUpdate(tpf);
        }

        var keyFrameIndex:Int = timeLine.getKeyFrameIndexFromTime(time);

        //iterate to make sure every key frame is triggered
		var i:Int = lastFetchedKeyFrame + 1;
		while (i <= keyFrameIndex)
		{
            var keyFrame:KeyFrame = timeLine.getKeyFrameAtIndex(i);
            if (keyFrame != null) 
			{
                keyFrame.trigger();
            }
			
			i++;
        }

        lastFetchedKeyFrame = keyFrameIndex;
    }
	
	override public function setTime(time:Float):Void
	{
		super.setTime(time);
		
		var keyFrameIndex:Int = timeLine.getKeyFrameIndexFromTime(time);
		
		//triggering all the event from start to "time" 
        //then computing timeOffset for each event
		for (i in 0...(keyFrameIndex + 1))
		{
            var keyFrame:KeyFrame = timeLine.getKeyFrameAtIndex(i);
            if (keyFrame != null) 
			{
				var tracks:Vector<CinematicTrack> = keyFrame.getTracks();
                for (j in 0...tracks.length)
		        {
					var track:CinematicTrack = tracks[j];
					if (playState == PlayState.Playing)
					{
						track.play();
					}
			        track.setTime(time-timeLine.getKeyFrameTime(keyFrame));
		        }
            }
        }
		
		step();
	}
	
	public function addTrack(timeStamp:Float, track:CinematicTrack):KeyFrame
	{
        var keyFrame:KeyFrame = timeLine.getKeyFrameAtTime(timeStamp);
        if (keyFrame == null) 
		{
            keyFrame = new KeyFrame();
            timeLine.addKeyFrameAtTime(timeStamp, keyFrame);
        }
		
        keyFrame.addTrack(track);
        tracks.push(track);
        return keyFrame;
    }
	
	public function render(rm:RenderManager):Void
	{
    }

    public function postRender():Void
	{
    }

    public function cleanup() :Void
	{
		
	}
	
	public function fitDuration() :Void
	{
        var kf:KeyFrame = timeLine.getKeyFrameAtTime(timeLine.getLastKeyFrameIndex());
        var d:Float = 0;
		var tracks:Vector<CinematicTrack> = kf.getTracks();
        for (i in 0...tracks.length)
		{
            var ck:CinematicTrack = tracks[i];
            if (d < (ck.getDuration() * ck.getSpeed())) 
			{
                d = (ck.getDuration() * ck.getSpeed());
            }
        }

        initialDuration = d;
    }
	
	public function bindCamera(cameraName:String,cam:Camera3D):CameraNode
	{
        var node:CameraNode = new CameraNode(cameraName, cam);
        node.setControlDir(CameraControl.SpatialToCamera);
        node.getCameraControl().setEnabled(false);
        cameras.setValue(cameraName, node);
        scene.attachChild(node);
        return node;
    }
	
	public function getCamera(cameraName:String):CameraNode
	{
        return cameras.getValue(cameraName);
    }
	
	private function enableCurrentCam(enabled:Bool):Void
	{
        if (currentCam != null) 
		{
            currentCam.getControl(0).setEnabled(enabled);
        }
    }

    public function setActiveCamera(cameraName:String):Void
	{
        enableCurrentCam(false);
        currentCam = cameras.getValue(cameraName);
        enableCurrentCam(true);
    }
    
	public function setScene(scene:Node):Void
	{
        this.scene = scene;
    }
	
	public function getScene():Node
	{
		return this.scene;
	}
	
	public function isInitialized():Bool
	{
		return this.initialized;
	}
	
}