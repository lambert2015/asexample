package org.angle3d.math;

import flash.Vector;
import org.angle3d.utils.Assert;

/**
 * Vector3
 * @author 
 */
class Vector3f
{
	public static var ZERO:Vector3f = new Vector3f(0, 0, 0);

	public static var X_AXIS:Vector3f = new Vector3f(1, 0, 0);

	public static var Y_AXIS:Vector3f = new Vector3f(0, 1, 0);

	public static var Z_AXIS:Vector3f = new Vector3f(0, 0, 1);

	public static var UNIT_SCALE:Vector3f = new Vector3f(1, 1, 1);

		
	public static function checkMinMax(min:Vector3f, max:Vector3f, point:Vector3f):Void
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
		
	public var x:Float;

	public var y:Float;
	
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
	 *
	 * @param copyVec 复制copyVec
	 * @param addVec 然后加上addVec
	 * @return
	 *
	 */
	
	public inline function copyAdd(copyVec:Vector3f, addVec:Vector3f):Vector3f
	{
		this.x = copyVec.x + addVec.x;
		this.y = copyVec.y + addVec.y;
		this.z = copyVec.z + addVec.z;

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

	public function getValueAt(index:Int):Float
	{
		Assert.assert(index >= 0 && index < 3, "out of bound");

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

	public function setValueAt(index:Int, value:Float):Void
	{
		Assert.assert(index >= 0 && index < 3, "out of bound");

		if (index == 0)
		{
			x = value;
		}
		else if (index == 1)
		{
			y = value;
		}
		else
		{
			z = value;
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
	public function add(vec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
			result = new Vector3f();

		result.x = x + vec.x;
		result.y = y + vec.y;
		result.z = z + vec.z;
		return result;
	}

	
	public inline function addLocal(vec:Vector3f):Vector3f
	{
		x += vec.x;
		y += vec.y;
		z += vec.z;
		return this;
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
	public function subtract(vec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
			result = new Vector3f();

		result.x = x - vec.x;
		result.y = y - vec.y;
		result.z = z - vec.z;
		return result;
	}

	
	public inline function subtractLocal(vec:Vector3f):Vector3f
	{
		x -= vec.x;
		y -= vec.y;
		z -= vec.z;
		return this;
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
	public function scaleAdd(scalar:Float, addVec:Vector3f):Void
	{
		x = x * scalar + addVec.x;
		y = y * scalar + addVec.y;
		z = z * scalar + addVec.z;
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
	public function dot(vec:Vector3f):Float
	{
		return x * vec.x + y * vec.y + z * vec.z;
	}

	public function cross(vec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
			result = new Vector3f();

		result.x = (y * vec.z - z * vec.y);
		result.y = (z * vec.x - x * vec.z);
		result.z = (x * vec.y - y * vec.x);

		return result;
	}

	public function crossLocal(vec:Vector3f):Vector3f
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
	public function isUnitVector(roundError:Float = 0.01):Bool
	{
		return FastMath.nearEqual(length, 1.0, roundError);
	}

	/**
	 * <code>length</code> calculates the magnitude of this vector.
	 *
	 */
	public var length(get, null):Float;
	private inline function get_length():Float
	{
		return Math.sqrt(x * x + y * y + z * z);
	}

	/**
	 * <code>lengthSquared</code> calculates the squared value of the
	 * magnitude of the vector.
	 *
	 */
	public var lengthSquared(get, null):Float;
	private inline function get_lengthSquared():Float
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
	public function distanceSquared(v:Vector3f):Float
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
	public function distance(v:Vector3f):Float
	{
		var dx:Float = x - v.x;
		var dy:Float = y - v.y;
		var dz:Float = z - v.z;
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}

	public function scale(scalar:Float, result:Vector3f = null):Vector3f
	{
		if (result == null)
			result = new Vector3f();

		result.x = x * scalar;
		result.y = y * scalar;
		result.z = z * scalar;
		return result;
	}

	public function scaleLocal(scalar:Float):Vector3f
	{
		x *= scalar;
		y *= scalar;
		z *= scalar;
		return this;
	}

	public function multiply(vec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
			result = new Vector3f();

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
	 * negated and set_to a new vector.
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
	public function normalizeLocal():Void
	{
		var len:Float = x * x + y * y + z * z;
		if (len != 0)
		{
			len = 1.0 / Math.sqrt(len);
			x *= len;
			y *= len;
			z *= len;
		}
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
	public function angleBetween(vec:Vector3f):Float
	{
		return Math.acos(x * vec.x + y * vec.y + z * vec.z);
	}

	
	public inline function lerp(v1:Vector3f, v2:Vector3f, interp:Float):Void
	{
		var t:Float = 1 - interp;
		this.x = t * v1.x + interp * v2.x;
		this.y = t * v1.y + interp * v2.y;
		this.z = t * v1.z + interp * v2.z;
	}

	public inline function clone():Vector3f
	{
		return new Vector3f(x, y, z);
	}

	
	public inline function toUniform(vec:Vector<Float>):Void
	{
		vec[0] = x;
		vec[1] = y;
		vec[2] = z;
	}
	
	public function isValid():Bool
	{
		if (Math.isNaN(x) || 
			Math.isNaN(y) || 
			Math.isNaN(z))
			return false;

		if (!Math.isFinite(x) || 
			!Math.isFinite(y) || 
			!Math.isFinite(z))
			return false;

		return true;
	}
	
	public function toString():String
	{
		return 'Vector3f($x,$y,$z)';
	}
	
}