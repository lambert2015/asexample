package org.angle3d.effect.gpu;

import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.Spatial;
import org.angle3d.scene.control.Control;

/**
 * ...
 * @author andy
 */
class ParticleSystemControl implements Control
{
	private var particleSystem:ParticleSystem;
	private var _enabled:Bool;

	public function new(particleSystem:ParticleSystem)
	{
		this.particleSystem = particleSystem;
		_enabled = true;
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
		_enabled = enabled;
	}

	public function get enabled():Bool
	{
		return _enabled;
	}

	public function update(tpf:Float):Void
	{
		if (!_enabled)
			return;

		particleSystem.updateFromControl(tpf);
	}

	public function render(rm:RenderManager, vp:ViewPort):Void
	{
	}

	public function clone():Control
	{
		return new ParticleSystemControl(this.particleSystem);
	}
}

