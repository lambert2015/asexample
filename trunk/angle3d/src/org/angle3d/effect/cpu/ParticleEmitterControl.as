package org.angle3d.effect.cpu
{
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.control.Control;
	import org.angle3d.scene.Spatial;

	/**
	 * ...
	 * @author andy
	 */
	public class ParticleEmitterControl implements Control
	{
		private var particleEmitter:ParticleEmitter;

		public function ParticleEmitterControl(parentEmitter:ParticleEmitter)
		{
			this.particleEmitter=parentEmitter;
		}

		public function cloneForSpatial(spatial:Spatial):Control
		{
			return this;
		}

		public function set spatial(spatial:Spatial):void
		{

		}

		public function get spatial():Spatial
		{
			return null;
		}

		public function set enabled(enabled:Boolean):void
		{
			particleEmitter.enabled=enabled;
		}

		public function get enabled():Boolean
		{
			return particleEmitter.enabled;
		}

		public function update(tpf:Number):void
		{
			particleEmitter.updateFromControl(tpf);
		}

		public function render(rm:RenderManager, vp:ViewPort):void
		{
			particleEmitter.renderFromControl(rm, vp);
		}

		public function clone():Control
		{
			return new ParticleEmitterControl(this.particleEmitter);
		}
	}
}

