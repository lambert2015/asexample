package org.angle3d.particles
{

	/**
	 * A ParticleSystem is the most top level of a particle structure, that consists of Particles, ParticleEmitters,
	 * ParticleAffectors, ParticleObservers, etc.
	 * The ParticleSystem can be seen as the container that includes the components that are needed to create,
	 * display and move particles.
	 */
	public class ParticleSystem
	{
		private var _techniques:Vector.<ParticleTechnique>;
		private var _numTechniques:int;

		public function ParticleSystem()
		{
			_techniques = new Vector.<ParticleTechnique>();
			_numTechniques = 0;
		}

		public function addTechnique(technique:ParticleTechnique):void
		{
			_techniques.push(technique);
			_numTechniques++;
		}

		public function removeTechnique(technique:ParticleTechnique):void
		{
			var index:int = _techniques.indexOf(technique);
			if (index > -1)
			{
				_techniques.splice(index, 1);
				_numTechniques--;
			}
		}

		public function getTechniqueAt(index:int):ParticleTechnique
		{
			return _techniques[index];
		}

		public function getTechnique(name:String):ParticleTechnique
		{
			for (var i:int = 0; i < _numTechniques; i++)
			{
				if (_techniques[i].name == name)
				{
					return _techniques[i];
				}
			}
			return null;
		}

		public function get numTechniques():int
		{
			return _numTechniques;
		}

		public function destroyTechnique(technique:ParticleTechnique):void
		{

		}

		public function destroyAllTechniques():void
		{

		}

		public function prepare():void
		{

		}

		/**
		 * Starts the particle system and stops after a period of time.
		 */
		public function start(stopTime:int = -1):void
		{

		}

		/**
		 * Stops the particle system.
		 * Only if a particle system has been attached to a SceneNode and started it can be stopped.
		 */
		public function stop():void
		{

		}

		public function pause():void
		{

		}

		public function resume():void
		{

		}
	}
}
