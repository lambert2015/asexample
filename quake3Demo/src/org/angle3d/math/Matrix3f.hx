package org.angle3d.math;
import flash.errors.Error;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.utils.Assert;
import org.angle3d.utils.Logger;

/**
 * <code>Matrix3f</code> defines a 3x3 matrix. Matrix data is maintained
 * internally and is accessible via the get and set methods. Convenience methods
 * are used for matrix operations as well as generating a matrix from a given
 * set of values.
 * 
 */
class Matrix3f 
{
	public static var ZERO:Matrix3f = new Matrix3f([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]);
    public static var IDENTITY:Matrix3f = new Matrix3f();
	
	public var m00:Float;
	public var m01:Float;
	public var m02:Float;
	
	public var m10:Float;
	public var m11:Float;
	public var m12:Float;
	
	public var m20:Float;
	public var m21:Float;
	public var m22:Float;
    
	public function new(arr:Array<Float> = null)
	{
		if (arr != null)
		{
			setArray(arr);
		}
		else
		{
			loadIdentity();
		}
	}
	
	/**
     * Takes the absolute value of all matrix fields locally.
     */
	public function abs():Void
	{
		m00 = FastMath.fabs(m00);
        m01 = FastMath.fabs(m01);
        m02 = FastMath.fabs(m02);
        m10 = FastMath.fabs(m10);
        m11 = FastMath.fabs(m11);
        m12 = FastMath.fabs(m12);
        m20 = FastMath.fabs(m20);
        m21 = FastMath.fabs(m21);
        m22 = FastMath.fabs(m22);
	}
	
	public inline function loadIdentity():Void
	{
		m00 = m11 = m22  = 1.0;
		m01 = m02 = m10 = m12 = m20 = m21 = 0.0;
	}
	
	/**
     * <code>copy</code> transfers the contents of a given matrix to this
     * matrix.
     * 
     * @param matrix
     *            the matrix to copy.
     */
	public inline function copyFrom(mat:Matrix3f):Void
	{
		this.m00 = mat.m00;
		this.m01 = mat.m01;
		this.m02 = mat.m02;
		
		this.m10 = mat.m10;
		this.m11 = mat.m11;
		this.m12 = mat.m12;
		
		this.m20 = mat.m20;
		this.m21 = mat.m21;
		this.m22 = mat.m22;
	}
	
	/**
     * Create a new Matrix3f, given data in column-major format.
     *
     * @param array
     *		An array of 16 floats in column-major format (translation in elements 12, 13 and 14).
     */
	public function setArray(matrix:Array<Float>, rowMajor:Bool = true):Void
	{
		Assert.assert(matrix.length == 9,"Array must be of size 9.");

		if (rowMajor) 
		{
            m00 = matrix[0];
	        m01 = matrix[1];
	        m02 = matrix[2];
	        m10 = matrix[3];
	        m11 = matrix[4];
	        m12 = matrix[5];
	        m20 = matrix[6];
	        m21 = matrix[7];
	        m22 = matrix[8];
        } 
		else 
		{
            m00 = matrix[0];
	        m01 = matrix[3];
	        m02 = matrix[6];
	        m10 = matrix[1];
	        m11 = matrix[4];
	        m12 = matrix[7];
	        m20 = matrix[2];
	        m21 = matrix[5];
	        m22 = matrix[8];
        }
	}
	
	/**
     * Create a new Matrix4f, given data in column-major format.
     *
     * @param array
     *		An array of 16 floats in column-major format (translation in elements 12, 13 and 14).
     */
	public function setVector(matrix:Vector<Float>, rowMajor:Bool = true):Void
	{
		Assert.assert(matrix.length == 9,"Array must be of size 9.");

		if (rowMajor) 
		{
            m00 = matrix[0];
	        m01 = matrix[1];
	        m02 = matrix[2];
	        m10 = matrix[3];
	        m11 = matrix[4];
	        m12 = matrix[5];
	        m20 = matrix[6];
	        m21 = matrix[7];
	        m22 = matrix[8];
        } 
		else 
		{
            m00 = matrix[0];
	        m01 = matrix[3];
	        m02 = matrix[6];
	        m10 = matrix[1];
	        m11 = matrix[4];
	        m12 = matrix[7];
	        m20 = matrix[2];
	        m21 = matrix[5];
	        m22 = matrix[8];
        }
	}
	
