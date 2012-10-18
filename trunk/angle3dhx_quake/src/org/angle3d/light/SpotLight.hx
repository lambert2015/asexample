package org.angle3d.light;
import org.angle3d.math.Vector3f;
import org.angle3d.bounding.BoundingVolume;
import org.angle3d.math.FastMath;
import org.angle3d.scene.Spatial;
import org.angle3d.utils.Assert;

/**
 * Represents a spot light.
 * A spot light emmit a cone of light from a position and in a direction.
 * It can be used to fake torch lights or car's lights.
 * <p>
 * In addition to a position and a direction, spot lights also have a range which 
 * can be used to attenuate the influence of the light depending on the 
 * distance between the light and the effected object.
 * Also the angle of the cone can be tweaked by changing the spot inner angle and the spot outer angle.
 * the spot inner angle determin the cone of light where light has full influence.
 * the spot outer angle determin the cone global cone of light of the spot light.
 * the light intensity slowly decrease between the inner cone and the outer cone.
 *  @author Nehon
 */
class SpotLight extends Light
{
	private var position:Vector3f;
	private var direction:Vector3f;
	
	private var spotInnerAngle:Float;
	private var spotOuterAngle:Float;
	private var spotRange:Float;
	private var invSpotRange:Float;
	private var packedAngleCos:Float;

	public function new() 
	{
		super();
		
		position = new Vector3f();
		direction = new Vector3f(0, -1, 0);
		
		spotInnerAngle = FastMath.PI / (4 * 8);
		spotOuterAngle = FastMath.PI / (4 * 6);
		spotRange = 100;
		invSpotRange = 1 / 100;
		packedAngleCos = 0;
		computePackedCos();
	}
	
	private function computePackedCos():Void
	{
        var innerCos:Float = Math.cos(spotInnerAngle);
        var outerCos:Float = Math.cos(spotOuterAngle);
        packedAngleCos = Std.int(innerCos * 1000);
        packedAngleCos += outerCos;
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
	
	override public function getType():Int
	{
		return LightType.Spot;
	}
	
	public function getDirection():Vector3f
	{
        return direction;
    }
	
	public function setDirection(direction:Vector3f):Void
	{
        this.direction.copyFrom(direction);
    }
	
	public function getPosition():Vector3f
	{
        return position;
    }
	
	public function setPosition(position:Vector3f):Void
	{
        this.position.copyFrom(position);
    }
	
	public function getSpotRange():Float
	{
        return spotRange;
    }
	
	/**
     * Set the range of the light influence.
     * <p>
     * Setting a non-zero range indicates the light should use attenuation.
     * If a pixel's distance to this light's position
     * is greater than the light's range, then the pixel will not be
     * effected by this light, if the distance is less than the range, then
     * the magnitude of the influence is equal to distance / range.
     * 
     * @param spotRange the range of the light influence.
     * 
     * @throws IllegalArgumentException If spotRange is negative
     */
	public function setSpotRange(spotRange:Float):Void
	{
        Assert.assert(spotRange >= 0,"SpotLight range cannot be negative");
		
		this.spotRange = spotRange;
        if (spotRange != 0) 
		{
            invSpotRange = 1 / spotRange;
        } 
		else 
		{
            invSpotRange = 0;
        }
    }
	
	/**
     * for internal use only
     * @return the inverse of the spot range
     */
	public function getInvSpotRange():Float
	{
        return invSpotRange;
    }
	
	/**
     * returns the spot inner angle
     * @return the spot inner angle
     */
	public function getSpotInnerAngle():Float
	{
        return spotInnerAngle;
    }
	
	/**
     * Sets the inner angle of the cone of influence.
     * This angle is the angle between the spot direction axis and the inner border of the cone of influence.
     * @param spotInnerAngle 
     */
	public function setSpotInnerAngle(spotInnerAngle:Float):Void
	{
		this.spotInnerAngle = spotInnerAngle;
        computePackedCos();
	}
	
	/**
     * returns the spot outer angle
     * @return the spot outer angle
     */
	public function getSpotOuterAngle():Float
	{
        return spotOuterAngle;
    }
	
	/**
     * Sets the outer angle of the cone of influence.
     * This angle is the angle between the spot direction axis and the outer border of the cone of influence.
     * this should be greater than the inner angle or the result will be unexpected.
     * @param spotOuterAngle 
     */
	public function setSpotOuterAngle(spotOuterAngle:Float):Void
	{
		this.spotOuterAngle = spotOuterAngle;
        computePackedCos();
	}
	
	/**
     * for internal use only
     * @return the cosines of the inner and outter angle packed in a float
     */
	public function getPackedAngleCos():Float
	{
        return packedAngleCos;
    }
}