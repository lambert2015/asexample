package org.angle3d.scene.control;

/**
 * Determines how the billboard is aligned to the screen/camera.
 */
class Alignment 
{

	/**
     * Aligns this Billboard to the screen.
     */
    public static inline var Screen:String = "screen";

    /**
     * Aligns this Billboard to the camera position.
     */
    public static inline var Camera:String = "camera";

    /**
     * Aligns this Billboard to the screen, but keeps the Y axis fixed.
     */
    public static inline var AxialY:String = "axialy";

    /**
     * Aligns this Billboard to the screen, but keeps the Z axis fixed.
     */
    public static inline var AxialZ:String = "axialz";
	
}