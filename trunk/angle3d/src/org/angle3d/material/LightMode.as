package org.angle3d.material 
{
	/**
     * Describes light rendering mode.
     */
	public class LightMode 
	{
		
		/**
         * Disable light-based rendering
         */
        public static const Disable:int = 0;
        
        /**
         * Enable light rendering by using a single pass. 
         * <p>
         * An array of light positions and light colors is passed to the shader
         * containing the world light list for the geometry being rendered.
         */
        public static const SinglePass:int = 1;
        
        /**
         * Enable light rendering by using multi-pass rendering.
         * <p>
         * The geometry will be rendered once for each light. Each time the
         * light position and light color uniforms are updated to contain
         * the values for the current light. The ambient light color uniform
         * is only set to the ambient light color on the first pass, future
         * passes have it set to black.
         */
        public static const MultiPass:int = 2;
		
	}

}