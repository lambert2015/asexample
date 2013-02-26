package org.angle3d.light;

/**
 * Describes the light type.
 */
class LightType 
{
	public static inline var None:Int = -1;
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
	public static inline var Point:Int = 1;
	/**
     * Spot light.
     * <p>
     * Not supported by jMonkeyEngine
     */
	public static inline var Spot:Int = 2;
	/**
     * Ambient light
     * 
     * @see AmbientLight
     */
	public static inline var Ambient:Int = 3;
}