﻿package org.angle3d.math;

import flash.Vector;
import org.angle3d.utils.Assert;

class Color
{
	/**
	 * the color black (0,0,0).
	 */
	public static var Black:Color = new Color(0, 0, 0, 1);
	
	/**
	 * the color white (1,1,1).
	 */
	public static var White:Color = new Color(1, 1, 1, 1);

	public var r:Float;

	public var g:Float;

	public var b:Float;

	public var a:Float;

	/**
	 * Constructor instantiates a new <code>Color</code> object. The
	 * values are defined as passed parameters. These values are then clamped
	 * to insure that they are between 0 and 1.
	 * @param r the red component of this color.
	 * @param g the green component of this color.
	 * @param b the blue component of this color.
	 * @param a the alpha component of this color.
	 */
	public function new(r:Float = 0.0, g:Float = 0.0, b:Float = 0.0, a:Float = 1.0)
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	
	public inline function setRGBA(r:Float, g:Float, b:Float, a:Float = 255):Void
	{
		var invert:Float = FastMath.INVERT_255();
		this.r = r * invert;
		this.g = g * invert;
		this.b = b * invert;
		this.a = a * invert;
	}

//		
	public inline function setTo(r:Float, g:Float, b:Float, a:Float = 1.0):Void
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public inline function add(value:Color, result:Color = null):Color
	{
		if (result == null)
			result = new Color();
		result.r = r + value.r;
		result.g = g + value.g;
		result.b = b + value.b;
		result.a = a + value.a;
		return result;
	}

	
	public inline function addLocal(value:Color):Void
	{
		this.r += value.r;
		this.g += value.g;
		this.b += value.b;
		this.a += value.a;
	}

	
	public inline function toUniform(result:Vector<Float>):Void
	{
		result[0] = r;
		result[1] = g;
		result[2] = b;
		result[3] = a;
	}

	public function getColor():Int
	{
		return (Std.int(a * 255) << 24 | Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255));
	}

	public function setColor(color:Int):Void
	{
		var invert:Float = FastMath.INVERT_255();
		a = (color >> 24 & 0xFF) * invert;
		r = (color >> 16 & 0xFF) * invert;
		g = (color >> 8 & 0xFF) * invert;
		b = (color & 0xFF) * invert;
	}

	public function setRGB(color:Int):Void
	{
		var invert:Float = FastMath.INVERT_255();
		r = (color >> 16 & 0xFF) * invert;
		g = (color >> 8 & 0xFF) * invert;
		b = (color & 0xFF) * invert;
	}

	public inline function clone():Color
	{
		return new Color(r, g, b, a);
	}

	public inline function copyFrom(other:Color):Void
	{
		setTo(other.r, other.g, other.b, other.a);
	}

	public function equals(other:Color):Bool
	{
		Assert.assert(other != null, "param can not be null");
		return r == other.r && g == other.g && b == other.b && a == other.a;
	}

	public function lerp(v1:Color, v2:Color, interp:Float):Void
	{
		var t:Float = 1 - interp;

		this.r = t * v1.r + interp * v2.r;
		this.g = t * v1.g + interp * v2.g;
		this.b = t * v1.b + interp * v2.b;
		this.a = t * v1.a + interp * v2.a;
	}

	public function toString():String
	{
		return 'Color($r,$g,$b,$a)';
	}
}



