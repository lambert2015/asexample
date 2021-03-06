package org.angle3d.math;

/**
 * <code>Vector2f</code> defines a Vector for a two float value vector.
 * 
 */
class Vector2f 
{
	public static inline var ZERO:Vector2f = new Vector2f(0, 0);
	public static inline var UNIT:Vector2f = new Vector2f(1, 1);
	
	public var length(getLength, never):Float;
	public var lengthSquared(getLengthSquared, never):Float;
	
	/**
     * the x value of the vector.
     */
    public var x:Float;
	/**
     * the y value of the vector.
     */
	public var y:Float;
	
	/**
     * Creates a Vector2 with the given initial x and y values.
     * 
     * @param x
     *            The x value of this Vector2.
     * @param y
     *            The y value of this Vector2.
     */
	public function new(x:Float = 0, y:Float = 0) 
	{
		this.x = x;
		this.y = y;
	}
	
	public inline function setTo(x:Float, y:Float):Void
	{
		this.x = x;
		this.y = y;
	}
	
	public inline function copyFrom(other:Vector2f):Void
	{
		this.x = other.x;
		this.y = other.y;
	}

	public inline function add(vec:Vector2f):Vector2f
	{
		return new Vector2f(x + vec.x, y + vec.y);
	}
	
	public inline function addLocal(vec:Vector2f):Void
	{
		x += vec.x;
		y += vec.y;
	}
	
	/**
     * <code>subtract</code> subtracts the values of a given vector from those
     * of this vector creating a new vector object. If the provided vector is
     * null, an exception is thrown.
     * 
     * @param vec
     *            the vector to subtract from this vector.
     * @return the result vector.
     */
	public inline function subtract(vec:Vector2f, result:Vector2f = null):Vector2f
	{
		if (result == null) 
		{
            result = new Vector2f();
        }
		result.x = x - vec.x;
		result.y = y - vec.y;
		return result;
	}
	
	public inline function subtractLocal(vec:Vector2f):Void
	{
		x -= vec.x;
		y -= vec.y;
	}
	
	/**
     * <code>dot</code> calculates the dot product of this vector with a
     * provided vector. If the provided vector is null, 0 is returned.
     * 
     * @param vec
     *            the vector to dot with this vector.
     * @return the resultant dot product of this vector and a given vector.
     */
	public inline function dot(vec:Vector2f):Float
	{
		return x * vec.x + y * vec.y;
	}
	
	/**
     * <code>cross</code> calculates the cross product of this vector with a
     * parameter vector v.
     * 
     * @param v
     *            the vector to take the cross product of with this.
     * @return the cross product vector.
     */
	public inline function cross(v:Vector2f):Vector2f
	{
		return new Vector2f(0, determinant(v));
	}
	
	public inline function determinant(v:Vector2f):Float
	{
		return (x * v.y) - (y * v.x);
	}
	
	/**
     * Sets this vector to the interpolation by changeAmnt from this to the
     * finalVec this=(1-changeAmnt)*this + changeAmnt * finalVec
     * 
     * @param finalVec
     *            The final vector to interpolate towards
     * @param changeAmnt
     *            An amount between 0.0 - 1.0 representing a percentage change
     *            from this towards finalVec
     */
	public inline function interpolateBy(finalVec:Vector2f, changeAmnt:Float):Void
	{
		this.x = (1 - changeAmnt) * this.x + changeAmnt * finalVec.x;
		this.y = (1 - changeAmnt) * this.y + changeAmnt * finalVec.y;
	}
	
	/**
     * Sets this vector to the interpolation by changeAmnt from beginVec to
     * finalVec this=(1-changeAmnt)*beginVec + changeAmnt * finalVec
     * 
     * @param beginVec
     *            The begining vector (delta=0)
     * @param finalVec
     *            The final vector to interpolate towards (delta=1)
     * @param changeAmnt
     *            An amount between 0.0 - 1.0 representing a precentage change
     *            from beginVec towards finalVec
     */
    public function interpolateByTowVector(beginVec:Vector2f,finalVec:Vector2f,
            changeAmnt:Float):Void
	{
        this.x = (1 - changeAmnt) * beginVec.x + changeAmnt * finalVec.x;
		this.y = (1 - changeAmnt) * beginVec.y + changeAmnt * finalVec.y;
    }
	
	/**
     * Check a vector... if it is null or its floats are NaN or infinite, return
     * false. Else return true.
     * 
     * @param vector
     *            the vector to check
     * @return true or false as stated above.
     */
	public static function isValidVector(vector:Vector2f):Bool
	{
		if (vector == null) return false;
	
      if (Math.isNaN(vector.x) ||
          Math.isNaN(vector.y)) return false;
		  
      if (!Math.isFinite(vector.x) ||
          !Math.isFinite(vector.y)) return false;
		  
      return true;
    }
	
	/**
     * <code>length</code> calculates the magnitude of this vector.
     * 
     * @return the length or magnitude of the vector.
     */
	public inline function getLength():Float
	{
		return Math.sqrt(x * x + y * y);
	}
	
