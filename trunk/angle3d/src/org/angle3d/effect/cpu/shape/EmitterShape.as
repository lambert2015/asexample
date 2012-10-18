package org.angle3d.effect.cpu.shape
{
	import org.angle3d.math.Vector3f;

	/**
	 * This public interface declares methods used by all shapes that represent particle emitters.
	 * @author Kirill
	 */
	public interface EmitterShape
	{

		/**
		 * This method fills in the initial position of the particle.
		 * @param store
		 *        store variable for initial position
		 */
		function getRandomPoint(store:Vector3f):void;

		/**
		 * This method fills in the initial position of the particle and its normal vector.
		 * @param store
		 *        store variable for initial position
		 * @param normal
		 *        store variable for initial normal
		 */
		function getRandomPointAndNormal(store:Vector3f, normal:Vector3f):void;

		/**
		 * This method creates a deep clone of the current instance of the emitter shape.
		 * @return deep clone of the current instance of the emitter shape
		 */
		function clone():EmitterShape;
	}
}