	/**
     * <code>get</code> retrieves a value from the matrix at the given
     * position. If the position is invalid a <code>JmeException</code> is
     * thrown.
     * 
     * @param i
     *            the row index.
     * @param j
     *            the colum index.
     * @return the value at (i, j).
     */
	public inline function getValue(row:Int, column:Int):Float
	{
		return untyped this["m" + row + column];
	}
	
	public function toUniform(list:Vector<Float> = null, rowMajor:Bool = true):Vector<Float>
	{
		if (list == null)
		{
			list = new Vector<Float>(12);
		}
		
        if (rowMajor) 
	    {
            list[0] = m00;
            list[1] = m01;
            list[2] = m02;
			list[3] = 0;
            list[4] = m10;
            list[5] = m11;
            list[6] = m12;
			list[7] = 0;
            list[8] = m20;
            list[9] = m21;
            list[10] = m22;
			list[11] = 0;
        }
        else 
		{
            list[0] = m00;
            list[1] = m10;
            list[2] = m20;
			list[3] = 0;
            list[4] = m01;
            list[5] = m11;
            list[6] = m21;
			list[7] = 0;
            list[8] = m02;
            list[9] = m12;
            list[10] = m22;
			list[11] = 0;
        }
		
		return list;
	}
	
	/**
     * <code>getColumn</code> returns one of three columns specified by the
     * parameter. This column is returned as a <code>Vector3f</code> object.
     * 
     * @param i
     *            the column to retrieve. Must be between 0 and 2.
     * @return the column specified by the index.
     */
	public function copyColumnTo(column:Int, ?result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		
		if (0 < column || column > 2)
		{
			Logger.warn("Column is null. Ignoring.");
			return result;
		}
		
		result.x = getValue(0, column);
		result.y = getValue(1, column);
		result.z = getValue(2, column);
		return result;
	}
	
	 /**
     * <code>getRow</code> returns one of three rows as specified by the
     * parameter. This row is returned as a <code>Vector3f</code> object.
     * 
     * @param i
     *            the row to retrieve. Must be between 0 and 2.
     * @param store
     *            the vector object to store the result in. if null, a new one
     *            is created.
     * @return the row specified by the index.
     */
	public function copyRowTo(row:Int, ?result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		
		if (0 < row || row > 2)
		{
			Logger.warn("Row is null. Ignoring.");
			return result;
		}
		
		result.x = getValue(row, 0);
		result.y = getValue(row, 1);
		result.z = getValue(row, 2);
		return result;
	}
	
	/**
     * 
     * <code>setColumn</code> sets a particular column of this matrix to that
     * represented by the provided vector.
     * 
     * @param i
     *            the column to set.
     * @param column
     *            the data to set.
     * @return this
     */
	public inline function setColumn(column:Int, vector:Vector3f):Void
	{
		if (0 < column || column > 2)
		{
			Logger.warn("Column is null. Ignoring.");
			return;
		}
		setValue(0, column, vector.x);
		setValue(1, column, vector.y);
		setValue(2, column, vector.z);
	}
	
	/**
     * 
     * <code>setRow</code> sets a particular row of this matrix to that
     * represented by the provided vector.
     * 
     * @param i
     *            the row to set.
     * @param row
     *            the data to set.
     * @return this
     */
	public inline function setRow(row:Int, vector:Vector3f):Void
	{
		if (0 < row || row > 2)
		{
			Logger.warn("Row is null. Ignoring.");
			return;
		}
		setValue(row, 0, vector.x);
		setValue(row, 1, vector.y);
		setValue(row, 2, vector.z);
	}
	
	/**
     * <code>set</code> places a given value into the matrix at the given
     * position. If the position is invalid a <code>JmeException</code> is
     * thrown.
     * 
     * @param i
     *            the row index.
     * @param j
     *            the colum index.
     * @param value
     *            the value for (i, j).
     * @return this
     */
	public inline function setValue(row:Int, column:Int, value:Float):Void
	{
		untyped this["m" + row + column] = value;
	}
	
