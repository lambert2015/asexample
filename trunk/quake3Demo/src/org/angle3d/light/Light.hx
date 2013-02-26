package org.angle3d.light;
import org.angle3d.math.Color;
import org.angle3d.scene.Spatial;
import org.angle3d.utils.Cloneable;

/**
 * Abstract class for representing a light source.
 * <p>
 * All light source types have a color.
 */

class Light implements Cloneable
{
    private var color:Color;
    
    /**
     * Used in LightList for caching the distance 
     * to the owner spatial. Should be reset after the sorting.
     */
    private var lastDistance:Float;

    /**
     * If light is disabled, it will not take effect.
     */
    private var enabled:Bool;

    /** 
     * The light name. 
     */
    private var name:String;
	
	public function new() 
	{
		color = new Color(1, 1, 1, 1);
		lastDistance = -1;
		enabled = true;
		name = "";
	}
	
	/**
     * This method sets the light name.
     * 
     * @param name the light name
     */
	public function setName(name:String):Void
	{
		this.name = name;
	}
	
	/**
     * Return the light name.
     * 
     * @return the light name
     */
	public function getName():String
	{
		return name;
	}

	/**
     * Returns true if the light is enabled
     * 
     * @return true if the light is enabled
     * 
     * @see Light#setEnabled(boolean)
     */
	public function isEnabled():Bool
	{
		return enabled;
	}
	
	/**
     * Sets the light color.
     * 
     * @param color the light color.
     */
	public function setColor(color:Color):Void
	{
		this.color.copyFrom(color);
	}
	
	public function getColor():Color
	{
		return color;
	}
	
	public function setLastDistance(value:Float):Void
	{
		lastDistance = value;
	}
	
	public function getLastDistance():Float
	{
		return lastDistance;
	}
	
	/**
     * Used internally to compute the last distance value.
     */
	public function computeLastDistance(owner:Spatial):Void
	{
		
	}
	
	/**
     * Returns the light type
     * 
     * @return the light type
     * 
     * @see Type
     */
	public function getType():Int
	{
		return LightType.None;
	}
	
	public function toString():String
	{
		return name;
	}
	
}