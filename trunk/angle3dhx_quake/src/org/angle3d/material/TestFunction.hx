package org.angle3d.material;

/**
 * <code>TestFunction</code> specifies the testing function for stencil test
 * function and alpha test function.
 * 
 * <p>The functions work similarly as described except that for stencil
 * test function, the reference value given in the stencil command is 
 * the input value while the reference is the value already in the stencil
 * buffer.
 */
class TestFunction 
{

	/**
     * The test always fails
     */
    public static inline var Never:Int = -1;
    /**
     * The test succeeds if the input value is equal to the reference value.
     */
    public static inline var Equal:Int = 0;
    /**
     * The test succeeds if the input value is less than the reference value.
     */
    public static inline var Less:Int = 1;
    /**
     * The test succeeds if the input value is less than or equal to 
     * the reference value.
     */
    public static inline var LessOrEqual:Int = 2;
    /**
     * The test succeeds if the input value is greater than the reference value.
     */
    public static inline var Greater:Int = 3;
    /**
     * The test succeeds if the input value is greater than or equal to 
     * the reference value.
     */
    public static inline var GreaterOrEqual:Int = 4;
    /**
     * The test succeeds if the input value does not equal the
     * reference value.
     */
    public static inline var NotEqual:Int = 5;
    /**
     * The test always passes
     */
    public static inline var Always:Int = 6;
}