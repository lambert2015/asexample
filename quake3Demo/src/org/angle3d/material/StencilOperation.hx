package org.angle3d.material;

/**
 * <code>StencilOperation</code> specifies the stencil operation to use
 * in a certain scenario 
 */
class StencilOperation 
{
    /**
     * Keep the current value.
     */
    public static inline var Keep:Int = 0;
    /**
     * Set the value to 0
     */
    public static inline var Zero:Int = 1;
    /**
     * Replace the value in the stencil buffer with the reference value.
     */
    public static inline var Replace:Int = 2;
        
    /**
     * Increment the value in the stencil buffer, clamp once reaching
     * the maximum value.
     */
    public static inline var Increment:Int = 3;
        
    /**
     * Increment the value in the stencil buffer and wrap to 0 when 
     * reaching the maximum value.
     */
    public static inline var IncrementWrap:Int = 4;
    /**
     * Decrement the value in the stencil buffer and clamp once reaching 0.
     */
    public static inline var Decrement:Int = 5;
    /**
     * Decrement the value in the stencil buffer and wrap to the maximum
     * value when reaching 0.
     */
    public static inline var DecrementWrap:Int = 6;
        
    /**
     * Does a bitwise invert of the value in the stencil buffer.
     */
    public static inline var Invert:Int = 7;
	
}