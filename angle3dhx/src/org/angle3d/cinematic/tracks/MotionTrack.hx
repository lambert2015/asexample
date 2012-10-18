package org.angle3d.cinematic.tracks;
import org.angle3d.math.Vector2f;
import org.angle3d.math.Vector3f;
import flash.Lib;
import org.angle3d.animation.LoopMode;
import org.angle3d.app.Application;
import org.angle3d.cinematic.Cinematic;
import org.angle3d.cinematic.MotionPath;
import org.angle3d.cinematic.PlayState;
import org.angle3d.math.Quaternion;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.control.Control;
import org.angle3d.scene.Spatial;
import org.angle3d.utils.TempVars;
import org.angle3d.utils.TimerUtil;
/**
 * A MotionTrack is a control over the spatial that manage the position and direction of the spatial while following a motion Path
 *
 * You must first create a MotionPath and then create a MotionTrack to associate a spatial and the path.
 *
 * @author Nehon
 */
class MotionTrack extends AbstractCinematicTrack,implements Control
{
	private var spatial:Spatial;
	private var currentWayPoint:Int;
	private var currentValue:Float;
	private var direction:Vector3f;
	private var lookAt:Vector3f;
	private var upVector:Vector3f;
	private var rotation:Quaternion;
	private var directionType:Int;
	private var path:MotionPath;
	private var isControl:Bool;
	
	/**
     * the distance traveled by the spatial on the path
     */
    private var traveledDistance:Float;

	/**
	 * 
	 * @param	spatial
	 * @param	path
	 * @param	initialDuration 时间长度，秒为单位
	 * @param	loopMode
	 */
	public function new(spatial:Spatial, path:MotionPath, initialDuration:Float = 10, loopMode:Int = 0) 
	{
		super(initialDuration,loopMode);
		
		direction = new Vector3f();
		directionType = Direction.None;
		isControl = true;
		currentValue = 0;
		traveledDistance = 0;
		
		this.spatial = spatial;
        spatial.addControl(this);
        this.path = path;
	}
	
	public function update(tpf:Float):Void
	{
		if (isControl)
		{
			if (playState == PlayState.Playing)
			{
				time = (elapsedTimePause + TimerUtil.getTimeInSeconds() - start) * speed;
				
				onUpdate(tpf);
				
				if (time >= duration && loopMode == LoopMode.DontLoop)
				{
					stop();
				}
			}
		}
	}
	
	override public function init(app:Application, cinematic:Cinematic):Void
	{
		super.init(app, cinematic);
		isControl = false;
    }
	
	override public function setTime(time:Float):Void
	{
        super.setTime(time);        
       
        //computing traveled distance according to new time
        traveledDistance = time * (path.getLength() / initialDuration);
        
        var vars:TempVars = TempVars.getTempVars();
        var temp:Vector3f = vars.vect1;
		
        //getting waypoint index and current value from new traveled distance
        var v:Vector2f = path.getWayPointIndexForDistance(traveledDistance);
        //setting values
        currentWayPoint = Std.int(v.x);
        setCurrentValue(v.y);
        //interpolating new position
        path.getSpline().interpolate(getCurrentValue(), getCurrentWayPoint(), temp);
        //setting new position to the spatial
        spatial.setLocalTranslation(temp);
		
        vars.release();
    }
	
	override public function onUpdate(tpf:Float):Void
	{
		traveledDistance = path.interpolatePath(time, this);
		
		computeTargetDirection();

		if (currentValue >= 1.0)
		{
			currentValue = 0;
			currentWayPoint++;
			path.triggerWayPointReach(currentWayPoint, this);
		}
		
		if (currentWayPoint == path.getNumWayPoints() - 1)
		{
			if (loopMode == LoopMode.Loop)
			{
				currentWayPoint = 0;
			}
			else
			{
				stop();
			}
		}
	}
	
	/**
     * this method is meant to be called by the motion path only
     * @return
     */
	public function needsDirection():Bool
	{
		return directionType == Direction.Path || directionType == Direction.PathAndRotation;
	}
	
	private function computeTargetDirection():Void
	{
		switch(directionType)
		{
			case Direction.Path:
				var q:Quaternion = new Quaternion();
				q.lookAt(direction, Vector3f.Y_AXIS);
				spatial.setLocalRotation(q);
			case Direction.LookAt:
				if (lookAt != null)
				{
					spatial.lookAt(lookAt, upVector);
				}
			case Direction.PathAndRotation:
				if (rotation != null)
				{
					var q2:Quaternion = new Quaternion();
					q2.lookAt(direction, Vector3f.Y_AXIS);
					q2.multiplyLocal(rotation);
					spatial.setLocalRotation(q2);
				}
			case Direction.Rotation:
				if (rotation != null)
				{
					spatial.setLocalRotation(rotation);
				}
			case Direction.None:
				//do nothing
		}
	}
	
