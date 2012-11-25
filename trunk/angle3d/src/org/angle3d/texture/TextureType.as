package org.angle3d.texture
{

	public class TextureType
	{
		/**
		 * Two dimensional texture (default). A rectangle.
		 */
		public static const TwoDimensional:int = 0;

		/**
		 * Three dimensional texture. (A cube)
		 */
		public static const ThreeDimensional:int = 1;

		/**
		 * A set of 6 TwoDimensional textures arranged as faces of a cube facing
		 * inwards.
		 */
		public static const CubeMap:int = 2;
	}
}
