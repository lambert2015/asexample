package org.angle3d.material
{

	/**
	 * <code>BlendMode</code> specifies the blending operation to use.
	 *
	 * @see RenderState#setBlendMode(org.angle3d.material.RenderState.BlendMode)
	 */
	public class BlendMode
	{

		/**
		 * No blending mode is used.
		 */
		public static const Off:int = 0;
		/**
		 * Additive blending. For use with glows and particle emitters.
		 * <p>
		 * Result = Source Color + Destination Color
		 */
		public static const Additive:int = 1;
		/**
		 * Premultiplied alpha blending, for use with premult alpha textures.
		 * <p>
		 * Result = Source Color + (Dest Color * (1 - Source Alpha) )
		 */
		public static const PremultAlpha:int = 2;
		/**
		 * Additive blending that is multiplied with source alpha.
		 * For use with glows and particle emitters.
		 * <p>
		 * Result = (Source Alpha * Source Color) + Dest Color
		 */
		public static const AlphaAdditive:int = 3;
		/**
		 * Color blending, blends in color from dest color
		 * using source color.
		 * <p>
		 * Result = Source Color + (1 - Source Color) * Dest Color
		 */
		public static const Color:int = 4;
		/**
		 * Alpha blending, interpolates to source color from dest color
		 * using source alpha.
		 * <p>
		 * Result = Source Alpha * Source Color +
		 *          (1 - Source Alpha) * Dest Color
		 */
		public static const Alpha:int = 5;
		/**
		 * Multiplies the source and dest colors.
		 * <p>
		 * Result = Source Color * Dest Color
		 */
		public static const Modulate:int = 6;
		/**
		 * Multiplies the source and dest colors then doubles the result.
		 * <p>
		 * Result = 2 * Source Color * Dest Color
		 */
		public static const ModulateX2:int = 7;

	}
}