	/**
     * Clone this control for the given spatial
     * @param spatial
     * @return
     */
	public function cloneForSpatial(spatial:Spatial):Control
	{
		var control:MotionTrack = new MotionTrack(spatial, path);
        control.playState = playState;
        control.currentWayPoint = currentWayPoint;
        control.currentValue = currentValue;
        control.direction = direction.clone();
        control.lookAt = lookAt.clone();
        control.upVector = upVector.clone();
        control.rotation = rotation.clone();
        control.duration = duration;
        control.initialDuration = initialDuration;
        control.speed = speed;
        control.duration = duration;
        control.loopMode = loopMode;
        control.directionType = directionType;

        return control;
	}
	
	override public function onStop():Void
	{
		currentWayPoint = 0;
	}
	
	/**
     * this method is meant to be called by the motion path only
     * @return
     */
    public function getCurrentValue():Float
	{
        return currentValue;
    }

    /**
     * this method is meant to be called by the motion path only
     *
     */
    public function setCurrentValue(currentValue:Float):Void 
	{
        this.currentValue = currentValue;
    }

    /**
     * this method is meant to be called by the motion path only
     * @return
     */
    public function getCurrentWayPoint():Int
	{
        return currentWayPoint;
    }

    /**
     * this method is meant to be called by the motion path only
     *
     */
    public function setCurrentWayPoint(currentWayPoint:Int):Void 
	{
        this.currentWayPoint = currentWayPoint;
    }

    /**
     * returns the direction the spatial is moving
     * @return
     */
    public function getDirection():Vector3f
	{
        return direction;
    }

    /**
     * Sets the direction of the spatial
     * This method is used by the motion path.
     * @param direction
     */
    public function setDirection(direction:Vector3f):Void 
	{
        this.direction.copyFrom(direction);
    }

    /**
     * returns the direction type of the target
     * @return the direction type
     */
    public function getDirectionType():Int 
	{
        return directionType;
    }

    /**
     * Sets the direction type of the target
     * On each update the direction given to the target can have different behavior
     * See the Direction Enum for explanations
     * @param directionType the direction type
     */
    public function setDirectionType(directionType:Int):Void 
	{
        this.directionType = directionType;
    }

    /**
     * Set the lookAt for the target
     * This can be used only if direction Type is Direction.LookAt
     * @param lookAt the position to look at
     * @param upVector the up vector
     */
    public function setLookAt(lookAt:Vector3f,upVector:Vector3f):Void 
	{
        this.lookAt = lookAt;
        this.upVector = upVector;
    }

    /**
     * returns the rotation of the target
     * @return the rotation quaternion
     */
    public function getRotation():Quaternion
	{
        return rotation;
    }

    /**
     * sets the rotation of the target
     * This can be used only if direction Type is Direction.PathAndRotation or Direction.Rotation
     * With PathAndRotation the target will face the direction of the path multiplied by the given Quaternion.
     * With Rotation the rotation of the target will be set with the given Quaternion.
     * @param rotation the rotation quaternion
     */
    public function setRotation(rotation:Quaternion):Void 
	{
        this.rotation = rotation;
    }

    /**
     * retun the motion path this control follows
     * @return
     */
    public function getPath():MotionPath
	{
        return path;
    }

    /**
     * Sets the motion path to follow
     * @param path
     */
    public function setPath(path:MotionPath):Void 
	{
        this.path = path;
    }

    public function setEnabled(enabled:Bool):Void 
	{
        if (enabled) 
		{
            play();
        } 
		else 
		{
            pause();
        }
    }

    public function isEnabled():Bool 
	{
        return playState != PlayState.Stopped;
    }

    public function render(rm:RenderManager, vp:ViewPort):Void 
	{
    }

    public function setSpatial(spatial:Spatial):Void 
	{
        this.spatial = spatial;
    }

    public function getSpatial():Spatial 
	{
        return spatial;
    }
	
	/**
     * return the distance traveled by the spatial on the path
     * @return 
     */
    public function getTraveledDistance():Float
	{
        return traveledDistance;
    }
	
}