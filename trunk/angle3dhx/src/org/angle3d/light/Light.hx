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
    private var _color:Color;
	public var color(__getColor, __setColor):UInt;
	
	/**
	 * 所有灯光都应该有个范围，超过范围的灯光就不起作用
	 */
	private var radius:Float;
    
    /**
     * Used in LightList for caching the distance 
     * to the owner spatial. Should be reset after the sorting.
     */
    public var lastDistance:Float;

    /**
     * If light is disabled, it will not take effect.
     */
    private var _enabled:Bool;
	public var enabled(__getEnabled, __setEnabled):Bool;
	
	public var intensity(__getIntensity, __setIntensity):Float;

	public function new() 
	{
		lastDistance = -1;
		
		_color = new Color(1, 1, 1, 1);
		_enabled = true;
	}

	/**
     * Returns true if the light is enabled
     * 
     * @return true if the light is enabled
     * 
     * @see Light#setEnabled(boolean)
     */
	private function __getEnabled():Bool
	{
		return _enabled;
	}
	
	private function __setEnabled(value:Bool):Bool
	{
		_enabled = value;
		return _enabled;
	}
	
	/**
	 * Intensity of the light. Allowed values are between 0-1, from dark to light sequentially.
	 * @return Intensity of the light source.
	 *
	 */
	public function __setIntensity(value:Float):Float
	{
		_color.a = value;
		return value;
	}
	
	public function __getIntensity():Float
	{
		return _color.a;
	}
	
	/**
     * Sets the light color.
     * 
     * @param color the light color.
     */
	public function __setColor(color:UInt):UInt
	{
		_color.setRGB(color);
		return color;
	}
	
	public function __getColor():UInt
	{
		return _color.getColor();
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
		return -1;
	}
}