	/**
     * <code>lengthSquared</code> calculates the squared value of the
     * magnitude of the vector.
     * 
     * @return the magnitude squared of the vector.
     */
	public inline function getLengthSquared():Float
	{
		return x * x + y * y;
	}
	
	/**
     * <code>distanceSquared</code> calculates the distance squared between
     * this vector and vector v.
     *
     * @param v the second vector to determine the distance squared.
     * @return the distance squared between the two vectors.
     */
	public inline function distanceSquared(v:Vector2f):Float
	{
		var dx:Float = x - v.x;
		var dy:Float = y - v.y;
		return (dx * dx + dy * dy);
	}
	
	/**
     * <code>distance</code> calculates the distance between
     * this vector and vector v.
     *
     * @param v the second vector to determine the distance.
     * @return the distance between the two vectors.
     */
	public inline function distance(v:Vector2f):Float
	{
		return Math.sqrt(distanceSquared(v));
	}
	
	/**
     * <code>scale</code> multiplies this vector by a scalar. The resultant
     * vector is returned.
     * 
     * @param scalar
     *            the value to multiply this vector by.
     * @return the new vector.
     */
	public inline function scale(scalar:Float, ?result:Vector2f = null):Vector2f
	{
		if (null == result) {
            result = new Vector2f();
        }
		result.x = x * scalar;
		result.y = y * scalar;
		return result;
	}
	
	/**
     * <code>scaleBy</code> multiplies this vector by a scalar internally,
     * and returns a handle to this vector for easy chaining of calls.
     * 
     * @param scalar
     *            the value to multiply this vector by.
     * @return this
     */
	public inline function scaleBy(scalar:Float):Void
	{
		x *= scalar;
		y *= scalar;
	}
	
	public inline function divide(scalar:Float):Vector2f
	{
		return new Vector2f(x / scalar, y / scalar);
	}
	
	public inline function divideBy(scalar:Float):Void
	{
		x /= scalar;
		y /= scalar;
	}
	
	/**
     * <code>negate</code> returns the negative of this vector. All values are
     * negated and set to a new vector.
     * 
     * @return the negated vector.
     */
	public inline function negate():Vector2f
	{
		return new Vector2f( -x, -y);
	}
	
	/**
     * <code>negateLocal</code> negates the internal values of this vector.
     * 
     * @return this.
     */
	public inline function negateLocal():Void
	{
		x = -x;
		y = -y;
	}
	
	/**
     * <code>normalize</code> returns the unit vector of this vector.
     * 
     * @return unit vector of this vector.
     */
	public inline function normalize():Void
	{
		var len:Float = getLength();
		if (len != 0)
		{
			len = 1 / len;
			x *= len;
			y *= len;
		}
	}
	
	public inline function getNormalize():Vector2f
	{
		var result:Vector2f = clone();
		var d:Float = length;
		if (d != 0)
		{
			d = 1 / d;
			result.x = x * d;
			result.y = y * d;
		}
		return result;
	}
	
	/**
     * <code>angleBetween</code> returns (in radians) the angle required to
     * rotate a ray represented by this vector to lie colinear to a ray
     * described by the given vector. It is assumed that both this vector and
     * the given vector are unit vectors (iow, normalized).
     * 
     * @param otherVector
     *            the "destination" unit vector
     * @return the angle in radians.
     */
	public inline function angleBetween(other:Vector2f):Float
	{
		var angle:Float = Math.atan2(other.y, other.x) - Math.atan2(y, x);
		return angle;
	}
	
	/**
     * <code>getAngle</code> returns (in radians) the angle represented by
     * this Vector2f as expressed by a conversion from rectangular coordinates
     * to polar coordinates (r,&nbsp;<i>theta</i>).
     * 
     * @return the angle in radians. [-pi, pi)
     */
	public inline function getAngle():Float
	{
		return Math.atan2(y, x);
	}
	
	public inline function rotateAroundOrigin(angle:Float, ?cw:Bool = false)
	{
		if (cw)
		   angle = -angle;
		   
		var ang_cos:Float = Math.cos(angle);
		var ang_sin:Float = Math.sin(angle);
		
		var nx:Float = ang_cos * x - ang_sin * y;
		var ny:Float = ang_sin * x + ang_cos * y;
		
		x = nx;
		y = ny;
	}
	
	/**
     * <code>zero</code> resets this vector's data to zero internally.
     */
	public inline function zero():Void
	{
		x = y = 0;
	}
	
	public inline function clone():Vector2f
	{
		return new Vector2f(x, y);
	}
	
	/**
     * <code>toString</code> returns the string representation of this vector
     * object. The format of the string is such: com.jme.math.Vector2f
     * [X=XX.XXXX, Y=YY.YYYY]
     * 
     * @return the string representation of this vector.
     */
	public function toString():String
	{
		return "Vector2f(" + x + "," + y + ")";
	}
}