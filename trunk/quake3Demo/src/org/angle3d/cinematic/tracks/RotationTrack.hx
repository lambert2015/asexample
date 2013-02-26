package org.angle3d.cinematic.tracks;
import org.angle3d.animation.LoopMode;
import org.angle3d.app.Application;
import org.angle3d.cinematic.Cinematic;
import org.angle3d.cinematic.PlayState;
import org.angle3d.math.FastMath;
import org.angle3d.math.Quaternion;
import org.angle3d.scene.Spatial;
import org.angle3d.utils.Logger;
/**
 * ...
 * @author andy
 */

class RotationTrack extends AbstractCinematicTrack
{
	private var startRotation:Quaternion;
	private var endRotation:Quaternion;
	private var spatial:Spatial;
	private var spatialName:String;
	private var value:Float;
	
	private var tmpQuaternion:Quaternion;

	public function new(spatial:Spatial, endRotation:Quaternion = null, initialDuration:Float = 10, loopMode:LoopMode = null)
	{
		super(initialDuration, loopMode);
		
		this.tmpQuaternion = new Quaternion();
		this.value = 0;
		this.startRotation = new Quaternion();
		
		this.spatial = spatial;
		this.spatialName = spatial.getName();
		this.endRotation.copyFrom(endRotation);

	}
	
	override public function init(app:Application, cinematic:Cinematic):Void
	{
		super.init(app, cinematic);
		
		if (spatial == null)
		{
			spatial = cinematic.getScene().getChildByName(spatialName);
			if (spatial == null)
			{
				Logger.log("spatial " + spatialName + " not found in the scene");
			}
		}
    }
	
	override public function onPlay():Void
	{
		if (playState != PlayState.Paused)
		{
			startRotation.copyFrom(spatial.getWorldRotation());
		}
		
		if (duration == 0 && spatial != null)
		{
			spatial.setLocalRotation(endRotation);
			stop();
		}
	}
	
	override public function onUpdate(tpf:Float):Void
	{
		if (spatial != null)
		{
			value += FastMath.fmin(tpf * speed / duration, 1.0);

			tmpQuaternion.copyFrom(startRotation);
			tmpQuaternion.slerp(endRotation, value);

			spatial.setLocalRotation(tmpQuaternion);
		}
	}
	
	override public function onStop():Void
	{
		value = 0;
	}
	
	override public function onPause():Void
	{

	}
	
}