	/**
     * 
     * <code>set</code> sets the values of the matrix to those supplied by the
     * 3x3 two dimenion array.
     * 
     * @param matrix
     *            the new values of the matrix.
     * @throws JmeException
     *             if the array is not of size 9.
     * @return this
     */
	public inline function setArray2(matrix:Vector<Vector<Float>>):Void
	{
		Assert.assert(matrix.length == 3 && matrix[0].length == 3,"Array must be of size 3."); 

		m00 = matrix[0][0];
        m01 = matrix[0][1];
        m02 = matrix[0][2];
        m10 = matrix[1][0];
        m11 = matrix[1][1];
        m12 = matrix[1][2];
        m20 = matrix[2][0];
        m21 = matrix[2][1];
        m22 = matrix[2][2];
	}
	
	/**
     * Recreate Matrix using the provided axis.
     * 
     * @param uAxis
     *            Vector3f
     * @param vAxis
     *            Vector3f
     * @param wAxis
     *            Vector3f
     */
	public inline function fromAxes(uAxis:Vector3f, vAxis:Vector3f, wAxis:Vector3f):Void
	{
		m00 = uAxis.x;
		m01 = uAxis.y;
		m20 = uAxis.z;
		
		m01 = vAxis.x;
        m11 = vAxis.y;
        m21 = vAxis.z;

        m02 = wAxis.x;
        m12 = wAxis.y;
        m22 = wAxis.z;
	}
	
	/**
     * 
     * <code>set</code> defines the values of the matrix based on a supplied
     * <code>Quaternion</code>. It should be noted that all previous values
     * will be overridden.
     * 
     * @param quaternion
     *            the quaternion to create a rotational matrix from.
     * @return this
     */
	public inline function copyFromQuaternion(quaternion:Quaternion):Void
	{
		quaternion.toRotationMatrix3f(this);
	}
	
	/**
     * @return true if this matrix is identity
     */
	public inline function isIdentity():Bool
	{
		return 
        (m00 == 1 && m01 == 0 && m02 == 0) &&
        (m10 == 0 && m11 == 1 && m12 == 0) &&
        (m20 == 0 && m21 == 0 && m22 == 1);
	}
	
	/**
     * <code>fromAngleAxis</code> sets this matrix4f to the values specified
     * by an angle and an axis of rotation.  This method creates an object, so
     * use fromAngleNormalAxis if your axis is already normalized.
     * 
     * @param angle
     *            the angle to rotate (in radians).
     * @param axis
     *            the axis of rotation.
     */
	public function fromAngleAxis(angle:Float, axis:Vector3f):Void
	{
		var normalAxis:Vector3f = axis.clone().normalizeLocal();
		fromAngleNormalAxis(angle, normalAxis);
	}
	
	/**
     * <code>fromAngleNormalAxis</code> sets this matrix4f to the values
     * specified by an angle and a normalized axis of rotation.
     * 
     * @param angle
     *            the angle to rotate (in radians).
     * @param axis
     *            the axis of rotation (already normalized).
     */
	public function fromAngleNormalAxis(angle:Float, axis:Vector3f):Void
	{
		var fCos:Float = Math.cos(angle);
		var fSin:Float = Math.sin(angle);
		var fOneMinusCos = 1.0 - fCos;
		var fX2:Float = axis.x * axis.x;
		var fY2:Float = axis.y * axis.y;
		var fZ2:Float = axis.z * axis.z;
		var fXYM:Float = axis.x * axis.y * fOneMinusCos;
        var fXZM:Float = axis.x * axis.z * fOneMinusCos;
        var fYZM:Float = axis.y * axis.z * fOneMinusCos;
        var fXSin:Float = axis.x * fSin;
        var fYSin:Float = axis.y * fSin;
        var fZSin:Float = axis.z * fSin;
		
		m00 = fX2 * fOneMinusCos + fCos;
        m01 = fXYM - fZSin;
        m02 = fXZM + fYSin;
        m10 = fXYM + fZSin;
        m11 = fY2 * fOneMinusCos + fCos;
        m12 = fYZM - fXSin;
        m20 = fXZM - fYSin;
        m21 = fYZM + fXSin;
        m22 = fZ2 * fOneMinusCos + fCos;
	}
	
