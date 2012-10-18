package org.angle3d.math
{
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
	final public class Color
	{
		/**
		 * the color black (0,0,0).
		 */
		public static const Black:Color = new Color(0, 0, 0, 1);

		/**
		 * the color black (0,0,0).
		 */
		public static const BlackNoAlpha:Color = new Color(0, 0, 0, 0);

		/**
		 * the color white (1,1,1).
		 */
		public static const White:Color = new Color(1, 1, 1, 1);
		/**
		 * the color gray (.2,.2,.2).
		 */
		public static const DarkGray:Color = new Color(0.2, 0.2, 0.2, 1.0);
		/**
		 * the color gray (.5,.5,.5).
		 */
		public static const Gray:Color = new Color(0.5, 0.5, 0.5, 1.0);
		/**
		 * the color gray (.8,.8,.8).
		 */
		public static const LightGray:Color = new Color(0.8, 0.8, 0.8, 1.0);
		/**
		 * the color red (1,0,0).
		 */
		public static const Red:Color = new Color(1, 0, 0, 1);
		/**
		 * the color green (0,1,0).
		 */
		public static const Green:Color = new Color(0, 1, 0, 1);
		/**
		 * the color blue (0,0,1).
		 */
		public static const Blue:Color = new Color(0, 0, 1, 1);
		/**
		 * the color yellow (1,1,0).
		 */
		public static const Yellow:Color = new Color(1, 1, 0, 1);
		/**
		 * the color magenta (1,0,1).
		 */
		public static const Magenta:Color = new Color(1, 0, 1, 1);
		/**
		 * the color cyan (0,1,1).
		 */
		public static const Cyan:Color = new Color(0, 1, 1, 1);
		/**
		 * the color orange (251/255, 130/255,0).
		 */
		public static const Orange:Color = new Color(251 / 255, 130 / 255, 0, 1);
		/**
		 * the color brown (65/255, 40/255, 25/255).
		 */
		public static const Brown:Color = new Color(65 / 255, 40 / 255, 25 / 255, 1);
		/**
		 * the color pink (1, 0.68, 0.68).
		 */
		public static const Pink:Color = new Color(1, 0.68, 0.68, 1);

		/**
		 * The red component of the color.
		 */
		public var r:Number;
		/**
		 * The green component of the color.
		 */
		public var g:Number;
		/**
		 * the blue component of the color.
		 */
		public var b:Number;
		/**
		 * the alpha component of the color.  0 is transparent and 1 is opaque
		 */
		public var a:Number;

		/**
		 * Constructor instantiates a new <code>Color</code> object. The
		 * values are defined as passed parameters. These values are then clamped
		 * to insure that they are between 0 and 1.
		 * @param r the red component of this color.
		 * @param g the green component of this color.
		 * @param b the blue component of this color.
		 * @param a the alpha component of this color.
		 */
		public function Color(r:Number = 0.0, g:Number = 0.0, b:Number = 0.0, a:Number = 1.0)
		{
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}

		public function setRGBA(r:Number, g:Number, b:Number, a:Number = 1.0):void
		{
			this.r = r / 255;
			this.g = g / 255;
			this.b = b / 255;
			this.a = a;
		}

		public function setTo(r:Number, g:Number, b:Number, a:Number = 1.0):void
		{
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}

		public function add(value:Color, result:Color = null):Color
		{
			if (result == null)
				result = new Color();
			result.r = r + value.r;
			result.g = g + value.g;
			result.b = b + value.b;
			result.a = a + value.a;
			return result;
		}

		public function addLocal(value:Color):void
		{
			this.r += value.r;
			this.g += value.g;
			this.b += value.b;
			this.a += value.a;
		}

		public function toUniform(result:Vector.<Number> = null):Vector.<Number>
		{
			if (result == null)
			{
				result = new Vector.<Number>(4, true);
			}

			result[0] = r;
			result[1] = g;
			result[2] = b;
			result[3] = a;
			return result;
		}

		public function getColor():uint
		{
			return (int(a * 255) << 24 | int(r * 255) << 16 | int(g * 255) << 8 | int(b * 255));
		}

		public function setColor(color:uint):void
		{
			var invert:Number = 1.0 / 255;
			a = (color >> 24 & 0xFF) * invert;
			r = (color >> 16 & 0xFF) * invert;
			g = (color >> 8 & 0xFF) * invert;
			b = (color & 0xFF) * invert;
		}

		public function setRGB(color:uint):void
		{
			var invert:Number = 1.0 / 255;
			r = (color >> 16 & 0xFF) * invert;
			g = (color >> 8 & 0xFF) * invert;
			b = (color & 0xFF) * invert;
		}

		public function clone():Color
		{
			return new Color(r, g, b, a);
		}

		public function copyFrom(other:Color):void
		{
			setTo(other.r, other.g, other.b, other.a);
		}

		public function equals(other:Color):Boolean
		{
			CF::DEBUG
			{
				Assert.assert(other != null, "param can not be null");
			}
			
			return r == other.r && g == other.g && b == other.b && a == other.a;
		}

		public function lerp(v1:Color, v2:Color, interp:Number):void
		{
			var t:Number = 1 - interp;

			this.r = t * v1.r + interp * v2.r;
			this.g = t * v1.g + interp * v2.g;
			this.b = t * v1.b + interp * v2.b;
			this.a = t * v1.a + interp * v2.a;
		}

		public function toString():String
		{
			return "[Color(" + r + "," + g + "," + b + "," + a + ")]";
		}
	}
}


