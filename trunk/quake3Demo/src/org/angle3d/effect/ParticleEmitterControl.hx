package org.angle3d.effect;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.control.Control;
import org.angle3d.scene.Spatial;

/**
 * ...
 * @author andy
 */

class ParticleEmitterControl implements Control
{
	private var parentEmitter:ParticleEmitter;

	public function new(parentEmitter:ParticleEmitter) 
	{
		this.parentEmitter = parentEmitter;
	}
	
	public function cloneForSpatial(spatial:Spatial):Control
	{
		return this;
	}
	
	public function setSpatial(spatial:Spatial):Void
	{
		
	}
	
	public function setEnabled(enabled:Bool):Void
	{
		parentEmitter.setEnabled(enabled);
	}
	
	public function isEnabled():Bool
	{
		return parentEmitter.isEnabled();
	}
	
	public function update(tpf:Float):Void
	{
        parentEmitter.updateFromControl(tpf);
    }

    public function render(rm:RenderManager,vp:ViewPort) 
	{
        parentEmitter.renderFromControl(rm, vp);
    }
	
}