	/**
     * <code>mult</code> multiplies this matrix by a given matrix. The result
     * matrix is returned as a new object. If the given matrix is null, a null
     * matrix is returned.
     * 
     * @param mat
     *            the matrix to multiply this matrix by.
     * @return the result matrix.
     */
	public function mult(mat:Matrix3f,?result:Matrix3f=null):Matrix3f
	{
		if (result == null) result = new Matrix3f();
		
		var temp00:Float, temp01:Float, temp02:Float;
        var temp10:Float, temp11:Float, temp12:Float;
        var temp20:Float, temp21:Float, temp22:Float;
		
		temp00 = m00 * mat.m00 + m01 * mat.m10 + m02 * mat.m20;
        temp01 = m00 * mat.m01 + m01 * mat.m11 + m02 * mat.m21;
        temp02 = m00 * mat.m02 + m01 * mat.m12 + m02 * mat.m22;
        temp10 = m10 * mat.m00 + m11 * mat.m10 + m12 * mat.m20;
        temp11 = m10 * mat.m01 + m11 * mat.m11 + m12 * mat.m21;
        temp12 = m10 * mat.m02 + m11 * mat.m12 + m12 * mat.m22;
        temp20 = m20 * mat.m00 + m21 * mat.m10 + m22 * mat.m20;
        temp21 = m20 * mat.m01 + m21 * mat.m11 + m22 * mat.m21;
        temp22 = m20 * mat.m02 + m21 * mat.m12 + m22 * mat.m22;
        
        result.m00 = temp00;
        result.m01 = temp01;
        result.m02 = temp02;
        result.m10 = temp10;
        result.m11 = temp11;
        result.m12 = temp12;
        result.m20 = temp20;
        result.m21 = temp21;
        result.m22 = temp22;
        
        return result;
	}
	
	/**
     * <code>mult</code> multiplies this matrix by a given
     * <code>Vector3f</code> object. The result vector is returned. If the
     * given vector is null, null will be returned.
     * 
     * @param vec
     *            the vector to multiply this matrix by.
     * @return the result vector.
     */
	public function multVec(vec:Vector3f,result:Vector3f = null):Vector3f
	{
		if (result == null) result = new Vector3f();
		
		var x:Float = vec.x;
        var y:Float = vec.y;
        var z:Float = vec.z;

        result.x = m00 * x + m01 * y + m02 * z;
        result.y = m10 * x + m11 * y + m12 * z;
        result.z = m20 * x + m21 * y + m22 * z;
        return result;
	}
	
	/**
     * <code>multLocal</code> multiplies this matrix internally by 
     * a given float scale factor.
     * 
     * @param scale
     *            the value to scale by.
     * @return this Matrix3f
     */
	public function scaleBy(scale:Float):Void
	{
		m00 *= scale;
        m01 *= scale;
        m02 *= scale;
        m10 *= scale;
        m11 *= scale;
        m12 *= scale;
        m20 *= scale;
        m21 *= scale;
        m22 *= scale;
	}
	
	/**
     * <code>multVecLocal</code> multiplies this matrix by a given
     * <code>Vector3f</code> object. The result vector is stored inside the
     * passed vector, then returned . If the given vector is null, null will be
     * returned.
     * 
     * @param vec
     *            the vector to multiply this matrix by.
     * @return The passed vector after multiplication
     */
	public function multVecLocal(vec:Vector3f):Void
	{
		var x:Float = vec.x;
        var y:Float = vec.y;
        var z:Float = vec.z;
        vec.x = m00 * x + m01 * y + m02 * z;
        vec.y = m10 * x + m11 * y + m12 * z;
        vec.z = m20 * x + m21 * y + m22 * z;
	}
	
	/**
     * <code>mult</code> multiplies this matrix by a given matrix. The result
     * matrix is saved in the current matrix. If the given matrix is null,
     * nothing happens. The current matrix is returned. This is equivalent to
     * this*=mat
     * 
     * @param mat
     *            the matrix to multiply this matrix by.
     * @return This matrix, after the multiplication
     */
	public inline function multLocal(mat:Matrix3f):Void
	{
		mult(mat, this);
	}
	
	/**
     * Transposes this matrix in place. Returns this matrix for chaining
     * 
     * @return This matrix after transpose
     */
	public inline function transposeLocal():Matrix3f
	{
		var tmp:Float = m01;
        m01 = m10;
        m10 = tmp;

        tmp = m02;
        m02 = m20;
        m20 = tmp;

        tmp = m12;
        m12 = m21;
        m21 = tmp;
		
		return this;
	}
	
