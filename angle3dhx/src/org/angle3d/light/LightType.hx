package org.angle3d.light;

/**
 * Describes the light type.
 */
class LightType 
{
	/**
     * Directional light
     * 
     * @see DirectionalLight
     */
    public static inline var Directional:Int = 0;
	/**
     * Point light
     * 
     * @see PointLight
     */
	public static inline var Point:Int = 0;
	/**
     * Spot light.
     * <p>
     * Not supported by jMonkeyEngine
     */
	public static inline var Spot:Int = 0;
}