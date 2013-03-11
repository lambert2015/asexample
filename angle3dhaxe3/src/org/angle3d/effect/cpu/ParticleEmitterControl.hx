package org.angle3d.effect.cpu;

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
	private var particleEmitter:ParticleEmitter;

	public function new(parentEmitter:ParticleEmitter)
	{
		this.particleEmitter = parentEmitter;
	}

	public function cloneForSpatial(spatial:Spatial):Control
	{
		return this;
	}

	public function set spatial(spatial:Spatial):Void
	{

	}

	public function get spatial():Spatial
	{
		return null;
	}

	public function set enabled(enabled:Bool):Void
	{
		particleEmitter.enabled = enabled;
	}

	public function get enabled():Bool
	{
		return particleEmitter.enabled;
	}

	public function update(tpf:Float):Void
	{
		particleEmitter.updateFromControl(tpf);
	}

	public function render(rm:RenderManager, vp:ViewPort):Void
	{
		particleEmitter.renderFromControl(rm, vp);
	}

	public function clone():Control
	{
		return new ParticleEmitterControl(this.particleEmitter);
	}
}