	/**
     * Inverts this matrix as a new Matrix3f.
     * 
     * @return The new inverse matrix
     */
	public function invert(?result:Matrix3f=null):Matrix3f
	{
		if (result == null) result = new Matrix3f();
		 
		var det:Float = determinant(); 
		if (FastMath.fabs(det) <= FastMath.FLT_EPSILON)
		{
			result.zero();
			return result;
		}
		
		var fInvDet:Float = 1 / det;
		
		var f00:Float = (m11 * m22 - m12 * m21) * fInvDet;
        var f01:Float = (m02 * m21 - m01 * m22) * fInvDet;
        var f02:Float = (m01 * m12 - m02 * m11) * fInvDet;
        var f10:Float = (m12 * m20 - m10 * m22) * fInvDet;
        var f11:Float = (m00 * m22 - m02 * m20) * fInvDet;
        var f12:Float = (m02 * m10 - m00 * m12) * fInvDet;
        var f20:Float = (m10 * m21 - m11 * m20) * fInvDet;
        var f21:Float = (m01 * m20 - m00 * m21) * fInvDet;
        var f22:Float = (m00 * m11 - m01 * m10) * fInvDet;
		
		result.m00 = f00;
        result.m01 = f01;
        result.m02 = f02;
        result.m10 = f10;
        result.m11 = f11;
        result.m12 = f12;
        result.m20 = f20;
        result.m21 = f21;
        result.m22 = f22;

		return result;
	}
	
	/**
     * Inverts this matrix locally.
     * 
     * @return this
     */
	public function invertLocal():Matrix3f
	{
		return invert(this);
	}
	
	/**
     * Places the adjoint of this matrix in store (creates store if null.)
     * 
     * @param result
     *            The matrix to store the result in.  If null, a new matrix is created.
     * @return result
     */
	public function adjoint(?result:Matrix3f = null):Matrix3f
	{
		if (result == null) result = new Matrix3f();
		
		var f00:Float = m11 * m22 - m12 * m21;
        var f01:Float = m02 * m21 - m01 * m22;
        var f02:Float = m01 * m12 - m02 * m11;
        var f10:Float = m12 * m20 - m10 * m22;
        var f11:Float = m00 * m22 - m02 * m20;
        var f12:Float = m02 * m10 - m00 * m12;
        var f20:Float = m10 * m21 - m11 * m20;
        var f21:Float = m01 * m20 - m00 * m21;
        var f22:Float = m00 * m11 - m01 * m10;
		
		result.m00 = f00;
        result.m01 = f01;
        result.m02 = f02;
        result.m10 = f10;
        result.m11 = f11;
        result.m12 = f12;
        result.m20 = f20;
        result.m21 = f21;
        result.m22 = f22;

        return result;
	}
	
	/**
     * <code>determinant</code> generates the determinate of this matrix.
     * 
     * @return the determinate
     */
	public function determinant():Float
	{
		var fCo00:Float = m11 * m22 - m12 * m21;
        var fCo10:Float = m12 * m20 - m10 * m22;
        var fCo20:Float = m10 * m21 - m11 * m20;
        var fDet:Float = m00 * fCo00 + m01 * fCo10 + m02 * fCo20;
        return fDet;
	}
	
	/**
     * Sets all of the values in this matrix to zero.
     * 
     * @return this matrix
     */
	public function zero():Void
	{
		 m00 = m01 = m02 = m10 = m11 = m12 = m20 = m21 = m22 = 0.0;
	}
	
	/**
     * <code>transpose</code> <b>locally</b> transposes this Matrix.
     * This is inconsistent with general value vs local semantics, but is
     * preserved for backwards compatibility. Use transposeNew() to transpose
     * to a new object (value).
     * 
     * @return this object for chaining.
     */
	public inline function transposeNew():Matrix3f
	{
		return new Matrix3f([m00, m10, m20, m01, m11, m21, m02, m12, m22]);
	}
	
