package org.angle3d.material;

/**
 * <code>BlendMode</code> specifies the blending operation to use.
 * 
 * @see RenderState#setBlendMode(org.angle3d.material.RenderState.BlendMode) 
 */
class BlendMode 
{

	/**
     * No blending mode is used.
     */
    public static inline var Off:Int = -1;
    /**
     * Additive blending. For use with glows and particle emitters.
     * <p>
     * Result = Source Color + Destination Color
     */
    public static inline var Additive:Int = 0;
    /**
     * Premultiplied alpha blending, for use with premult alpha textures.
     * <p>
     * Result = Source Color + (Dest Color * (1 - Source Alpha) )
     */
    public static inline var PremultAlpha:Int = 1;
    /**
     * Additive blending that is multiplied with source alpha.
     * For use with glows and particle emitters.
     * <p>
     * Result = (Source Alpha * Source Color) + Dest Color
     */
    public static inline var AlphaAdditive:Int = 2;
    /**
     * Color blending, blends in color from dest color
     * using source color.
     * <p>
     * Result = Source Color + (1 - Source Color) * Dest Color
     */
    public static inline var Color:Int = 3;
    /**
     * Alpha blending, interpolates to source color from dest color
     * using source alpha.
     * <p>
     * Result = Source Alpha * Source Color +
     *          (1 - Source Alpha) * Dest Color
     */
    public static inline var Alpha:Int = 4;
    /**
     * Multiplies the source and dest colors.
     * <p>
     * Result = Source Color * Dest Color
     */
    public static inline var Modulate:Int = 5;
    /**
     * Multiplies the source and dest colors then doubles the result.
     * <p>
     * Result = 2 * Source Color * Dest Color
     */
    public static inline var ModulateX2:Int = 6;
	
}