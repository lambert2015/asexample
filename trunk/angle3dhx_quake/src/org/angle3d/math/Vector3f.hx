package org.angle3d.math;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.utils.Assert;

/**
 * <code>Vector3f</code> defines a Vector for a four float value tuple.
 * <code>Vector3f</code> can represent any four dimensional value, such as a
 * vertex, a normal, etc. Utility methods are also included to aid in
 * mathematical calculations.
 *
 * @author Maarten Steur
 */
class Vector3f 
{
	public static var X_AXIS:Vector3f = new Vector3f(1.0, 0.0, 0.0);
	public static var Y_AXIS:Vector3f = new Vector3f(0.0, 1.0, 0.0);
	public static var Z_AXIS:Vector3f = new Vector3f(0.0, 0.0, 1.0);
	
	public static var NAN:Vector3f = new Vector3f(Math.NaN, Math.NaN, Math.NaN);
	
	public static var POSITIVE_INFINITY:Vector3f = new Vector3f(
            Math.POSITIVE_INFINITY,
            Math.POSITIVE_INFINITY,
            Math.POSITIVE_INFINITY);
    public static var NEGATIVE_INFINITY:Vector3f = new Vector3f(
            Math.NEGATIVE_INFINITY,
            Math.NEGATIVE_INFINITY,
            Math.NEGATIVE_INFINITY);
	
	/**
	 * 获取x,y,z都是最大值的Vector3f
	 * @param	result
	 * @return
	 */
	public static inline function getMaxVector3(result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		result.x = Math.POSITIVE_INFINITY;
		result.y = Math.POSITIVE_INFINITY;
		result.z = Math.POSITIVE_INFINITY;
		return result;
	}
	/**
	 * 获取x,y,z都是最小值的Vector3f
	 * @param	result
	 * @return
	 */
	public static inline function getMinVector3(result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		result.x = Math.NEGATIVE_INFINITY;
		result.y = Math.NEGATIVE_INFINITY;
		result.z = Math.NEGATIVE_INFINITY;
		return result;
	}
	
	public static inline function checkMinMax(min:Vector3f, max:Vector3f, point:Vector3f):Void
	{
        if (point.x < min.x)
            min.x = point.x;
        if (point.x > max.x)
            max.x = point.x;
        if (point.y < min.y)
            min.y = point.y;
        if (point.y > max.y)
            max.y = point.y;
        if (point.z < min.z)
            min.z = point.z;
        if (point.z > max.z)
            max.z = point.z;
    }
	
	public static inline function computeCenter(a:Vector3f, b:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		result.x = (a.x + b.x) * 0.5;
		result.y = (a.y + b.y) * 0.5;
		result.z = (a.z + b.z) * 0.5;
		return result;
	}
	
	public inline var length(getLength, never):Float;
	public inline var lengthSquared(getLengthSquared, never):Float;
	
	
    /**
     * the x value of the vector.
     */
    public var x:Float;
	
	/**
     * the y value of the vector.
     */
	public var y:Float;
	