	/**
     * <code>toString</code> returns the string representation of this object.
     * It is in a format of a 3x3 matrix. For example, an identity matrix would
     * be represented by the following string. com.jme.math.Matrix3f <br>[<br>
     * 1.0  0.0  0.0 <br>
     * 0.0  1.0  0.0 <br>
     * 0.0  0.0  1.0 <br>]<br>
     * 
     * @return the string representation of this object.
     */
	public function toString():String
	{
		return "Matrix3f\n[ " +
		       m00 + "\t" + m01 + "\t" + m02 + "\n " +             
		       m10 + "\t" + m11 + "\t" + m12 + "\n " +                
		       m20 + "\t" + m21 + "\t" + m22 + "]";
	}
	
	public function clone(?result:Matrix3f):Matrix3f
	{
		if (result == null) result = new Matrix3f();
		result.copyFrom(this);
		return result;
	}
	
	/**
     * A function for creating a rotation matrix that rotates a vector called
     * "start" into another vector called "end".
     * 
     * @param start
     *            normalized non-zero starting vector
     * @param end
     *            normalized non-zero ending vector
     * @see "Tomas M�ller, John Hughes \"Efficiently Building a Matrix to Rotate \
     *      One Vector to Another\" Journal of Graphics Tools, 4(4):1-4, 1999"
     */
	public function fromStartAndEnd(start:Vector3f, end:Vector3f):Void
	{
		var e:Float, h:Float, f:Float;
		
		var v:Vector3f = start.cross(end);
		e = start.dot(end);
		f = (e < 0) ? -e : e;
		
		// if "from" and "to" vectors are nearly parallel
		if ( f > 1.0 - FastMath.ZERO_TOLERANCE)
		{
			var u:Vector3f = new Vector3f();
			var x:Vector3f = new Vector3f();
			var c1:Float, c2:Float, c3:Float;/* coefficients for later use */
			var i:Int, j:Int;
			
			 x.x = (start.x > 0.0) ? start.x : -start.x;
            x.y = (start.y > 0.0) ? start.y : -start.y;
            x.z = (start.z > 0.0) ? start.z : -start.z;

            if (x.x < x.y) 
			{
                if (x.x < x.z) 
				{
                    x.x = 1.0;
                    x.y = x.z = 0.0;
                } else 
				{
                    x.z = 1.0;
                    x.x = x.y = 0.0;
                }
            } 
			else 
			{
                if (x.y < x.z) 
				{
                    x.y = 1.0;
                    x.x = x.z = 0.0;
                } 
				else 
				{
                    x.z = 1.0;
                    x.x = x.y = 0.0;
                }
            }

            u.x = x.x - start.x;
            u.y = x.y - start.y;
            u.z = x.z - start.z;
            v.x = x.x - end.x;
            v.y = x.y - end.y;
            v.z = x.z - end.z;

            c1 = 2.0 / u.dot(u);
            c2 = 2.0 / v.dot(v);
            c3 = c1 * c2 * u.dot(v);
			
			for (i in 0...3) 
			{
                for (j in 0...3) 
				{
					var ui:Float = u.getValueAt(i);
					var uj:Float = u.getValueAt(j);
					var vi:Float = v.getValueAt(i);
					var vj:Float = v.getValueAt(j);
                    var val:Float = -c1 * ui * uj - c2 * vi * vj + c3 * vi * uj;
                    setValue(i, j, val);
                }
                var val:Float = getValue(i, i);
                setValue(i, i, val + 1.0);
            }
		}
		else 
		{
            // the most common case, unless "start"="end", or "start"=-"end"
            var hvx:Float, hvz:Float, hvxy:Float, hvxz:Float, hvyz:Float;
            h = 1.0 / (1.0 + e);
            hvx = h * v.x;
            hvz = h * v.z;
            hvxy = hvx * v.y;
            hvxz = hvx * v.z;
            hvyz = hvz * v.y;
            setValue(0, 0, e + hvx * v.x);
            setValue(0, 1, hvxy - v.z);
            setValue(0, 2, hvxz + v.y);

            setValue(1, 0, hvxy + v.z);
            setValue(1, 1, e + h * v.y * v.y);
            setValue(1, 2, hvyz - v.x);

            setValue(2, 0, hvxz - v.y);
            setValue(2, 1, hvyz + v.x);
            setValue(2, 2, e + hvz * v.z);
        }
	}
	
	public function setQuaternion(quaternion:Quaternion):Void
	{
		quaternion.toRotationMatrix3f(this);
	}
	
}