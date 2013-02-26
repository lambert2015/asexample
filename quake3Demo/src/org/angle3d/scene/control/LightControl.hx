package org.angle3d.scene.control;
import org.angle3d.light.DirectionalLight;
import org.angle3d.light.Light;
import org.angle3d.light.PointLight;
import org.angle3d.light.SpotLight;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.Spatial;
import org.angle3d.math.Vector3f;
import flash.Lib;

/**
 * This Control maintains a reference to a Light
 * @author tim
 */
class LightControl extends AbstractControl
{
	/**
     * Means, that the Light's transform is "copied"
     * to the Transform of the Spatial.
     */
    public static inline var LightToSpatial:String = "lightToSpatial";
    /**
     * Means, that the Spatial's transform is "copied"
     * to the Transform of the light.
     */
    public static inline var SpatialToLight:String = "spatialToLight";
	
	private var light:Light;
	private var controlDir:String;

	public function new(light:Light = null, controlDir:String = "spatialToLight") 
	{
		super();
		
		if (light != null)
		{
			this.light = light;
		}
		
		this.controlDir = controlDir;
	}
	
	public function setControlDir(dir:String):Void
	{
		this.controlDir = dir;
	}
	
	public function setLight(light:Light):Void
	{
		if (light == null)
		{
			return;
		}
		this.light = light;
	}
	
	public function getLight():Light
	{
		return light;
	}
	
	public function getControlDir():String
	{
		return controlDir;
	}
	
	override private function controlUpdate(tpf:Float):Void
	{
		if (spatial != null && light != null)
		{
			switch(controlDir)
			{
				case SpatialToLight:
					_spatialToLight(light);
				case LightToSpatial:
					_lightToSpatial(light);
			}
		}
	}
	
	private function _spatialToLight(light:Light):Void
	{
		if (Std.is(light, PointLight))
		{
			var pl:PointLight = Lib.as(light, PointLight);
			pl.setPosition(spatial.getWorldTranslation());
		}
		
		if (Std.is(light, DirectionalLight))
		{
			var pl:DirectionalLight = Lib.as(light, DirectionalLight);
			//TODO 这里是不是传错了
			var p:Vector3f = pl.getDirection();
			p.copyFrom(spatial.getWorldTranslation());
			//p.scaleBy( -1);
		}
		
		//TODO add code for Spot light here when it's done
        //if (Std.is(light, SpotLight))
		//{
			//var sp:SpotLight = Lib.as(light, SpotLight);
			//sp.setPosition(spatial.getWorldTranslation());
			//sp.setRotation(spatial.getWorldRotation());
		//}
	}
	
	private function _lightToSpatial(light:Light):Void
	{
		if (Std.is(light, PointLight))
		{
			var pLight:PointLight = Lib.as(light, PointLight);
			
			var vecDiff:Vector3f = pLight.getPosition().subtract(spatial.getWorldTranslation());
			vecDiff.addLocal(spatial.getLocalTranslation());
			spatial.setLocalTranslation(vecDiff);
		}
		
		if (Std.is(light, DirectionalLight))
		{
			var dLight:DirectionalLight = Lib.as(light, DirectionalLight);
			var vecDiff:Vector3f = dLight.getDirection().clone();
			vecDiff.scaleLocal( -1);
			vecDiff.subtractLocal(spatial.getWorldTranslation());
			vecDiff.addLocal(spatial.getLocalTranslation());
			spatial.setLocalTranslation(vecDiff);
		}
	}
	
	override private function controlRender(rm:RenderManager, vp:ViewPort):Void
	{
		
	}
	
	override public function cloneForSpatial(newSpatial:Spatial):Control
	{
		var control:LightControl = new LightControl(this.light,this.controlDir);
		control.setSpatial(newSpatial);
		control.setEnabled(isEnabled());
		return control;
	}
}