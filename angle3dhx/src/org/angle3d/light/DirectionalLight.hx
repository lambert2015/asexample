package org.angle3d.light;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Spatial;

/**
 * <code>DirectionalLight</code> is a light coming from a certain direction in world space. 
 * E.g sun or moon light.
 * <p>
 * Directional lights have no specific position in the scene, they always 
 * come from their direction regardless of where an object is placed.
 */
class DirectionalLight extends Light
{
    private var direction:Vector3f;
	
	public function new() 
	{
		super();
		direction = new Vector3f(0, -1, 0);
	}
	
	/**
     * Returns the direction vector of the light.
     * 
     * @return The direction vector of the light.
     * 
     * @see DirectionalLight#setDirection(org.angle3d.math.Vector3f) 
     */
	public function getDirection():Vector3f
	{
		return direction;
	}
	
	/**
     * Sets the direction of the light.
     * <p>
     * Represents the vector direction the light is coming from.
     * (1, 0, 0) would represent a directional light coming from the X axis.
     * 
     * @param dir the direction of the light.
     */
	public function setDirection(dir:Vector3f):Void
	{
		direction.copyFrom(dir);
		direction.normalizeLocal();
	}
	
	override public function computeLastDistance(owner:Spatial):Void
	{
		lastDistance = 0; // directional lights are always closest to their owner
	}
	
	override public function getType():Int
	{
		return LightType.Directional;
	}
	
}