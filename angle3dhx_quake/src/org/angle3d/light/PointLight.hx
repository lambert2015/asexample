package org.angle3d.light;
import org.angle3d.math.Vector3f;
import org.angle3d.bounding.BoundingVolume;
import org.angle3d.scene.Spatial;
import org.angle3d.utils.Assert;

/**
 * Represents a point light.
 * A point light emits light from a given position into all directions in space.
 * E.g a lamp or a bright effect. Point light positions are in world space.
 * <p>
 * In addition to a position, point lights also have a radius which 
 * can be used to attenuate the influence of the light depending on the 
 * distance between the light and the effected object.
 * 
 */
class PointLight extends Light
{
    private var position:Vector3f;
	private var radius:Float;
	private var invRadius:Float;
	
	public function new() 
	{
		super();
		position = new Vector3f();
		radius = 0;
		invRadius = 0;
	}
	
	/**
     * Returns the world space position of the light.
     * 
     * @return the world space position of the light.
     * 
     * @see PointLight#setPosition(org.angle3d.math.Vector3f) 
     */
	public function getPosition():Vector3f
	{
        return position;
    }

	/**
     * Set the world space position of the light.
     * 
     * @param position the world space position of the light.
     */
    public function setPosition(position:Vector3f):Void
	{
        this.position.copyFrom(position);
    }

	/**
     * Returns the radius of the light influence. A radius of 0 means
     * the light has no attenuation.
     * 
     * @return the radius of the light
     */
    public function getRadius():Float
	{
        return radius;
    }

	/**
     * Set the radius of the light influence.
     * <p>
     * Setting a non-zero radius indicates the light should use attenuation.
     * If a pixel's distance to this light's position
     * is greater than the light's radius, then the pixel will not be
     * effected by this light, if the distance is less than the radius, then
     * the magnitude of the influence is equal to distance / radius.
     * 
     * @param radius the radius of the light influence.
     * 
     * @throws IllegalArgumentException If radius is negative
     */
    public function setRadius(radius:Float):Void
	{
        Assert.assert(radius >= 0, "Light radius cannot be negative");

        this.radius = radius;
		if (radius != 0)
		{
            invRadius = 1 / radius;
        }
		else
		{
            invRadius = 0;
        }
    }
	
	override public function computeLastDistance(owner:Spatial):Void
	{
		if (owner.getWorldBound() != null)
		{
			var bv:BoundingVolume = owner.getWorldBound();
			lastDistance = bv.distanceSquaredTo(position);
		}
		else
		{
			lastDistance = owner.getWorldTranslation().distanceSquared(position);
		}
	}
	
	/**
     * for internal use only
     * @return the inverse of the radius
     */
	public function getInvRadius():Float
	{
        return invRadius;
    }
	
	override public function getType():Int
	{
		return LightType.Point;
	}
	
}