package org.angle3d.texture
{

	/**
	 * If this texture is a depth texture (the format is Depth*) then
	 * this value may be used to compare the texture depth to the R texture
	 * coordinate.
	 */
	public class ShadowCompareMode
	{
		/**
		 * Shadow comparison mode is disabled.
		 * Texturing is done normally.
		 */
		public static const Off:int = 0;

		/**
		 * Compares the 3rd texture coordinate R to the value
		 * in this depth texture. If R <= texture value then result is 1.0,
		 * otherwise, result is 0.0. If filtering is set to bilinear or trilinear
		 * the implementation may sample the texture multiple times to provide
		 * smoother results in the range [0, 1].
		 */
		public static const LessOrEqual:int = 1;

		/**
		 * Compares the 3rd texture coordinate R to the value
		 * in this depth texture. If R >= texture value then result is 1.0,
		 * otherwise, result is 0.0. If filtering is set to bilinear or trilinear
		 * the implementation may sample the texture multiple times to provide
		 * smoother results in the range [0, 1].
		 */
		public static const GreaterOrEqual:int = 2;
	}
}
