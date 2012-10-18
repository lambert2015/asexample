package org.angle3d.effect.gpu
{
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.Spatial;
	import org.angle3d.scene.control.Control;
	
	/**
	 * ...
	 * @author andy
	 */
	public class ParticleSystemControl implements Control
	{
		private var particleSystem : ParticleSystem;
		private var _enabled:Boolean;
		
		public function ParticleSystemControl(particleSystem : ParticleSystem)
		{
			this.particleSystem = particleSystem;
			_enabled = true;
		}
		
		public function cloneForSpatial(spatial : Spatial) : Control
		{
			return this;
		}
		
		public function set spatial(spatial : Spatial) : void
		{
			
		}
		
		public function get spatial() : Spatial
		{
			return null;
		}
		
		public function set enabled(enabled : Boolean) : void
		{
			_enabled = enabled;
		}
		
		public function get enabled() : Boolean
		{
			return _enabled;
		}
		
		public function update(tpf : Number) : void
		{
			if(!_enabled)
				return;
			
			particleSystem.updateFromControl(tpf);
		}
		
		public function render(rm : RenderManager, vp : ViewPort) : void
		{
		}
	}
}

