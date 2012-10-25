package away3d.animators
{
	import away3d.animators.nodes.*;
	import away3d.core.managers.*;
	import away3d.materials.passes.*;

	/**
	 * Provides an interface for data set classes that hold animation data for use in animator classes.
	 *
	 * @see away3d.animators.IAnimator
	 */
	public interface IAnimationSet
	{
		/**
		 * Check to determine whether a state is registered in the animation set under the given name.
		 *
		 * @param stateName The name of the animation state object to be checked.
		 */
		function hasAnimation(name:String):Boolean;

		/**
		 * Retrieves the animation state object registered in the animation data set under the given name.
		 *
		 * @param stateName The name of the animation state object to be retrieved.
		 */
		function getAnimation(name:String):AnimationNodeBase;

		/**
		 * Indicates whether the properties of the animation data contained within the set combined with
		 * the vertex registers aslready in use on shading materials allows the animation data to utilise
		 * GPU calls.
		 */
		function get usesCPU():Boolean;

		/**
		 * Called by the material to reset the GPU indicator before testing whether register space in the shader
		 * is available for running GPU-based animation code.
		 *
		 * @private
		 */
		function resetGPUCompatibility():void;

		function cancelGPUCompatibility():void;

		/**
		 * Generates the AGAL Vertex code for the animation, tailored to the material pass's requirements.
		 * @param pass The MaterialPassBase object to whose vertex code the animation's code will be prepended.
		 * @return The AGAL Vertex code that animates the vertex data.
		 *
		 * @private
		 */
		function getAGALVertexCode(pass:MaterialPassBase, sourceRegisters:Array, targetRegisters:Array):String;

		/**
		 * Sets the GPU render state required by the animation that is independent of the rendered mesh.
		 * @param context The context which is currently performing the rendering.
		 * @param pass The material pass which is currently used to render the geometry.
		 *
		 * @private
		 */
		function activate(stage3DProxy:Stage3DProxy, pass:MaterialPassBase):void

		/**
		 * Clears the GPU render state that has been set by the current animation.
		 * @param context The context which is currently performing the rendering.
		 * @param pass The material pass which is currently used to render the geometry.
		 *
		 * @private
		 */
		function deactivate(stage3DProxy:Stage3DProxy, pass:MaterialPassBase):void
	}
}
