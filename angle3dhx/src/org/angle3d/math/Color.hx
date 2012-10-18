package org.angle3d.math;
import flash.Vector;
import org.angle3d.utils.Assert;

/**
 * <code>Color</code> defines a color made from a collection of
 * red, green and blue values. An alpha value determines is transparency.
 * All values must be between 0 and 1. If any value is set higher or lower
 * than these constraints they are clamped to the min or max. That is, if
 * a value smaller than zero is set the value clamps to zero. If a value
 * higher than 1 is passed, that value is clamped to 1. However, because the
 * attributes r, g, b, a are public for efficiency reasons, they can be
 * directly modified with invalid values. The client should take care when
 * directly addressing the values. A call to clamp will assure that the values
 * are within the constraints.
 * @author andy
 */
class Color
{
	/**
     * the color black (0,0,0).
     */
    public static inline var Black:Color = new Color(0, 0, 0, 1);
	
	/**
     * the color black (0,0,0).
     */
    public static inline var BlackNoAlpha:Color = new Color(0, 0, 0, 0);
	
    /**
     * the color white (1,1,1).
     */
    public static inline var White:Color = new Color(1, 1, 1, 1);
    /**
     * the color gray (.2,.2,.2).
     */
    public static inline var DarkGray:Color = new Color(0.2, 0.2, 0.2, 1.0);
    /**
     * the color gray (.5,.5,.5).
     */
    public static inline var Gray:Color = new Color(0.5, 0.5, 0.5, 1.0);
    /**
     * the color gray (.8,.8,.8).
     */
    public static inline var LightGray:Color = new Color(0.8, 0.8, 0.8, 1.0);
    /**
     * the color red (1,0,0).
     */
    public static inline var Red:Color = new Color(1, 0, 0, 1);
    /**
     * the color green (0,1,0).
     */
    public static inline var Green:Color = new Color(0, 1, 0, 1);
    /**
     * the color blue (0,0,1).
     */
    public static inline var Blue:Color = new Color(0, 0, 1, 1);
    /**
     * the color yellow (1,1,0).
     */
    public static inline var Yellow:Color = new Color(1, 1, 0, 1);
    /**
     * the color magenta (1,0,1).
     */
    public static inline var Magenta:Color = new Color(1, 0, 1, 1);
    /**
     * the color cyan (0,1,1).
     */
    public static inline var Cyan:Color = new Color(0, 1, 1, 1);
    /**
     * the color orange (251/255, 130/255,0).
     */
    public static inline var Orange:Color = new Color(251/255, 130/255, 0, 1);
    /**
     * the color brown (65/255, 40/255, 25/255).
     */
    public static inline var Brown:Color = new Color(65/255, 40/255, 25/255, 1);
    /**
     * the color pink (1, 0.68, 0.68).
     */
    public static inline var Pink:Color = new Color(1, 0.68, 0.68, 1);

	/**
     * The red component of the color.
     */
	public var r : Float;
	/**
     * The green component of the color.
     */
	public var g : Float;
	/**
     * the blue component of the color.
     */
	public var b : Float;
	/**
     * the alpha component of the color.  0 is transparent and 1 is opaque
     */
	public var a : Float;

	/**
     * Constructor instantiates a new <code>Color</code> object. The
     * values are defined as passed parameters. These values are then clamped
     * to insure that they are between 0 and 1.
     * @param r the red component of this color.
     * @param g the green component of this color.
     * @param b the blue component of this color.
     * @param a the alpha component of this color.
     */
	public function new(r : Float = 0.0, g : Float = 0.0, b : Float = 0.0, a : Float = 1.0)
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
	
	public inline function setTo(r : Float, g : Float, b : Float, a : Float = 1.0) : Void
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
	
	public inline function add(value:Color, result:Color = null) : Color
	{
		if (result == null)
		    result  = new Color();
		result.r = r + value.r;
		result.g = g + value.g;
		result.b = b + value.b;
		result.a = a + value.a;
		return result;
	}
	
	public inline function addLocal(value:Color) : Void
	{
		this.r += value.r;
		this.g += value.g;
		this.b += value.b;
		this.a += value.a;
	}
	
	public inline function toUniform(result:Vector<Float> = null):Vector<Float>
	{
		if (result == null)
		{
			result = new Vector<Float>(4, true);
		}
		
		result[0] = r;
		result[1] = g;
		result[2] = b;
		result[3] = a;
		return result;
	}
	
	public inline function getColor() : UInt
	{
		return(Std.int(a * 255) << 24 | Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255));
	}
	
	public inline function setColor(color : UInt) : Void
	{
		var invert:Float = 1.0 / 255;
		a = (color >> 24 & 0xFF) * invert;
		r = (color >> 16 & 0xFF) * invert;
		g = (color >> 8 & 0xFF) * invert;
		b = (color & 0xFF) * invert;
	}
	
	public inline function setRGB(color:UInt):Void
	{
		var invert:Float = 1.0 / 255;
		r = (color >> 16 & 0xFF) * invert;
		g = (color >> 8 & 0xFF) * invert;
		b = (color & 0xFF) * invert;
	}
	
	public inline function clone() : Color
	{
		return new Color(r, g, b, a);
	}
	
	public inline function copyFrom(other : Color) : Void
	{
		setTo(other.r, other.g, other.b, other.a);
	}
	
	public inline function equals(other:Color):Bool
	{
		Assert.assert(other != null, "param can not be null");

		return r == other.r && g == other.g && b == other.b && a == other.a;
	}
	
	public inline function interpolate(beginColor : Color, finalColor:Color, p : Float) : Void
	{
		var p1 : Float = 1 - p;

		this.r = p1 * beginColor.r + p * finalColor.r;
        this.g = p1 * beginColor.g + p * finalColor.g;
        this.b = p1 * beginColor.b + p * finalColor.b;
        this.a = p1 * beginColor.a + p * finalColor.a;
	}
	
	public function toString() : String
	{
		return "[Color(" + r + "," + g + "," + b + "," + a + ")]";
	}
}
