package org.angle3d.cinematic.tracks;
import org.angle3d.animation.LoopMode;
import org.angle3d.app.Application;
import org.angle3d.cinematic.Cinematic;
import org.angle3d.cinematic.PlayState;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Spatial;
import org.angle3d.utils.Logger;

/**
 * ...
 * @author andy
 */
class ScaleTrack extends AbstractCinematicTrack
{
	private var startScale:Vector3f;
	private var endScale:Vector3f;
	private var spatial:Spatial;
	private var spatialName:String;
	private var value:Float;

	public function new(spatial:Spatial, endScale:Vector3f = null, initialDuration:Float = 10, loopMode:Int = 0)
	{
		super(initialDuration, loopMode);
		
		this.value = 0;
		this.spatial = spatial;
		this.spatialName = spatial.getName();
		
		this.endScale = endScale;

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
			startScale = spatial.getWorldTranslation().clone();
		}
		
		if (duration == 0 && spatial != null)
		{
			spatial.setLocalScale(endScale);
			stop();
		}
	}
	
	override public function onUpdate(tpf:Float):Void
	{
		if (spatial != null)
		{
			value += FastMath.fmin(tpf * speed / duration, 1.0);
			
			var scale:Vector3f = startScale.interpolate(endScale, value);
			spatial.setLocalScale(scale);
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