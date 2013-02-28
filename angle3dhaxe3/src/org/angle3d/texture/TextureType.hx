package org.angle3d.texture;

class TextureType
{
	/**
	 * Two dimensional texture (default). A rectangle.
	 */
	public static inline var TwoDimensional:Int = 0;

	/**
	 * Three dimensional texture. (A cube)
	 */
	public static inline var ThreeDimensional:Int = 1;

	/**
	 * A set of 6 TwoDimensional textures arranged as faces of a cube facing
	 * inwards.
	 */
	public static inline var CubeMap:Int = 2;
}