	/**
     * the z value of the vector.
     */
    public var z:Float;
	

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) 
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public inline function copyFrom(other:Vector3f):Vector3f
	{
		this.x = other.x;
		this.y = other.y;
		this.z = other.z;
		
		return this;
	}
	
	/**
     * <code>set</code> sets the x,y,z values of the vector based on passed
     * parameters.
     *
     * @param x
     *            the x value of the vector.
     * @param y
     *            the y value of the vector.
     * @param z
     *            the z value of the vector.
     * @return this vector
     */
	public inline function setTo(x:Float, y:Float, z:Float):Void
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public inline function getValueAt(index:Int):Float
	{
		#if debug
		Assert.assert(index >= 0 && index < 3, "out of bound");
		#end
		
		if (index == 0)
		{
			return x;
		}
		else if (index == 1)
		{
			return y;
		}
		else
		{
			return z;
		}
	}
	
	/**
     *
     * <code>add</code> adds a provided vector to this vector creating a
     * resultant vector which is returned. If the provided vector is null, null
     * is returned.
     *
     * @param vec
     *            the vector to add to this.
     * @return the resultant vector.
     */
	public inline function add(vec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}

		result.x = x + vec.x;
		result.y = y + vec.y;
		result.z = z + vec.z;
        return result;
	}
	
	public inline function addLocal(vec:Vector3f):Void
	{
		x += vec.x;
		y += vec.y;
		z += vec.z;
	}
	
	/**
     *
     * <code>subtract</code> subtracts the values of a given vector from those
     * of this vector creating a new vector object. If the provided vector is
     * null, null is returned.
     *
     * @param vec
     *            the vector to subtract from this vector.
     * @return the result vector.
     */
    public inline function subtract(vec:Vector3f,result:Vector3f=null):Vector3f 
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		
		result.x = x - vec.x;
		result.y = y - vec.y;
		result.z = z - vec.z;
        return result;
    }
	
	public inline function subtractLocal(vec:Vector3f):Void 
	{
        x -= vec.x;
		y -= vec.y;
		z -= vec.z;
    }
	
	/**
     *
     * <code>scaleAdd</code> multiplies this vector by a scalar then adds the
     * given Vector3f.
     *
     * @param scalar
     *            the value to multiply this vector by.
     * @param add
     *            the value to add
     */
	public inline function scaleAdd(scalar:Float, add:Vector3f):Void
	{
		x = x * scalar + add.x;
		y = y * scalar + add.y;
		z = z * scalar + add.z;
	}
	
	/**
     *
     * <code>dot</code> calculates the dot product of this vector with a
     * provided vector. If the provided vector is null, 0 is returned.
     *
     * @param vec
     *            the vector to dot with this vector.
     * @return the resultant dot product of this vector and a given vector.
     */
	public inline function dot(vec:Vector3f):Float
	{
		return x * vec.x + y * vec.y + z * vec.z;
	}
	
	public inline function cross(vec:Vector3f, result:Vector3f = null):Vector3f
	{
        if (result == null) 
		    result = new Vector3f();
			
        var resX:Float = (y * vec.z - z * vec.y); 
        var resY:Float = (z * vec.x - x * vec.z);
        var resZ:Float = (x * vec.y - y * vec.x);
        result.setTo(resX, resY, resZ);
        return result;
    }
	
	public inline function crossLocal(vec:Vector3f):Vector3f
	{
        var tx:Float = this.x;
		var ty:Float = this.y;
		var tz:Float = this.z;
		
		this.x = ty * vec.z - tz * vec.y;
		this.y = tz * vec.x - tx * vec.z;
		this.z = tx * vec.y - ty * vec.x;
		
		return this;
    }
	
	/**
     * Returns true if this vector is a unit vector (length() ~= 1),
     * returns false otherwise.
     *
     * @return true if this vector is a unit vector (length() ~= 1),
     * or false otherwise.
     */
	public inline function isUnitVector():Bool
	{
		return FastMath.nearEqual(length, 1.0, 0.01);
	}
	
	/**
     * <code>length</code> calculates the magnitude of this vector.
     * 
     * @return the length or magnitude of the vector.
     */
	public inline function getLength():Float
	{
		return Math.sqrt(x * x + y * y + z * z);
	}
	
	/**
     * <code>lengthSquared</code> calculates the squared value of the
     * magnitude of the vector.
     * 
     * @return the magnitude squared of the vector.
     */
	public inline function getLengthSquared():Float
	{
		return x * x + y * y + z * z;
	}
	
	/**
     * <code>distanceSquared</code> calculates the distance squared between
     * this vector and vector v.
     *
     * @param v the second vector to determine the distance squared.
     * @return the distance squared between the two vectors.
     */
	public inline function distanceSquared(v:Vector3f):Float
	{
		var dx:Float = x - v.x;
		var dy:Float = y - v.y;
		var dz:Float = z - v.z;
		return (dx * dx + dy * dy + dz * dz);
	}
	
	/**
     * <code>distance</code> calculates the distance between
     * this vector and vector v.
     *
     * @param v the second vector to determine the distance.
     * @return the distance between the two vectors.
     */
	public inline function distance(v:Vector3f):Float
	{
		return Math.sqrt(distanceSquared(v));
	}
	
	public inline function scale(scalar:Float,result:Vector3f = null):Vector3f
	{
		if (result == null)
		    result = new Vector3f();
		
		result.x = x * scalar;
		result.y = y * scalar;
		result.z = z * scalar;
		return result;
	}
	
	public inline function scaleLocal(scalar:Float):Void
	{
		x *= scalar;
		y *= scalar;
		z *= scalar;
	}
	
	public inline function multiply(vec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		result.x = x * vec.x;
		result.y = y * vec.y;
		result.z = z * vec.z;
		return result;
	}
	
	public inline function multiplyLocal(vec:Vector3f):Void
	{
		x *= vec.x;
		y *= vec.y;
		z *= vec.z;
	}
	
	public inline function divideLocal(scalar:Vector3f):Void
	{
		x /= scalar.x;
        y /= scalar.y;
        z /= scalar.z;
	}
	
	public inline function negateLocal():Void
	{
		x = -x;
		y = -y;
		z = -z;
	}
	
	/**
     *
     * <code>negate</code> returns the negative of this vector. All values are
     * negated and set to a new vector.
     *
     * @return the negated vector.
     */
	public inline function negate():Vector3f
	{
		return new Vector3f(-x, -y, -z);
	}
	
	/**
     * <code>normalize</code> returns the unit vector of this vector.
     *
     * @return unit vector of this vector.
     */
	public function normalizeLocal():Vector3f
	{
		var len:Float = x * x + y * y + z * z;
        if (len != 1 && len != 0)
		{
            len = 1.0 / Math.sqrt(len);
            x *= len;
			y *= len;
			z *= len;
        }
		return this;
	}
	
	/**
     * <code>maxLocal</code> computes the maximum value for each 
     * component in this and <code>other</code> vector. The result is stored
     * in this vector.
     * @param other 
     */
    public inline function maxLocal(other:Vector3f):Void
	{
        x = other.x > x ? other.x : x;
        y = other.y > y ? other.y : y;
        z = other.z > z ? other.z : z;
    }

    /**
     * <code>minLocal</code> computes the minimum value for each
     * component in this and <code>other</code> vector. The result is stored
     * in this vector.
     * @param other
     */
    public inline function minLocal(other:Vector3f):Void
	{
        x = other.x < x ? other.x : x;
        y = other.y < y ? other.y : y;
        z = other.z < z ? other.z : z;
    }
	
	/**
     * <code>zero</code> resets this vector's data to zero internally.
     */
    public inline function zero():Void
	{
        x = y = z = 0;
    }
	
	public inline function isZero():Bool 
	{
		return (x == 0 && y == 0 && z == 0);
	}
	
	/**
     * <code>angleBetween</code> returns (in radians) the angle between two vectors.
     * It is assumed that both this vector and the given vector are unit vectors (iow, normalized).
     *
     * @param otherVector a unit vector to find the angle against
     * @return the angle in radians.
     */
    public inline function angleBetween(other:Vector3f):Float
	{
        var dot:Float = this.dot(other);
        var angle:Float = Math.acos(dot);
        return angle;
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
	public inline function interpolateLocal(finalVec:Vector3f, changeAmnt:Float):Void
	{
		var t:Float = 1 - changeAmnt;
		this.x = t * this.x + changeAmnt * finalVec.x;
		this.y = t * this.y + changeAmnt * finalVec.y;
		this.z = t * this.z + changeAmnt * finalVec.z;
	}
	
	public inline function interpolate(finalVec:Vector3f, changeAmnt:Float, result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		var t:Float = 1 - changeAmnt;
		result.x = t * this.x + changeAmnt * finalVec.x;
		result.y = t * this.y + changeAmnt * finalVec.y;
		result.z = t * this.z + changeAmnt * finalVec.z;
		return result;
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
    public inline function interpolateByTowVector(beginVec:Vector3f,finalVec:Vector3f,
                                           changeAmnt:Float):Void
	{
       var t:Float = 1 - changeAmnt;
		this.x = t * beginVec.x + changeAmnt * finalVec.x;
		this.y = t * beginVec.y + changeAmnt * finalVec.y;
		this.z = t * beginVec.z + changeAmnt * finalVec.z;
    }
	
	/**
     * Check a vector... if it is null or its floats are NaN or infinite,
     * return false.  Else return true.
     * @param vector the vector to check
     * @return true or false as stated above.
     */
	 public static function isValidVector(vector:Vector3f):Bool 
	 {
        if (vector == null) return false;
		
        if (Math.isNaN(vector.x) ||
            Math.isNaN(vector.y) ||
			Math.isNaN(vector.z)) return false;
			
        if (!Math.isFinite(vector.x) ||
            !Math.isFinite(vector.y) ||
			!Math.isFinite(vector.z)) return false;
			
        return true;
    }
	
	public inline function clone():Vector3f
	{
		return new Vector3f(x, y, z);
	}
	
	public inline function toVector(vec:Vector<Float> = null):Vector<Float>
	{
		if (vec == null)
		{
			vec = new Vector<Float>();
		}
		vec[0] = x;
		vec[1] = y;
		vec[2] = z;
		return vec;
	}
	
	public function toString():String
	{
        return "Vector3f(" + x + ", " + y + ", " + z + ")";
    }
}